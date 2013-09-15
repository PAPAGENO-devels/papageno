#include "par_lex_lua_bracketed_strings.h"

//very very simple hash table for the array hash_end_stat_f
int32_t hash_end_stat_f_size;
int32_t * hash_end_stat_f;

//very very simple hash table for the array hash_begin_stat
int32_t hash_begin_stat_size;
int32_t * hash_begin_stat;

//very very simple hash table for the array hash_prev_minus
int32_t hash_prev_minus_size;
int32_t * hash_prev_minus;

//last token_node in the token list 1 which is linked to a token in token list 0 when a comment or a string or the end of a double list has been read 
token_node * last_linked_token1;  
token_node * last_linked_token1_next; //successor of last_linked_token1 in the token list 1

//data structures for the second phase of lexing
interrupted_bracketed_string * interrupted_string_builder, * interrupted_string_list;
int32_t rescanned_chunk_number = 0;

delimiter * handle_comment(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, delimiter *d, int32_t *current_thread, int8_t *current_branch, token_node *before_comment, int32_t before_comment_thread, uint8_t * check_end_chunk);
delimiter * next_matching_comment(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_matching_comment_thread, delimiter *current_comment, int32_t current_comment_thread, int8_t current_branch);
delimiter * next_delimiter(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_delimiter_thread, delimiter *current_delimiter, int32_t current_delimiter_thread);
delimiter * closure_matching_comment(lex_thread_arg *arg, int32_t lex_thread_num, delimiter* d_next, int32_t* d_next_thread, delimiter **closing_comment, int32_t* closing_comment_thread);
void link_tokens_before_after_comment(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, token_node * before_comment, int32_t before_comment_thread, token_node * after_comment, int32_t after_comment_thread, int8_t read_new_line, uint8_t * check_end_chunk);
delimiter * handle_bracket_delimiter(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, delimiter *d, int32_t *current_thread, int8_t * delimiter_branch, uint8_t * check_end_chunk);
int8_t check_tokens(token_node * t, token_node * t_next, int8_t read_new_line);
void initialize_flex_token(lex_token * flex_token);
void lexing_interrupted_bracketed_string(lex_thread_arg *arg, string_thread_arg * string_arg, int32_t string_thread_num);

/*Find the bounds of the file chunks that will be scanned by the lexing threads.*/
int32_t find_cut_points(FILE* f, int32_t file_length, int32_t **cut_points, int32_t lex_thread_max_num)
{
  int32_t i = 1, lex_thread_num = 1;
  int32_t c, prev_c, prev_prev_c;
  int8_t next = 1, read_z = 0;
  int32_t * cut_points_ptr = *cut_points;

  while (i<lex_thread_max_num && next)
  {
    fseek(f, cut_points_ptr[i], SEEK_SET);
    c = fgetc(f);

    //Find cut points avoiding to choose a newline inside a string which is preceded by / or by the escape sequence \z
    if(c == 'z' && !feof(f)){
       read_z = 1;
       c = fgetc(f);
     }

    while ((c == '\n' || c == ' ' || c == '\t' || c == '\f' || c == '\r' || c == '\v') && !feof(f))
      c = fgetc(f);

    //If input file contains only spaces, it is still accepted since the empty string belongs to the grammar.
    if(i == 1 && feof(f) && !read_z)
      return 0;

    //Since c!=\n and c!=\r and c cannot be the character z inside a sequence \z, in the first while iteration the value of prev_c and prev_prev_c is not relevant. 
    //Thus, they may also assume a value different from the actual characters preceding c.
    prev_c = ' ';
    prev_prev_c = ' '; 

    while (((c != '\n' && c!= '\r') || prev_c == '\\' || (prev_prev_c == '\\' && prev_c == 'z') || (c == '\r' && prev_c == '\n' && prev_prev_c == '\\') || (c == '\n' && prev_c == '\r' && prev_prev_c == '\\')) && !feof(f)) 
    {
      if (prev_prev_c == '\\' && prev_c == 'z')
          while ((c == '\n' || c == ' ' || c == '\t' || c == '\f' || c == '\r' || c == '\v') && !feof(f))
            c = fgetc(f);
      
      #if DEBUG
      if (prev_prev_c == '\\' && prev_c == 'z')
        DEBUG_STDOUT_PRINT("Read \\z: skipping spaces\n")    
      #endif    

      prev_prev_c = prev_c;
      prev_c = c;
      if (!feof(f))
        c = fgetc(f);
    }

    if (!feof(f))
      {
        cut_points_ptr[lex_thread_num] = ftell(f);
        while (i<lex_thread_max_num && cut_points_ptr[i]<=cut_points_ptr[lex_thread_num])
          i++;
        lex_thread_num++;
      }
    else
      next = 0;
  }

  //realloc cut_points
  if (lex_thread_num < lex_thread_max_num) {
    *cut_points = realloc(*cut_points, lex_thread_num);
    if (*cut_points == NULL){
        DEBUG_STDOUT_PRINT("ERROR> could not realloc cut_points. Aborting.\n");
        exit(1);
    }
  }  

  //lex_thread_num does not necessarily equals lex_thread_max_num
  return lex_thread_num;

}


/*Initialize thread arguments.*/
void initialize_thread_argument(lex_thread_arg* arg, int32_t thread)
{
  arg[thread].number_tokens_from_last_comment_string = 0;
  arg[thread].alloc_size[0] = 0;
  arg[thread].realloc_size[0] = 0;
  arg[thread].alloc_size[1] = 0;
  arg[thread].realloc_size[1] = 0;
  arg[thread].error_comment_or_bracketed_string = 0;
  arg[thread].first_closing_bracket = 0;
  arg[thread].first_closing_bracket_delim = NULL;
}


/*Merge token lists produced by the lexing threads.*/
void compute_lex_token_list(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num)
{  
  int32_t i = 0;
  token_node * t;
  uint8_t check_end_chunk[lex_thread_num];
  delimiter * d, * d1;
  int32_t current_thread = 0, next_delimiter_thread = 0;
  int32_t braces_difference = 0, added_tokens = 0;
  int8_t current_branch = 0;

  last_linked_token1 = NULL;
  last_linked_token1_next = NULL;

  //data structures for the second phase of lexing
  interrupted_string_list = NULL;
  interrupted_string_builder = NULL;
  rescanned_chunk_number = 0;
  string_thread_arg * string_arg;
 
  // Initialize hash tables:
  // ENDSTAT      (NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|RPAREN|RBRACK|NAME|END|BREAK|STRING)
  // ENDSTATF     (NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|END|BREAK|STRING) = ENDSTAT / {NAME, RPAREN, RBRACK}
  // BEGINSTAT    (LPAREN|NAME|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|FUNCTION|LOCAL)
  // PREVMINUS    ENDSTAT / {BREAK}

  int32_t* end_stat_f = (int[]) {NIL, FALSE, TRUE, NUMBER, DOT3, RBRACE, END, BREAK, STRING};  
  int32_t end_stat_f_length = 9;

  hash_end_stat_f_size = end_stat_f_length*end_stat_f_length;  //!!big size
  hash_end_stat_f = (int32_t *) malloc(sizeof(int32_t)*hash_end_stat_f_size);
  if (hash_end_stat_f == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc hash_end_stat_f. Aborting.\n");
    exit(1);
  }
  init_table(hash_end_stat_f, hash_end_stat_f_size, end_stat_f, end_stat_f_length);

  int32_t* begin_stat = (int[]) {LPAREN, NAME, COLON2, BREAK, GOTO, DO, WHILE, REPEAT, IF, FOR, FUNCTION, LOCAL};  
  int32_t begin_stat_length = 12;

  hash_begin_stat_size = begin_stat_length*begin_stat_length;  //!!big size
  hash_begin_stat = (int32_t *) malloc(sizeof(int32_t)*hash_begin_stat_size);
  if (hash_begin_stat == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc hash_begin_stat. Aborting.\n");
    exit(1);
  }
  init_table(hash_begin_stat, hash_begin_stat_size, begin_stat, begin_stat_length);

  int32_t* prev_minus = (int[]) {NIL, FALSE, TRUE, NUMBER, DOT3, RBRACE, RPAREN, RBRACK, NAME, END, STRING};  
  int32_t prev_minus_length = 11;

  hash_prev_minus_size = prev_minus_length*prev_minus_length;  //!!big size
  hash_prev_minus = (int32_t *) malloc(sizeof(int32_t)*hash_prev_minus_size);
  if (hash_prev_minus == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc hash_prev_minus. Aborting.\n");
    exit(1);
  }
  init_table(hash_prev_minus, hash_prev_minus_size, prev_minus, prev_minus_length);


  //Merge the token lists of the chunks.
  ctx->token_list_length = 0;
  
  i = 0;
  while (arg[i].list_begin[0] == NULL && i < lex_thread_num)
  {
    check_end_chunk[i] = 0;
    i++;
  }
  if (i == lex_thread_num)
  {//the whole token list is empty
    DEBUG_STDOUT_PRINT("ERROR> The whole token list is empty. Aborting.\n");
    exit(1);
  }

  int32_t first_nonempty_chunk = i;
  DEBUG_STDOUT_PRINT("LEXING> first_nonempty_chunk = %d.\n", i)

  ctx->token_list =  arg[i].list_begin[0];
  t = arg[i].list_end;
  check_end_chunk[i] = 1;
  i++;

  while (i < lex_thread_num)
  {
      while (i < lex_thread_num && arg[i].list_begin[0] == NULL)
      {
        check_end_chunk[i] = 0;
        i++;
      }
      if (i == lex_thread_num){
        t->next = NULL;
      }
      else{
        t->next = arg[i].list_begin[0];
        t = arg[i].list_end;
        check_end_chunk[i] = 1;
        i++;
      }
  }

  #ifdef DEBUG
  int8_t k, l;
  for (k = 0; k< lex_thread_num; k++){
    if (arg[k].list_begin[0] == NULL)
      DEBUG_STDOUT_PRINT("arg[%d].list_begin[0] is NULL\n", k)
    else
      DEBUG_STDOUT_PRINT("arg[%d].list_begin[0] is not NULL\n", k)
    DEBUG_STDOUT_PRINT("Check_end_chunk[%d] = %d\n", k, check_end_chunk[k])
    DEBUG_STDOUT_PRINT("error_comment_or_bracketed_string[%d] = %d\n", k, arg[k].error_comment_or_bracketed_string)
  }
  
  DEBUG_STDOUT_PRINT("delimiter lists:\n")
  delimiter * temp_delim[2];
  for(k = 0; k< lex_thread_num; k++)
  {
    temp_delim[0] = arg[k].delimiter_list[0];
    DEBUG_STDOUT_PRINT("Chunk %d has delimiters:\n", k)
    while(temp_delim[0] != NULL){
      if(temp_delim[0]->type_class == 0) {
        DEBUG_STDOUT_PRINT("token = %d = %s\n", temp_delim[0]->type.token, gr_token_to_string(temp_delim[0]->type.token))
        temp_delim[0] = temp_delim[0]->next[0];
      }
      else if (temp_delim[0]->type_class == 1) {
        DEBUG_STDOUT_PRINT("comment = %d with number_tokens_from_last_comment_string[0] = %d\n", temp_delim[0]->type.comment, temp_delim[0]->number_tokens_from_last_comment_string[0]) 
        temp_delim[0] = temp_delim[0]->next[0];
      }
      else {
        DEBUG_STDOUT_PRINT("delimiter = %d with number_tokens_from_last_comment_string[0] = %d, [1] = %d, error[0] = %d, [1] = %d\n", temp_delim[0]->type.bracket_delimiter, temp_delim[0]->number_tokens_from_last_comment_string[0],temp_delim[0]->number_tokens_from_last_comment_string[1], temp_delim[0]->error[0], temp_delim[0]->error[1]) 
        if (temp_delim[0]->type.bracket_delimiter == CLOSED_BRACKETS_IN_STRING || temp_delim[0]->type.bracket_delimiter == CLOSED_BRACKETS_IN_SINGLECOMMENT) {
          temp_delim[1] = temp_delim[0]->next[1];
          temp_delim[0] = temp_delim[0]->next[0];
          for (l = 0; l <= 1; l++)
            while (!((temp_delim[l]->type_class == 1 && temp_delim[l]->type.comment < 0) || (temp_delim[l]->type_class == 2 && (temp_delim[l]->type.bracket_delimiter == END_DOUBLE_LIST || temp_delim[l]->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE)))) {
              if(temp_delim[l]->type_class == 0)
                DEBUG_STDOUT_PRINT("DEBUG> in branch %d token = %d = %s\n",l, temp_delim[l]->type.token, gr_token_to_string(temp_delim[l]->type.token))
              else if (temp_delim[l]->type_class == 1)
                DEBUG_STDOUT_PRINT("DEBUG> in branch %d comment = %d with number_tokens_from_last_comment_string[%d] = %d\n",l, temp_delim[l]->type.comment, l, temp_delim[l]->number_tokens_from_last_comment_string[l]) 
              else
                DEBUG_STDOUT_PRINT("DEBUG> in branch %d delimiter = %d with number_tokens_from_last_comment_string[%d] = %d\n",l, temp_delim[l]->type.bracket_delimiter, l, temp_delim[l]->number_tokens_from_last_comment_string[l]) 
              temp_delim[l] = temp_delim[l]->next[l]; 
            } 
        }
        else
          temp_delim[0] = temp_delim[0]->next[0];
      }
    }
  }
  #endif

  //Scan the delimiters' list, and update the token list accordingly.
  //Find the first delimiter.
  d = arg[current_thread].delimiter_list[0];

  while (d == NULL && current_thread < lex_thread_num) 
  {
    //We have to check whether or not this chunk ended with an unexpected lexeme and it needed to be inside a comment or a bracketed string: if the chunk ended with
    //an unexpected lexeme, then yylex returned END_CHUNK_ERROR and arg[current_delimiter_thread]->error_comment_or_bracketed_string was set to 1.
    if (arg[current_thread].error_comment_or_bracketed_string == 1) {
      fprintf(stdout, "Unexpected character in the input file while reading chunk %d. Exit.\n", current_thread);
      exit(1);
    }
    current_thread++;
    d = arg[current_thread].delimiter_list[0];
  }

  while (d != NULL && current_thread < lex_thread_num) 
  {
    if (d->type_class == 0)
    {//the delimiter is a token. Current_branch can be 0 or 1.
      switch (d->type.token)
      {
        case XEQ:
          if (braces_difference > 0)
            d->last_token[current_branch]->token = EQ;
          if (current_branch == 0)
            d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          else
            d = d->next[1];
          break;
        case LBRACE:
          braces_difference++;
          if (current_branch == 0)
            d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          else
            d = d->next[1];
          break;
        case RBRACE:
          if (braces_difference == 0) {
            fprintf(stdout, "Input file has non balanced braces. Exit.\n");
            exit(1);
          }
          braces_difference--;
          if (current_branch == 0)
            d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          else
            d = d->next[1];
          break;  
        case SEMI:
          if (braces_difference > 0)
            d->last_token[0]->token = SEMIFIELD;
          if (current_branch == 0)
            d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          else
            d = d->next[1];
          break;  
        case FUNCTION:
          next_delimiter_thread = current_thread;
          int8_t next_branch = current_branch;
          if (current_branch == 0)
            d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d, current_thread);
          else
            d1 = d->next[1];
          //Handle all the possible comments which follow the delimiter FUNCTION (the comments can also be preceded by valid tokens),
          //so that all the tokens of the function body are correctly linked
          while (d1 != NULL) {
            if (d1->type_class == 1 && d1->type.comment != -1)
              d1 = handle_comment(ctx, arg, lex_thread_num, d1, &next_delimiter_thread, &next_branch, d1->last_token[next_branch], next_delimiter_thread, check_end_chunk);
            else if (d1->type_class == 2 && d1->type.bracket_delimiter == CLOSED_BRACKETS_IN_SINGLECOMMENT) {
              //here next_branch is necessarily 0
              d1 = d1->next[0];
              //consider the possible delimiters which immediately follow CLOSED_BRACKETS_IN_SINGLECOMMENT
              if (d1->type_class == 2 && (d1->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE || d1->type.bracket_delimiter == END_DOUBLE_LIST)) {
                d1 = handle_bracket_delimiter(ctx, arg, lex_thread_num, d1, &next_delimiter_thread, &next_branch, check_end_chunk);
              }
              else if (d1->type_class == 1) {
                d1 = handle_comment(ctx, arg, lex_thread_num, d1, &next_delimiter_thread, &next_branch, d1->last_token[next_branch], next_delimiter_thread, check_end_chunk);
              }
              //otherwise the analysis of delimiter d1 will be handled by the following checks of the switch.
            }
            else if (d1->type_class == 2 && (d1->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE || d1->type.bracket_delimiter == END_DOUBLE_LIST)) {
              d1 = handle_bracket_delimiter(ctx, arg, lex_thread_num, d1, &next_delimiter_thread, &next_branch, check_end_chunk);
            }
            else
              break;
          }
          //Replace LPAREN and RPAREN with tokens LPARENFUNC and RPARENFUNC.
          t = d->last_token[current_branch]; //token FUNCTION
          t = t->next;
          while (t!= NULL && (t->token == NAME || t->token == DOT || t->token == COLON))
            t = t->next;
          if (t!= NULL && t->token == LPAREN)
            t->token = LPARENFUNC;
          else if (t== NULL || t->token != LPARENFUNC){
            fprintf(stdout, "ERROR> Found function with incomplete body: there are missing parentheses. Exit.\n");
            exit(1);
          }
          t = t->next;
          while (t!= NULL && (t->token == NAME || t->token == DOT3 || t->token == COMMA))
            t = t->next;
          if (t!= NULL && t->token == RPAREN)
            t->token = RPARENFUNC;
          else{
            fprintf(stdout, "ERROR> Found function with incomplete body: there are missing parentheses. Exit.\n");
            exit(1);
          }
          //Check if the token following RPAREN is a SEMI and check if it must be removed from the token list or not.
          token_node * t1 = t->next;
          if (t1!= NULL && t1->token == SEMI)
          {//If the following delimiter is SEMI, then it has been already in the input file; otherwise it was added and must thus be removed.
            if(!(d1 != NULL && d1->type_class == 0 && d1->type.token == SEMI && d1->last_token[next_branch] == t1))
            {//Remove SEMI from the token list.
              t->next = t1->next;
              (ctx->token_list_length)--;
              DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
            }
          }
          current_thread = next_delimiter_thread;          
          d = d1;
          break;        
        default:
          DEBUG_STDOUT_PRINT("ERROR> Found unexpected token in the delimiter list. Aborting.\n");
          exit(1);
      }
    }
    else if (d->type_class == 1) { 
      //the delimiter is a comment symbol
      d = handle_comment(ctx, arg, lex_thread_num, d, &current_thread, &current_branch, d->last_token[current_branch], current_thread, check_end_chunk);
    }
    else {
      //the delimiter is a bracket delimiter
      d = handle_bracket_delimiter(ctx, arg, lex_thread_num, d, &current_thread, &current_branch, check_end_chunk);
    }

  }

  //Check whether a SEMI must be inserted between the end of the token list of a chunk and the beginning of the following one, and check the presence of token MINUS/UMINUS.
  for (i = first_nonempty_chunk; i < lex_thread_num -1; i++){
    if (check_end_chunk[i] == 1){
      //consider only the end of token list 0, since for tokens in different chunks, such that the first token is in token list 1, the check has already been done
      t = arg[i].list_end;
      added_tokens = check_tokens(t, t->next, 1);
      ctx->token_list_length += added_tokens;
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    }
  }

  //Update the length of the whole token list
  for (i = first_nonempty_chunk; i < lex_thread_num; i++){
    if (check_end_chunk[i] == 1){
      ctx->token_list_length += arg[i].number_tokens_from_last_comment_string;
      DEBUG_STDOUT_PRINT("thread %d; ctx->token_list_length = %d\n", i, ctx->token_list_length)
    }
  }

  //Handle interrupted bracketed strings, if there are any.
  if (interrupted_string_list != NULL) {
    string_arg = (string_thread_arg *) malloc(sizeof(string_thread_arg)*rescanned_chunk_number);
    if (string_arg == NULL) {
      DEBUG_STDOUT_PRINT("ERROR> string_arg = NULL after malloc\n")
        exit(1);
    }
    //Scan again the part of the bracketed strings which follows the interruption caused by the end of a chunk.
    lexing_interrupted_bracketed_string(arg, string_arg, rescanned_chunk_number);  
    
    //Concatenate the interrupted strings with their end
    interrupted_bracketed_string * current_string = interrupted_string_list;
    i = 0;
    int32_t total_string_length = 0, scanned_thread = 0, j;
    int32_t current_string_length = strlen(current_string->token_string->value);
    while (current_string != NULL) {
      //compute total length of the interrupted string
      j = scanned_thread;
      total_string_length = current_string_length; 
      DEBUG_STDOUT_PRINT("SECOND LEXING> Interrupted bracketed string %s has length %d.\n", current_string->token_string->value, total_string_length)
      for (i = current_string->chunk_token_string +1; i <= current_string->chunk_closed_brackets; i++) {
        total_string_length += string_arg[j].string_length;
        j++;
      }
      DEBUG_STDOUT_PRINT("SECOND LEXING> Interrupted bracketed string %s should have length %d.\n", current_string->token_string->value, total_string_length)
      //update value of the interrupted string
      if (total_string_length > current_string_length) {
        current_string->token_string->value = realloc(current_string->token_string->value, total_string_length + 1); //included final \0
        if (current_string->token_string->value == NULL) {
          DEBUG_STDOUT_PRINT("ERROR> could not realloc interrupted bracketed string. Aborting.\n");
          exit(1);
        }
      }
      for (i = current_string->chunk_token_string +1; i <= current_string->chunk_closed_brackets; i++) {
        DEBUG_STDOUT_PRINT("SECOND LEXING> Interrupted bracketed string concatenated with %s\n", string_arg[scanned_thread].chunk_string)
        strcat(current_string->token_string->value, string_arg[scanned_thread].chunk_string);
        scanned_thread++;
      }
      current_string = current_string->next;
    }   
  }

}

//Precondition of function handle_comment: d != NULL && current_thread < lex_thread_num && d->type_class == 1
delimiter * handle_comment(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, delimiter *d, int32_t *current_thread, int8_t *current_branch, token_node *before_comment, int32_t before_comment_thread, uint8_t * check_end_chunk)
{ //the delimiter is a comment symbol
  delimiter * d1;
  delimiter * closing_comment;
  token_node * after_comment;
  int32_t closing_comment_thread = 0, next_delimiter_thread = 0;
  int32_t after_comment_thread;
  if (d->type.comment > 0)
  {//the delimiter is a starting symbol --[=*[
    ctx->token_list_length += d->number_tokens_from_last_comment_string[*current_branch];
    DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    closing_comment = next_matching_comment(arg, lex_thread_num, &closing_comment_thread, d, *current_thread, *current_branch); 
    //now it is in branch 0, but *current_branch still denotes the branch of the delimiter d since it has not been changed
    //Check whether the comment is followed by other comments without valid tokens in between
    d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, closing_comment, closing_comment_thread);
    d1 = closure_matching_comment(arg, lex_thread_num, d1, &next_delimiter_thread, &closing_comment, &closing_comment_thread);

    //At this point, delimiter d1 is NULL or is not a starting comment symbol with number_tokens_from_last_comment_string == 0.
    //Link the tokens in the token list pointed to by d and closing_comment, bypassing the whole comment.
    after_comment = closing_comment->last_token[0];
    after_comment_thread = closing_comment_thread;

    //update last_linked_token1 and last_linked_token1_next before the successor of last_linked_token1 is changed
    if (*current_branch == 1) {
      last_linked_token1 = before_comment;
      last_linked_token1_next = last_linked_token1->next;
    }

    link_tokens_before_after_comment(ctx, arg, lex_thread_num, before_comment, before_comment_thread, after_comment, after_comment_thread, 1, check_end_chunk);

    //Update delimiter position
    *current_thread = next_delimiter_thread;
    *current_branch = 0;
    return d1;
  }
  else if (d->type.comment < 0)
  {//the delimiter is an ending symbol ]=*]
    if(d->type.comment == -1 && d->error[*current_branch] == 0)
    {//symbol ]] is not interpreted as a comment, but as the sequence of tokens RBRACK RBRACK
      ctx->token_list_length += d->number_tokens_from_last_comment_string[*current_branch];
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)

      //Check whether the comment is followed by other comments without valid tokens in between
      closing_comment = d;
      closing_comment_thread = *current_thread;
      d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d, *current_thread);
      d1 = closure_matching_comment(arg, lex_thread_num, d1, &next_delimiter_thread, &closing_comment, &closing_comment_thread);
      //before_comment is always not NULL since its last_token is a token RBRACK
      after_comment = closing_comment->last_token[0];
      after_comment_thread = closing_comment_thread;

      //update last_linked_token1 and last_linked_token1_next before the successor of last_linked_token1 is changed
      if (*current_branch == 1) {
        last_linked_token1 = before_comment;
        last_linked_token1_next = last_linked_token1->next;
      }

      link_tokens_before_after_comment(ctx, arg, lex_thread_num, before_comment, before_comment_thread, after_comment, after_comment_thread, 1, check_end_chunk);

      //Update delimiter position
      *current_thread = next_delimiter_thread;
      *current_branch = 0;
      return d1;
    }
    else{
        fprintf(stdout, "ERROR> Found closing comment symbol without previous matching opening one. Exit.\n");
        exit(1);
    }  
  }
  else
  {//Now d->type.comment is 0
    //The delimiter is the singleline comment symbol -- and it is followed by a symbol ]=*]
    d = d->next[*current_branch];
    ctx->token_list_length += d->number_tokens_from_last_comment_string[*current_branch];
    DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    //Check constraints on the tokens before and after the comment
    //Check whether the comment is followed by other comments without valid tokens in between
    closing_comment = d;
    closing_comment_thread = *current_thread;
    d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d, *current_thread);
    d1 = closure_matching_comment(arg, lex_thread_num, d1, &next_delimiter_thread, &closing_comment, &closing_comment_thread);
   
    after_comment = closing_comment->last_token[0];
    after_comment_thread = closing_comment_thread;

    //update last_linked_token1 and last_linked_token1_next before the successor of last_linked_token1 is changed
    if (*current_branch == 1) {
      last_linked_token1 = before_comment;
      last_linked_token1_next = last_linked_token1->next;
    }

    link_tokens_before_after_comment(ctx, arg, lex_thread_num, before_comment, before_comment_thread, after_comment, after_comment_thread, 1, check_end_chunk);

    *current_thread = next_delimiter_thread;
    *current_branch = 0;
    return d1;
  }  

}

delimiter * next_matching_comment(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_matching_comment_thread, delimiter *current_comment, int32_t current_comment_thread, int8_t current_branch)
{
  delimiter * matching_comment = current_comment->next[current_branch];
  uint8_t not_matching_comment = 1;
  while (not_matching_comment) {
    if (matching_comment == NULL) {
      //reached the end of the delimiter list of the chunk
      current_comment_thread++;
      if (current_comment_thread < lex_thread_num) {
        matching_comment = arg[current_comment_thread].delimiter_list[0];
      }
      else {
        DEBUG_STDOUT_PRINT("ERROR> Found open comment without matching closing symbol. Aborting.\n");
        exit(1);
      }
    }
    else if (matching_comment->type_class != 1 || matching_comment->type.comment + current_comment->type.comment != 0) {
      //the delimiter is neither a closing comment symbol nor the matching closing comment symbol.
      //If the end of the first double list has been reached, then change the current branch of the double list 
      if (current_branch == 1 && ((matching_comment->type_class == 2 && (matching_comment->type.bracket_delimiter == END_DOUBLE_LIST || matching_comment->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE)) \
        || (matching_comment->type_class == 1 && matching_comment->type.comment < 0)))
        current_branch = 0;
      //scan the next delimiter
      matching_comment = matching_comment->next[current_branch];
    }
    else
      not_matching_comment = 0;
  }
  *next_matching_comment_thread = current_comment_thread;
  return matching_comment;
}

/*Return the next delimiter of a token in token list 0*/
delimiter * next_delimiter(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_delimiter_thread, delimiter *current_delimiter, int32_t current_delimiter_thread)
{
  //This function is never called from within branch 1 of a double list
  if (current_delimiter->next[0] != NULL){
    *next_delimiter_thread = current_delimiter_thread;
    return current_delimiter->next[0];
  }
  //else the end of the delimiter list of the chunk has been reached.
  //This ending part of the chunk is not inside a comment; otherwise function next_matching_comment would have been called while processing it.
  //Thus, we have to check whether or not this chunk ended with an unexpected lexeme and it needed instead to be inside a comment.
  //If the chunk ended with an unexpected lexeme, then yylex returned END_CHUNK_ERROR and arg[current_delimiter_thread]->error_comment_or_bracketed_string was set to 1.
  if (arg[current_delimiter_thread].error_comment_or_bracketed_string == 1) {
    DEBUG_STDOUT_PRINT("Found error in next_delimiter> Current delimiter has type class = %d:\n", current_delimiter->type_class)
    fprintf(stdout, "ERROR> Unexpected character in the input file while reading the end of chunk %d. Exit.\n", current_delimiter_thread);
    exit(1);
  }
  //Finds the next delimiter
  current_delimiter_thread++;
  while (current_delimiter_thread < lex_thread_num && arg[current_delimiter_thread].delimiter_list[0] == NULL){
    if (arg[current_delimiter_thread].error_comment_or_bracketed_string == 1) {
      DEBUG_STDOUT_PRINT("Found error in next_delimiter:\n")
      fprintf(stdout, "ERROR> Unexpected character in the input file while reading the end of chunk %d. Exit.\n", current_delimiter_thread);
      exit(1);
    }    
    current_delimiter_thread++;
  }
  if (current_delimiter_thread == lex_thread_num) {
    *next_delimiter_thread = current_delimiter_thread;
    return NULL;
  }
  else {
    *next_delimiter_thread = current_delimiter_thread;
    return arg[current_delimiter_thread].delimiter_list[0];
  }

}

/*Check whether d_next is a comment, possibly followed by other comments, and all of them, included d_next, are not preceded by valid tokens.
If this is the case, at the end of the function closing_comment will be the last closing symbol of such a sequence of comments, otherwise it does not change value
w.r.t the call of the function; closing_comment_thread is the number of the chunk associated to the delimiter closing_comment_thread.
Precondition: this function is never called from within branch 1 of a double list.*/
delimiter * closure_matching_comment(lex_thread_arg *arg, int32_t lex_thread_num, delimiter* d_next, int32_t* d_next_thread, delimiter **closing_comment, int32_t* closing_comment_thread)
{  
  uint8_t next = 1;
  while (next && d_next != NULL && ((d_next->type_class == 1 && d_next->type.comment >= 0) || (d_next->type_class == 2 && d_next->type.bracket_delimiter == CLOSED_BRACKETS_IN_SINGLECOMMENT)))
  {
    next = 0;
    if (d_next->type_class == 1 && d_next->type.comment == 0 && d_next->next[0]->number_tokens_from_last_comment_string[0] == 0) {
      next = 1;
      *closing_comment = d_next->next[0]; //singleline comment symbol -- is followed by ]=*]
      *closing_comment_thread = *d_next_thread;
      d_next = next_delimiter(arg, lex_thread_num, d_next_thread, *closing_comment, *d_next_thread);
    }
    else if (d_next->type_class == 1 && d_next->type.comment > 0 && d_next->number_tokens_from_last_comment_string[0] == 0) {
      next = 1;
      //branch is 0
      *closing_comment = next_matching_comment(arg, lex_thread_num, closing_comment_thread, d_next, *d_next_thread, 0);
      d_next = next_delimiter(arg, lex_thread_num, d_next_thread, *closing_comment, *d_next_thread);
    }
    else if (d_next->type_class == 2) { // inside branch 0 of the double list
      if (d_next->next[0]->type_class == 2 && (d_next->next[0]->type.bracket_delimiter == END_DOUBLE_LIST || d_next->next[0]->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE)) {
        if (d_next->next[0]->error[0] != 0) {
          fprintf(stdout, "ERROR> Unexpected character in input file. Exit.\n");
          exit(1);
        }
        if (d_next->next[0]->number_tokens_from_last_comment_string[0] == 0) {
          next = 1;
          *closing_comment = d_next->next[0]; 
          *closing_comment_thread = *d_next_thread;      
          d_next = next_delimiter(arg, lex_thread_num, d_next_thread, *closing_comment, *d_next_thread);
        }
        //otherwise, if number_tokens_from_last_comment_string != 0, delimiter d_next will be handled at the next check of the switch
      }
      else if (d_next->next[0]->type_class == 1 && d_next->next[0]->type.comment >= 0) {
        //CLOSED_BRACKETS_IN_SINGLECOMMENT is immediately followed by a comment
        next = 1;
        d_next = d_next->next[0];
      }
    }
  }
  return d_next;
}


void link_tokens_before_after_comment(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, token_node * before_comment, int32_t before_comment_thread, token_node * after_comment, int32_t after_comment_thread, int8_t read_new_line, uint8_t * check_end_chunk)
{
  int32_t i, added_tokens = 0;

  if (after_comment != NULL)
    after_comment = after_comment->next;
  else{
    after_comment = arg[after_comment_thread].list_begin[0];
    while (after_comment_thread < lex_thread_num && after_comment == NULL) {
      after_comment_thread++;
      after_comment = arg[after_comment_thread].list_begin[0];
    }
  }

  //For comments of type < 0, before_comment is always not NULL since its last_token is a token RBRACK
  if(before_comment != NULL){
    before_comment->next = after_comment;
    added_tokens = check_tokens(before_comment, after_comment, read_new_line);
    ctx->token_list_length += added_tokens;
    DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
  }
  else
  {//the comment is at the beginning of a chunk
    if (arg[before_comment_thread].list_begin[0] == ctx->token_list)
    {//set the new beginning of the first non-empty chunk
      before_comment = after_comment;
      ctx->token_list = before_comment;
    }
    else
    {//find the closest end of the token list of a non-empty chunk
      before_comment_thread--;
      while (arg[before_comment_thread].list_end == NULL){
        before_comment_thread--;
      }
      before_comment = arg[before_comment_thread].list_end;
      before_comment->next = after_comment;
      //check_end_chunk[before_comment_thread] can be left equal to 1, so that the token pointed to by before_comment (which is at the end of this chunk)
      //and the token after_comment will be checked in the final loop in function compute_lex_token_list.
      //Thus, here we increment before_comment_thread so that the corresponding value of check_end_chunk is not reset.
      //Furthermore, leaving check_end_chunk[before_comment_thread] equal to 1, the length of the token list will be later on correctly updated by adding to it 
      //the number of tokens of this chunk, i.e. arg[before_comment_thread].number_tokens_from_last_comment_string[0].
      before_comment_thread++;
    }
  }

  for (i = before_comment_thread; i < after_comment_thread; i++) {
    DEBUG_STDOUT_PRINT("DEBUG> in link_tokens_before_after_comment. Set check_end_chunk[%d] = 0\n", i)
    check_end_chunk[i] = 0;
  }
}

delimiter * handle_bracket_delimiter(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, delimiter *d, int32_t *current_thread, int8_t * delimiter_branch, uint8_t * check_end_chunk)
{
  delimiter * d1, * d2, * closing_comment;
  token_node * before_comment, * after_comment;
  int32_t next_delimiter_thread = *current_thread;
  int32_t closing_comment_thread, i;
  int32_t before_comment_thread, after_comment_thread;
  int8_t branch = *delimiter_branch;

  switch (d->type.bracket_delimiter) {
    case OPEN_BRACKETS:
      ctx->token_list_length += d->number_tokens_from_last_comment_string[*delimiter_branch];
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
      d1 = d->next[*delimiter_branch]; 
      while (d1 != NULL && (d1->type_class == 0 || (d1->type_class == 1 && d1->type.comment != -1) || \
                            (d1->type_class == 2 && (d1->type.bracket_delimiter == OPEN_BRACKETS || d1->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE || d1->type.bracket_delimiter == END_DOUBLE_LIST || d1->type.bracket_delimiter == ERROR_STRING_CHAR_MAX)))) {
        if (d1->type_class == 2 && ((d1->type.bracket_delimiter == END_DOUBLE_LIST && d1->error[*delimiter_branch] != 0) || d1->type.bracket_delimiter == ERROR_STRING_CHAR_MAX)) {
          fprintf(stdout, "ERROR> Found bracketed string with errors. Exit.\n");
          exit(1);
        }
        if (branch == 1 && (d1->type_class == 2 && (d1->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE || d1->type.bracket_delimiter == END_DOUBLE_LIST) || (d1->type_class == 1 && d1->type.comment < 0)))
          branch = 0;
        d1 = d1->next[branch];
      }
      if (d1 == NULL) {//the delimiter can be NULL only in branch 0, since the branch 1 of the double list is always ended by a delimiter of the previous types
        while (next_delimiter_thread < lex_thread_num && arg[next_delimiter_thread].first_closing_bracket == 0) {
          next_delimiter_thread++;
        }
        if (next_delimiter_thread == lex_thread_num) {
          fprintf(stdout, "ERROR> Found bracketed string with missing closing brackets. Exit.\n");
          exit(1);
        }
        //record interrupted bracketed string
        append_interrupted_bracketed_string(d->last_token[*delimiter_branch], *current_thread, next_delimiter_thread, &interrupted_string_builder, &interrupted_string_list);
        rescanned_chunk_number++;
    
        //set the delimiter to that pointing to the first pair of closing brackets of the chunk
        d1 = arg[next_delimiter_thread].first_closing_bracket_delim;
      }
      if (d1->type_class == 2) {
        switch (d1->type.bracket_delimiter) {
          case CLOSED_BRACKETS: 
          case CLOSED_BRACKETS_NOT_RBRACK_RBRACK:
            //branch is necessarily 0.
            #ifdef DEBUG
              assert(branch == 0);
            #endif
            //Do not update ctx->token_list_length since the closed brackets are not interpreted as the sequence RBRACK RBRACK, but as the end of the bracketed string.
            //Check whether the delimiter is followed by other comments without valid tokens in between
            closing_comment = d1;
            closing_comment_thread = next_delimiter_thread;
            d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, closing_comment, closing_comment_thread);
            d1 = closure_matching_comment(arg, lex_thread_num, d1, &next_delimiter_thread, &closing_comment, &closing_comment_thread);

            //Link token STRING with the token following the closing brackets.
            //check_tokens is not called, since there is no newline and, after reading CLOSED_BRACKETS, it reaches state endStat1 or endStat2.
            before_comment = d->last_token[*delimiter_branch]; //before_comment is always not NULL since its last_token is a token RBRACK
            after_comment = closing_comment->last_token[0];
            after_comment_thread = closing_comment_thread;
            before_comment_thread = *current_thread;
            if (after_comment != NULL)
              after_comment = after_comment->next;
            else{
              after_comment = arg[after_comment_thread].list_begin[0];
              while (after_comment_thread < lex_thread_num && after_comment == NULL) {
                after_comment_thread++;                
                after_comment = arg[after_comment_thread].list_begin[0];
              }
            }
            before_comment->next = after_comment;
            for (i = before_comment_thread; i < after_comment_thread; i++) {
              check_end_chunk[i] = 0;
            }
            break;           
          case CLOSED_BRACKETS_IN_STRING:
          case CLOSED_BRACKETS_IN_SINGLECOMMENT:
            d2 = d1->next[1]; //d2 is the first delimiter of the branch 1 of the the double list (or the end of the double list, if there is no other delimiter)
            branch = 1; 
            //Do not update ctx->token_list_length.
            //In the following, consider only the relevant cases for the delimiters that can immediately follow CLOSED_BRACKETS_IN_STRING|CLOSED_BRACKETS_IN_SINGLECOMMENT
            //For the other possible delimiters occurring in branch 1 of the double list, the analysis will be done by the function which called handle_bracket_delimiter.
            if (d2->type_class == 1) { 
              if (d2->number_tokens_from_last_comment_string[1] != 0) {
                //Link token STRING with the token following the closing brackets.
                //check_tokens is not called, since there is no newline and, after reading CLOSED_BRACKETS_IN_STRING|CLOSED_BRACKETS_IN_SINGLECOMMENT, it reaches state endStat1.
                if (d1->last_token[branch] == NULL)
                  d->last_token[*delimiter_branch]->next = arg[next_delimiter_thread].list_begin[1];
                else if (d1->last_token[branch] == last_linked_token1)
                  d->last_token[*delimiter_branch]->next = last_linked_token1_next;
                else
                  d->last_token[*delimiter_branch]->next = d1->last_token[branch]->next;
                //update check_end_chunk
                for (i = *current_thread; i < next_delimiter_thread; i++) {
                  check_end_chunk[i] = 0;
                }
                d1 = handle_comment(ctx, arg, lex_thread_num, d2, &next_delimiter_thread, &branch, d2->last_token[1], next_delimiter_thread, check_end_chunk);
              }
              else {
                d1 = handle_comment(ctx, arg, lex_thread_num, d2, &next_delimiter_thread, &branch, d->last_token[*delimiter_branch], *current_thread, check_end_chunk);
              }
            }
            else {
              //otherwise, the analysis of delimiter d1 will be handled by the function which called handle_bracket_delimiter.
              //Only link token STRING with the token following the closing brackets.
              //check_tokens is not called, since there is no newline and, after reading CLOSED_BRACKETS_IN_STRING|CLOSED_BRACKETS_IN_SINGLECOMMENT, it reaches state endStat1.
              if (d1->last_token[branch] == NULL)
                  d->last_token[*delimiter_branch]->next = arg[next_delimiter_thread].list_begin[1];
              else if (d1->last_token[branch] == last_linked_token1)
                d->last_token[*delimiter_branch]->next = last_linked_token1_next;
              else
                d->last_token[*delimiter_branch]->next = d1->last_token[branch]->next;
              //update check_end_chunk
              for (i = *current_thread; i < next_delimiter_thread; i++) {
                DEBUG_STDOUT_PRINT("DEBUG> in handle_bracket_delimiter. Read a delimiter after OPEN_BRACKETS. Set check_end_chunk[%d] = 0\n", i)
                check_end_chunk[i] = 0;
              }  
              d1 = d2;
            }
            break; 
          default:
            DEBUG_STDOUT_PRINT("ERROR> After reading OPEN_BRACKETS, found a case in the switch which is not handled. Aborting.\n");
            exit(1);
            break;            
        }
      }
      else {//Here d1->type_class is 1 and d1->type.comment == -1
        //The closing comment symbol ]]\n is interpreted as the end of the bracketed string.
        //Do not update ctx->token_list_length.        
        //Check whether the comment symbol is followed by other comments without valid tokens in between
        closing_comment = d1;
        closing_comment_thread = next_delimiter_thread;
        d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, closing_comment, closing_comment_thread);
        d1 = closure_matching_comment(arg, lex_thread_num, d1, &next_delimiter_thread, &closing_comment, &closing_comment_thread);
        
        //Link token STRING with the token following the closing brackets.        
        //Do the check for the token STRING and the token following the closing brackets.
        before_comment = d->last_token[*delimiter_branch]; //before_comment is not NULL
        before_comment_thread = *current_thread;
        after_comment = closing_comment->last_token[0];
        after_comment_thread = closing_comment_thread;

        //update last_linked_token1 and last_linked_token1_next before the successor of last_linked_token1 is changed
        if (*delimiter_branch == 1) {
          last_linked_token1 = before_comment;
          last_linked_token1_next = last_linked_token1->next;
        }

        link_tokens_before_after_comment(ctx, arg, lex_thread_num, before_comment, before_comment_thread, after_comment, after_comment_thread, 1, check_end_chunk);                        
        branch = 0;
      }
      break;
    case CLOSED_BRACKETS:
      //It is interpreted as the sequence RBRACK RBRACK, not followed by newline; 
      //since it always leads to state endStat2, there is no need for checking the following token.
      //Ignore the delimiter and continue
      ctx->token_list_length += d->number_tokens_from_last_comment_string[*delimiter_branch];
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
      d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d, *current_thread);
      break; 
    case CLOSED_BRACKETS_NOT_RBRACK_RBRACK:
      //It cannot be interpreted as the sequence RBRACK RBRACK, so there is an error.
      fprintf(stdout, "ERROR> Unexpected characters ]] in the input file. Exit.\n");
      exit(1);
      break; 
    case CLOSED_BRACKETS_IN_STRING:
    case CLOSED_BRACKETS_IN_SINGLECOMMENT:
      //Beginning of a double list. Follow branch 0.
      d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread,  d, *current_thread);
      break; 
    case END_DOUBLE_LIST_NEWLINE:
    case END_DOUBLE_LIST:
      //*delimiter_branch can be 0 or 1 
      if (d->error[*delimiter_branch] == 1) {
        fprintf(stdout, "ERROR> Unexpected character in the input file. Exit.\n");
        exit(1);
      }
      ctx->token_list_length += d->number_tokens_from_last_comment_string[*delimiter_branch];
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
      //Do the check between the token preceding the insertion of END_DOUBLE_LIST|END_DOUBLE_LIST_NEWLINE and the token following it (bypassing possible subsequent 
      //comments which do not have valid tokens in between).
      //Check whether END_DOUBLE_LIST|END_DOUBLE_LIST_NEWLINE is followed by other comments without valid tokens in between
      before_comment = d->last_token[*delimiter_branch];
      before_comment_thread = *current_thread;

      //update last_linked_token1 and last_linked_token1_next before the successor of last_linked_token1 is changed
      if (*delimiter_branch == 1) {
        last_linked_token1 = before_comment;
        last_linked_token1_next = last_linked_token1->next;
      }

      closing_comment = d;
      closing_comment_thread = before_comment_thread;
      d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, closing_comment, closing_comment_thread);
      d1 = closure_matching_comment(arg, lex_thread_num, d1, &next_delimiter_thread, &closing_comment, &closing_comment_thread);

      after_comment = closing_comment->last_token[0];
      after_comment_thread = closing_comment_thread;

      //bypass END_DOUBLE_LIST|END_DOUBLE_LIST_NEWLINE and the comments that follow them and that are not preceded by valid tokens
      if (d->type.bracket_delimiter == END_DOUBLE_LIST_NEWLINE) 
        link_tokens_before_after_comment(ctx, arg, lex_thread_num, before_comment, before_comment_thread, after_comment, after_comment_thread, 1, check_end_chunk);
      else 
        link_tokens_before_after_comment(ctx, arg, lex_thread_num, before_comment, before_comment_thread, after_comment, after_comment_thread, 0, check_end_chunk);
      branch = 0;
      break;     
    case ERROR_STRING_CHAR_MAX:
      fprintf(stdout, "ERROR> Unexpected character in the input file. Exit.\n");
      exit(1);
      break;  
  }

  *current_thread = next_delimiter_thread;
  *delimiter_branch = branch;
  return d1;
}

/*Given two tokens separated by newline, checks the constraints needed to put the grammar in operator precedence form.*/
int8_t check_tokens(token_node * t, token_node * t_next, int8_t read_new_line)
{
  // Hash tables:
  // ENDSTAT      (NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|RPAREN|RBRACK|NAME|END|BREAK|STRING)
  // BEGINSTAT      (LPAREN|NAME|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|FUNCTION|LOCAL)
  // ENDSTATF     (NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|END|BREAK|STRING) = ENDSTAT/{NAME, RPAREN, RBRACK}
  // PREVMINUS     ENDSTAT / {BREAK}

  if (t == NULL || t_next == NULL)
    return 0;
  gr_token token = t->token, token_next = t_next->token;
  int8_t added_tokens = 0;

  //1)If there is pattern end_statement \n begin_statement, except for 'NAME \n (' and '] \n (' and ') \n (', 
  //e.g. if (token in ENDSTATF && next_token in BEGINSTAT) or if (token in {NAME, RBRACK, RPAREN} && next_token in BEGINSTAT / {LPAREN}),
  //then add token SEMI
  if(read_new_line && lookup(token_next, hash_begin_stat, hash_begin_stat_size) && (lookup(token, hash_end_stat_f, hash_end_stat_f_size) || ((token == NAME || token == RPAREN || token == RBRACK) && token_next != LPAREN)))
  {
    //add token SEMI to the token list
    token_node * new_node = new_token_node(SEMI, ";");
    t->next = new_node;
    new_node->next = t_next;
    added_tokens = 1;
    DEBUG_STDOUT_PRINT("Added SEMI while checking adjacent tokens: %d = %s and %d = %s\n", token, gr_token_to_string(token), token_next, gr_token_to_string(token_next))
  }
  //2)When '-' is preceded by tokens in hash_prev_minus, rename token as MINUS
  else if (token_next == UMINUS && lookup(token, hash_prev_minus, hash_prev_minus_size))
    t_next->token = MINUS;

  return added_tokens;
}

/*Thread task function for reentrant scanner.*/
void *lex_thread_task(void *arg)
{  
  lex_thread_arg *ar = (lex_thread_arg*) arg;
  
  FILE * f = fopen(ar->file_name, "r");
  if (f == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> Lexing thread %d could not open input file. Aborting.\n", ar->id);
    exit(1);
  }

  lex_token *flex_token;
  yyscan_t scanner;   //reentrant flex instance data
  int32_t flex_return_code;
  token_node *token_builder[2];
  delimiter *delimiter_builder[2]; 
  delimiter_builder[0] = NULL;
  delimiter_builder[1] = NULL;
  token_node_stack stack[2];
  delimiter_stack delim_stack[2];
  delimiter_type delimiter_union;
  int8_t token_list_number;

  int8_t first_closing_bracket = 1;
  
  //If yylex returns token FUNCTION, the lexer thread assigns to function_token_pos the position of FUNCTION in the token list 
  //and it assigns to function_current_delim_pos the current position in the delimiters' list (which is NULL if this list is empty).
  token_node *function_token_pos = NULL;
  delimiter *function_current_delim_pos = NULL;
  uint8_t function_token_list_number;

  uint32_t alloc_size[2], realloc_size[2];
  uint32_t delimiter_alloc_size[2], delimiter_realloc_size[2];

  alloc_size[0] = 0;
  realloc_size[0] = 0;
  delimiter_alloc_size[0] = 0; 
  delimiter_realloc_size[0] = 0;

  /*Associate to each comment symbol in the delimiter list the number of tokens read since the previous comment symbol of the delimiter list. 
  These numbers are needed to compute subsequently the length of the final token list, which is used by the parser.*/
  uint32_t number_tokens_from_last_comment_string[2];
  number_tokens_from_last_comment_string[0] = 0;
  number_tokens_from_last_comment_string[1] = 0;    

  uint32_t chunk_length = ar->cut_point_dx - ar->cut_point_sx;

  par_compute_alloc_realloc_size(chunk_length, &(alloc_size[0]), &(realloc_size[0]));
  alloc_size[1] = alloc_size[0];
  realloc_size[1] = realloc_size[0];
  par_delimiter_compute_alloc_realloc_size(chunk_length, &(delimiter_alloc_size[0]), &(delimiter_realloc_size[0]));  
  delimiter_alloc_size[1] = delimiter_alloc_size[0]; 
  delimiter_realloc_size[1] = delimiter_realloc_size[0];
  DEBUG_STDOUT_PRINT("LEXER %d > alloc_size %d, realloc_size %d\n", ar->id, alloc_size[0], realloc_size[0])
  DEBUG_STDOUT_PRINT("LEXER %d > delimiter_alloc_size %d, delimiter_realloc_size %d\n", ar->id, delimiter_alloc_size[0], delimiter_realloc_size[0])

  /*Initialization flex_token*/
  flex_token = (lex_token*) malloc(sizeof(lex_token));
  if (flex_token == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc flex_token. Aborting.\n");
    exit(1);
  }
  flex_token->chunk_length = chunk_length;
  initialize_flex_token(flex_token);

  fseek(f, ar->cut_point_sx, SEEK_SET);

  if (yylex_init_extra(flex_token, &scanner))
  {
    DEBUG_STDOUT_PRINT("ERROR> yylex_init_extra failed.\n")
    exit(1);
  }

  yyset_in(f, scanner);
  
  ar->list_begin[0] = NULL;
  ar->list_begin[1] = NULL;
  init_token_node_stack(&(stack[0]), alloc_size[0]);
  init_token_node_stack(&(stack[1]), alloc_size[1]);
  init_delimiter_stack(&(delim_stack[0]), delimiter_alloc_size[0]);
  init_delimiter_stack(&(delim_stack[1]), delimiter_alloc_size[1]);

  int8_t end_of_chunk = 0;

  flex_return_code = yylex(scanner);

  while (flex_return_code != END_OF_FILE && !end_of_chunk)
  {
    token_list_number = flex_token->insert_token_in_list;

    switch(flex_return_code){
      case LEX_CORRECT:
        par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
        number_tokens_from_last_comment_string[token_list_number]++;
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        if (flex_token->token == FUNCTION) {
          function_token_pos = token_builder[token_list_number];
          function_current_delim_pos = delimiter_builder[token_list_number];
          function_token_list_number = token_list_number;
        }
        break;
      case LEX_CORRECT_INSERT_RBRACK_RBRACK:
        par_append_token_node(RBRACK, "]", &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        par_append_token_node(RBRACK, "]", &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        DEBUG_STDOUT_PRINT("Lexing thread %d put tokens RBRACK RBRACK in the token list.\n", ar->id)
        number_tokens_from_last_comment_string[token_list_number] += 2;
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        break;
      case ADD_SEMI:
        //append both SEMI and token to the token list
        par_append_token_node(SEMI, ";", &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        DEBUG_STDOUT_PRINT("Lexing thread %d added token SEMI\n", ar->id)           
        par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])     
        number_tokens_from_last_comment_string[token_list_number] += 2;
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        if (flex_token->token == FUNCTION) {
          function_token_pos = token_builder[token_list_number];
          function_current_delim_pos = delimiter_builder[token_list_number];
          function_token_list_number = token_list_number;
        }
        break;
      case INSERT_DELIMITER:
        if (flex_token->token != FUNCTION){
          par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
          number_tokens_from_last_comment_string[token_list_number]++;
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
          //Insert delimiter into the delimiter list.
          delimiter_union.token = flex_token->token;
          par_append_delimiter(delimiter_union, 0, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])     
        }
        else{
          //Insert delimiter FUNCTION at the saved position
          delimiter_union.token = FUNCTION;
          par_insert_delimiter(delimiter_union, 0, token_list_number, function_token_pos, &(delimiter_builder[token_list_number]), function_current_delim_pos, &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
        }
        break;
      case INSERT_COMMENT:
        if (flex_token->comment_type == -1) {
          if (flex_token->error[0] == 0) {
            par_append_token_node( RBRACK, "]", &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
            par_append_token_node( RBRACK, "]", &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
            DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
            number_tokens_from_last_comment_string[0] += 2; 
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
          }
          else if (flex_token->double_list_ended == 1 && flex_token->error[1] == 0) {
            par_append_token_node( RBRACK, "]", &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
            par_append_token_node( RBRACK, "]", &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
            DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
            number_tokens_from_last_comment_string[1] += 2; 
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[1] = %d\n", ar->id, number_tokens_from_last_comment_string[1])
          }
        }
        delimiter_union.comment = flex_token->comment_type;
        if (flex_token->comment_type > 0) {
          par_append_delimiter(delimiter_union, 1, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          delimiter_builder[token_list_number]->number_tokens_from_last_comment_string[token_list_number] = number_tokens_from_last_comment_string[token_list_number];
          //reset counter of number tokens
          number_tokens_from_last_comment_string[token_list_number] = 0;
        }
        else if (flex_token->comment_type == -1) {
          par_append_delimiter(delimiter_union, 1, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
            }
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          //set error field
          delimiter_builder[0]->error[0] = flex_token->error[0];
          if (flex_token->double_list_ended == 1) {
            delimiter_builder[0]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
            number_tokens_from_last_comment_string[1] = 0;
            delimiter_builder[0]->error[1] = flex_token->error[1];
          }
        }
        else {
          //flex_token->comment_type must be < -1, since single_comment is not handled here. The number of tokens is never read in ]=+]\n delimiter.
          par_append_delimiter(delimiter_union, 1, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          number_tokens_from_last_comment_string[1] = 0;
        }          
        if (flex_token->double_list_ended == 1) {
          //Set both last_token[0] and last_token[1]
          delimiter_builder[0]->last_token[1] = token_builder[1];
        }
        DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->comment_type)     

        if (flex_token->insert_function == 1){
          //Insert delimiter FUNCTION at the saved position
          flex_token->insert_function = 0;
          delimiter_union.token = FUNCTION;
          par_insert_delimiter(delimiter_union, 0, token_list_number, function_token_pos, &(delimiter_builder[token_list_number]), function_current_delim_pos, &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
        }
        break;
      case INSERT_SINGLEMULTICOMMENT:
        if (flex_token->double_list_ended == 0){
          //insert both a singleline and a multiline comment in the list of delimiters flex_token->insert_token_in_list
          delimiter_union.comment = 0;
          par_append_delimiter(delimiter_union, 1, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter 0 for -- singleline comment\n", ar->id)     
          delimiter_union.comment = flex_token->comment_type;
          par_append_delimiter(delimiter_union, 1, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          number_tokens_from_last_comment_string[1] = 0;
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->comment_type)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
          if (flex_token->comment_type == -1) {
            if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
            }
            //set error field
            delimiter_builder[0]->error[0] = flex_token->error[0];
          }
        }
        else { //end of the double list of delimiters
          if (token_list_number != 2){
            par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
            DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
            number_tokens_from_last_comment_string[token_list_number]++;
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
          }
          //insert singlecomment -- in the delimiter list denoted by flex_token->insert_single_comment_in_list 
          delimiter_union.comment = 0;
          if (flex_token->insert_single_comment_in_list == 3) {
            //insert singleline comment in both branches
            par_append_delimiter(delimiter_union, 1, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter 0 for -- singleline comment\n", ar->id) 
            par_append_delimiter(delimiter_union, 1, 1, token_builder[1], &(delimiter_builder[1]), &(ar->delimiter_list[1]), &(delim_stack[1]), delimiter_realloc_size[1]);
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter 0 for -- singleline comment\n", ar->id) 
          }
          else {
            par_append_delimiter(delimiter_union, 1, flex_token->insert_single_comment_in_list, token_builder[flex_token->insert_single_comment_in_list], &(delimiter_builder[flex_token->insert_single_comment_in_list]), &(ar->delimiter_list[flex_token->insert_single_comment_in_list]), &(delim_stack[flex_token->insert_single_comment_in_list]), delimiter_realloc_size[flex_token->insert_single_comment_in_list]);
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter 0 for -- singleline comment\n", ar->id)
          } 
          
          if (flex_token->comment_type == -1) {
              //inserts RBRACK RBRACK in the token list only if error is 0
              if (flex_token->error[0] == 0) {
                //insert RBRACK RBRACK into the token list
                par_append_token_node(RBRACK, "]", &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
                par_append_token_node(RBRACK, "]", &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
                DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
                number_tokens_from_last_comment_string[0] += 2; 
                DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
              }
              else if (flex_token->error[1] == 0) {
                //insert RBRACK RBRACK into the token list
                par_append_token_node(RBRACK, "]", &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
                par_append_token_node(RBRACK, "]", &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
                DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
                number_tokens_from_last_comment_string[1] += 2; 
                DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[1] = %d\n", ar->id, number_tokens_from_last_comment_string[1])
              }
          }
          //insert multicomment at the end of the double list of delimiters and  
          //link the last delimiter at the end of each delimiter list to the delimiter multicomment
          delimiter_union.comment = flex_token->comment_type;
          par_append_delimiter(delimiter_union, 1, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          delimiter_builder[0]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d at the end of the double list.\n", ar->id, flex_token->comment_type)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0]) 
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[1] = %d\n", ar->id, number_tokens_from_last_comment_string[1]) 
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          number_tokens_from_last_comment_string[1] = 0;
          //Set both last_token[0] and last_token[1]
          delimiter_builder[0]->last_token[1] = token_builder[1];
          if (flex_token->comment_type == -1) {
            //set error field
            delimiter_builder[0]->error[0] = flex_token->error[0];
            delimiter_builder[0]->error[1] = flex_token->error[1];
          }
        }

        if (flex_token->insert_function == 1){
          //Insert delimiter FUNCTION at the saved position
          flex_token->insert_function = 0;
          delimiter_union.token = FUNCTION;
          par_insert_delimiter(delimiter_union, 0, function_token_list_number, function_token_pos, &(delimiter_builder[function_token_list_number]), function_current_delim_pos, &(ar->delimiter_list[function_token_list_number]), &(delim_stack[function_token_list_number]), delimiter_realloc_size[function_token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
        }
        break;
      case INSERT_DELIMITER_BRACKETED_STRING:
        switch(flex_token->bracket_delimiter){
          case OPEN_BRACKETS:
            /*Insert the token STRING in the token list and insert [[ in the delimiter list*/  
            //insert token STRING
            par_append_token_node(flex_token->token, flex_token->semantic_value[0], &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
            number_tokens_from_last_comment_string[0]++;
            DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[0])
            //insert delimiter OPEN_BRACKETS
            delimiter_union.bracket_delimiter = OPEN_BRACKETS;
            par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
            delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
            //reset counter of number tokens
            number_tokens_from_last_comment_string[0] = 0;
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, 0, number_tokens_from_last_comment_string[0])
            break;
          case CLOSED_BRACKETS:
            //insert RBRACK RBRACK into the token list
            par_append_token_node(RBRACK, "]", &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
            par_append_token_node(RBRACK, "]", &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
            DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
            number_tokens_from_last_comment_string[token_list_number] += 2; 
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
            //insert delimiter CLOSED_BRACKETS
            delimiter_union.bracket_delimiter = flex_token->bracket_delimiter;
            par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);    
            delimiter_builder[token_list_number]->number_tokens_from_last_comment_string[token_list_number] = number_tokens_from_last_comment_string[token_list_number];
            if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
            }
            //reset counter of number tokens
            number_tokens_from_last_comment_string[token_list_number] = 0;
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter ]] = %d\n", ar->id, flex_token->bracket_delimiter)     
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
            break;
          case CLOSED_BRACKETS_NOT_RBRACK_RBRACK:
            //insert delimiter CLOSED_BRACKETS_NOT_RBRACK_RBRACK
            delimiter_union.bracket_delimiter = flex_token->bracket_delimiter;
            par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
            delimiter_builder[token_list_number]->number_tokens_from_last_comment_string[token_list_number] = number_tokens_from_last_comment_string[token_list_number];
            if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
            }
            //reset counter of number tokens
            number_tokens_from_last_comment_string[token_list_number] = 0;
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter ]] = %d\n", ar->id, flex_token->bracket_delimiter)     
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])

            if (flex_token->insert_function == 1){
              //Insert delimiter FUNCTION at the saved position
              flex_token->insert_function = 0;
              delimiter_union.token = FUNCTION;
              par_insert_delimiter(delimiter_union, 0, function_token_list_number, function_token_pos, &(delimiter_builder[function_token_list_number]), function_current_delim_pos, &(ar->delimiter_list[function_token_list_number]), &(delim_stack[function_token_list_number]), delimiter_realloc_size[function_token_list_number]);
              DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
            }
            break; 
          case CLOSED_BRACKETS_IN_STRING: 
          case CLOSED_BRACKETS_IN_SINGLECOMMENT:
            //insert delimiter CLOSED_BRACKETS_IN_STRING|CLOSED_BRACKETS_IN_SINGLECOMMENT, and set both last_token[0] and last_token[1]
            delimiter_union.bracket_delimiter = flex_token->bracket_delimiter;
            par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
            delimiter_builder[0]->last_token[1] = token_builder[1];
            if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
            }
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter ]] = %d\n", ar->id, flex_token->bracket_delimiter)     

            //Set the builder of the second branch of the delimiter list to the delimiter CLOSED_BRACKETS_IN_STRING|CLOSED_BRACKETS_IN_SINGLECOMMENT
            delimiter_builder[1] = delimiter_builder[0];

            if (flex_token->insert_function == 1) {
              //Insert delimiter FUNCTION at the saved position
              flex_token->insert_function = 0;
              delimiter_union.token = FUNCTION;
              par_insert_delimiter(delimiter_union, 0, function_token_list_number, function_token_pos, &(delimiter_builder[function_token_list_number]), function_current_delim_pos, &(ar->delimiter_list[function_token_list_number]), &(delim_stack[function_token_list_number]), delimiter_realloc_size[function_token_list_number]);
              DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
            }
            break;
          case END_DOUBLE_LIST_NEWLINE:
          case END_DOUBLE_LIST:
            if (token_list_number == 0 || token_list_number == 1)
            { 
              if (flex_token->insert_function != 1){
              //insert token in the token list
              par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
              DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
              number_tokens_from_last_comment_string[token_list_number]++;
              DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
              } 
              else {
                //Insert delimiter FUNCTION at the saved position
                flex_token->insert_function = 0;
                delimiter_union.token = FUNCTION;
                par_insert_delimiter(delimiter_union, 0, function_token_list_number, function_token_pos, &(delimiter_builder[function_token_list_number]), function_current_delim_pos, &(ar->delimiter_list[function_token_list_number]), &(delim_stack[function_token_list_number]), delimiter_realloc_size[function_token_list_number]);
                DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
              }
            }
            else if (token_list_number == 3)
            {//insert STRING in both token lists (the state is bracketedString_bracketedString)
              par_append_token_node(flex_token->token, flex_token->semantic_value[0], &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
              DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[0])
              number_tokens_from_last_comment_string[0]++;
              par_append_token_node(flex_token->token, flex_token->semantic_value[1], &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
              DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[1])
              number_tokens_from_last_comment_string[1]++;
              DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
              DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[1] = %d\n", ar->id, number_tokens_from_last_comment_string[1])
            }

            //insert END_DOUBLE_LIST|END_DOUBLE_LIST_NEWLINE into the delimiter list. 
            delimiter_union.bracket_delimiter = flex_token->bracket_delimiter;
            par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
            delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
            delimiter_builder[0]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
            //reset counters of number tokens
            number_tokens_from_last_comment_string[0] = 0;
            number_tokens_from_last_comment_string[1] = 0;

            //Set both last_token[0] and last_token[1]
            delimiter_builder[0]->last_token[1] = token_builder[1];
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter for the end of the double list: %d\n", ar->id, flex_token->bracket_delimiter)     
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])

            //set error field
            delimiter_builder[0]->error[0] = flex_token->error[0];
            delimiter_builder[0]->error[1] = flex_token->error[1];

            break;
          case ERROR_STRING_CHAR_MAX:
            //insert delimiter ERROR_STRING_CHAR_MAX
            delimiter_union.bracket_delimiter = flex_token->bracket_delimiter;
            par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter for pending brackets: %d\n", ar->id, flex_token->bracket_delimiter) 
            if (flex_token->state != SINGLE_COMMENT)
              ar->error_comment_or_bracketed_string = 1;    
            break;
        }
        break;
      case INSERT_STRING_WITH_BRACKETS:
        //insert STRING with its semantic value into the token list and [[ and ]] into the delimiter list.
        //insert token STRING
        par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        number_tokens_from_last_comment_string[token_list_number]++;
        DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
        //insert delimiter OPEN_BRACKETS
        delimiter_union.bracket_delimiter = OPEN_BRACKETS;
        par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
        delimiter_builder[token_list_number]->number_tokens_from_last_comment_string[token_list_number] = number_tokens_from_last_comment_string[token_list_number];
        //reset counter of number tokens
        number_tokens_from_last_comment_string[token_list_number] = 0;
        DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        //insert delimiter CLOSED_BRACKETS
        delimiter_union.bracket_delimiter = CLOSED_BRACKETS;
        par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
        if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
        }
        DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
        break;
      case INSERT_STRING_MULTICOMMENT:
        if (flex_token->double_list_ended == 0) {
          //insert STRING with its semantic_value into the token list, [[ into the delimiter list and the comment of type comment_type < 0 into the delimiter list.
          //insert token STRING
          par_append_token_node(flex_token->token, flex_token->semantic_value[0], &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
          number_tokens_from_last_comment_string[0]++;
          DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[0])
          /*Append interrupted bracketed string to the list: it cannot know if there is a comment or the string goes on.*/
          if (flex_token->append_pending_bracketed_string) {
            flex_token->append_pending_bracketed_string = 0;          
            append_pending_bracketed_string(&(flex_token->pending_bracketed_string_list), &(flex_token->top_pending_bracketed_string_list), (char **) &(token_builder[0]->value), flex_token->current_buffer_length[0]);      
          }
          //insert delimiter OPEN_BRACKETS
          delimiter_union.bracket_delimiter = OPEN_BRACKETS;          
          par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          //reset counter of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
          //insert multiline comment
          delimiter_union.comment = flex_token->comment_type;
          par_append_delimiter(delimiter_union, 1, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->comment_type)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
          if (flex_token->comment_type == -1) {
            if (first_closing_bracket == 1 && flex_token->first_closing_bracket == 0) {
              first_closing_bracket = 0;
              ar->first_closing_bracket_delim = delimiter_builder[0];
            }
            //set error field
            delimiter_builder[0]->error[0] = flex_token->error[0];
          }
        } 
        else {//in double list
          if (token_list_number == 3) {
            //insert in both branches the token STRING with its semantic value and the delimiter [[
            //insert token STRING
            par_append_token_node(flex_token->token, flex_token->semantic_value[0], &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
            par_append_token_node(flex_token->token, flex_token->semantic_value[1], &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
            number_tokens_from_last_comment_string[0]++; 
            number_tokens_from_last_comment_string[1]++; 
            DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[0])
            DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[1])
            /*Append interrupted bracketed strings to the list: it cannot know if there is a comment or the strings go on.*/
            if (flex_token->append_pending_bracketed_string) {
              flex_token->append_pending_bracketed_string = 0;          
              append_pending_bracketed_string(&(flex_token->pending_bracketed_string_list), &(flex_token->top_pending_bracketed_string_list), (char **) &(token_builder[0]->value), flex_token->current_buffer_length[0]);      
              append_pending_bracketed_string(&(flex_token->pending_bracketed_string_list), &(flex_token->top_pending_bracketed_string_list), (char **) &(token_builder[1]->value), flex_token->current_buffer_length[1]);      
            }
            //insert delimiter OPEN_BRACKETS
            delimiter_union.bracket_delimiter = OPEN_BRACKETS;
            par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
            par_append_delimiter(delimiter_union, 2, 1, token_builder[1], &(delimiter_builder[1]), &(ar->delimiter_list[1]), &(delim_stack[1]), delimiter_realloc_size[1]);           
            delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
            delimiter_builder[1]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
            //reset counter of number tokens
            number_tokens_from_last_comment_string[0] = 0;
            number_tokens_from_last_comment_string[1] = 0;
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
          }
          else {
            //insert in one branch the token STRING with its semantic value and the delimiter [[ 
            //insert token STRING
            par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
            number_tokens_from_last_comment_string[token_list_number]++;
            DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
            /*Append interrupted bracketed string to the list: it cannot know if there is a comment or the string goes on.*/
            if (flex_token->append_pending_bracketed_string) {
              flex_token->append_pending_bracketed_string = 0;          
              append_pending_bracketed_string(&(flex_token->pending_bracketed_string_list), &(flex_token->top_pending_bracketed_string_list), (char **) &(token_builder[token_list_number]->value), flex_token->current_buffer_length[token_list_number]);      
            }
            //insert delimiter OPEN_BRACKETS
            delimiter_union.bracket_delimiter = OPEN_BRACKETS;
            par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
            delimiter_builder[token_list_number]->number_tokens_from_last_comment_string[token_list_number] = number_tokens_from_last_comment_string[token_list_number];
            //reset counter of number tokens
            number_tokens_from_last_comment_string[token_list_number] = 0;
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
            DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
            
            if (flex_token->insert_single_comment_in_list != 2) {
              //insert singleline comment symbol -- in the delimiter list denoted by insert_single_comment_in_list
              delimiter_union.comment = 0;
              par_append_delimiter(delimiter_union, 1, flex_token->insert_single_comment_in_list, token_builder[flex_token->insert_single_comment_in_list], &(delimiter_builder[flex_token->insert_single_comment_in_list]), &(ar->delimiter_list[flex_token->insert_single_comment_in_list]), &(delim_stack[flex_token->insert_single_comment_in_list]), delimiter_realloc_size[flex_token->insert_single_comment_in_list]);
              DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter 0 for -- singleline comment\n", ar->id) 
            }
            if (flex_token->double_list_ended && flex_token->comment_type == -1) {
              //inserts RBRACK RBRACK in the token list only if error is 0
              if (flex_token->error[0] == 0) {
                //insert RBRACK RBRACK into the token list
                par_append_token_node(RBRACK, "]", &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
                par_append_token_node(RBRACK, "]", &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
                DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
                number_tokens_from_last_comment_string[0] += 2; 
                DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])
              }
              else if (flex_token->error[1] == 0) {
                //insert RBRACK RBRACK into the token list
                par_append_token_node(RBRACK, "]", &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
                par_append_token_node(RBRACK, "]", &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
                DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
                number_tokens_from_last_comment_string[1] += 2; 
                DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[1] = %d\n", ar->id, number_tokens_from_last_comment_string[1])
              }
            }
          }

          //insert multiline comment symbol at the end of the double list of delimiters
          delimiter_union.comment = flex_token->comment_type;
          par_append_delimiter(delimiter_union, 1, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          delimiter_builder[0]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          number_tokens_from_last_comment_string[1] = 0;
          //Set both last_token[0] and last_token[1]
          delimiter_builder[0]->last_token[1] = token_builder[1];
          delimiter_builder[1]->next[1] = delimiter_builder[0];
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d at the end of the double list.\n", ar->id, flex_token->comment_type)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0]) 
          if (flex_token->comment_type == -1) {
            //set error field
            delimiter_builder[0]->error[0] = flex_token->error[0];
            delimiter_builder[0]->error[1] = flex_token->error[1];
          }
        }  
        break;  
      case END_CHUNK_INTERRUPTED_BRACKETED_STRING:
        /*Insert the token STRING in the tokenlist of the state insert_token_in_list, insert [[ in the delimiter list.
          If this is the end of a double list, then inserts END_DOUBLE_LIST_NEWLINE at the end of the double list in the delimiter list.*/        
        if (token_list_number == 3) {
          //insert in both branches the token STRING with its semantic value and the delimiter [[
          //insert token STRING
          par_append_token_node(flex_token->token, flex_token->semantic_value[0], &(token_builder[0]), &(ar->list_begin[0]), &(stack[0]), realloc_size[0]);
          par_append_token_node(flex_token->token, flex_token->semantic_value[1], &(token_builder[1]), &(ar->list_begin[1]), &(stack[1]), realloc_size[1]);
          number_tokens_from_last_comment_string[0]++; 
          number_tokens_from_last_comment_string[1]++; 
          DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[0])
          DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[1])
          //insert delimiter OPEN_BRACKETS
          delimiter_union.bracket_delimiter = OPEN_BRACKETS;
          par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          par_append_delimiter(delimiter_union, 2, 1, token_builder[1], &(delimiter_builder[1]), &(ar->delimiter_list[1]), &(delim_stack[1]), delimiter_realloc_size[1]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          delimiter_builder[1]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
          //reset counter of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          number_tokens_from_last_comment_string[1] = 0;
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])        
        }
        else {
          //insert token STRING
          par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
          number_tokens_from_last_comment_string[token_list_number]++;
          DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
          //insert delimiter OPEN_BRACKETS
          delimiter_union.bracket_delimiter = OPEN_BRACKETS;
          par_append_delimiter(delimiter_union, 2, token_list_number, token_builder[token_list_number], &(delimiter_builder[token_list_number]), &(ar->delimiter_list[token_list_number]), &(delim_stack[token_list_number]), delimiter_realloc_size[token_list_number]);
          delimiter_builder[token_list_number]->number_tokens_from_last_comment_string[token_list_number] = number_tokens_from_last_comment_string[token_list_number];
          //reset counter of number tokens
          number_tokens_from_last_comment_string[token_list_number] = 0;
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->bracket_delimiter)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        }
        if (flex_token->double_list_ended == 1){
          //insert END_DOUBLE_LIST_NEWLINE into the delimiter list. 
          delimiter_union.bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
          par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
          delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
          delimiter_builder[0]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
          //reset counters of number tokens
          number_tokens_from_last_comment_string[0] = 0;
          number_tokens_from_last_comment_string[1] = 0;
          //Set both last_token[0] and last_token[1]
          delimiter_builder[0]->last_token[1] = token_builder[1];
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter for the end of the double list: %d\n", ar->id, flex_token->bracket_delimiter)     
          DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])

          //set error field
          delimiter_builder[0]->error[0] = flex_token->error[0];
          delimiter_builder[0]->error[1] = flex_token->error[1];
        
          /*Check insert_function: if it is == 1, put delimiter FUNCTION in the delimiter list of the state different from insert_token_in_list 
          (since here it puts token STRING)*/
          if (flex_token->insert_function == 1) {
            //Insert delimiter FUNCTION at the saved position
            flex_token->insert_function = 0;
            delimiter_union.token = FUNCTION;
            par_insert_delimiter(delimiter_union, 0, function_token_list_number, function_token_pos, &(delimiter_builder[function_token_list_number]), function_current_delim_pos, &(ar->delimiter_list[function_token_list_number]), &(delim_stack[function_token_list_number]), delimiter_realloc_size[function_token_list_number]);
            DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
          }
        }
        break;
      case END_DOUBLE_LIST_STRING_RBRACK_RBRACK:
        //insert token STRING
        par_append_token_node(flex_token->token, flex_token->semantic_value[token_list_number], &(token_builder[token_list_number]), &(ar->list_begin[token_list_number]), &(stack[token_list_number]), realloc_size[token_list_number]);
        DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value[token_list_number])
        number_tokens_from_last_comment_string[token_list_number]++;
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        //insert RBRACK RBRACK in the other token list
        int8_t other_token_list_number = !token_list_number;
        par_append_token_node(RBRACK, "]", &(token_builder[other_token_list_number]), &(ar->list_begin[token_list_number]), &(stack[other_token_list_number]), realloc_size[other_token_list_number]);
        par_append_token_node(RBRACK, "]", &(token_builder[other_token_list_number]), &(ar->list_begin[token_list_number]), &(stack[other_token_list_number]), realloc_size[other_token_list_number]);
        DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list = %d.\n", ar->id, other_token_list_number)     
        number_tokens_from_last_comment_string[other_token_list_number] += 2; 
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[%d] = %d\n", ar->id, token_list_number, number_tokens_from_last_comment_string[token_list_number])
        //insert END_DOUBLE_LIST into the delimiter list. 
        delimiter_union.bracket_delimiter = END_DOUBLE_LIST;
        par_append_delimiter(delimiter_union, 2, 0, token_builder[0], &(delimiter_builder[0]), &(ar->delimiter_list[0]), &(delim_stack[0]), delimiter_realloc_size[0]);
        delimiter_builder[0]->number_tokens_from_last_comment_string[0] = number_tokens_from_last_comment_string[0];
        delimiter_builder[0]->number_tokens_from_last_comment_string[1] = number_tokens_from_last_comment_string[1];
        //reset counters of number tokens
        number_tokens_from_last_comment_string[0] = 0;
        number_tokens_from_last_comment_string[1] = 0;
        //Set both last_token[0] and last_token[1]
        delimiter_builder[0]->last_token[1] = token_builder[1];
        DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter for the end of the double list: %d\n", ar->id, flex_token->bracket_delimiter)     
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment_string[0] = %d\n", ar->id, number_tokens_from_last_comment_string[0])

        //set error field
        delimiter_builder[0]->error[0] = flex_token->error[0];
        delimiter_builder[0]->error[1] = flex_token->error[1];
        break;
      case END_CHUNK_ERROR:
        DEBUG_STDOUT_PRINT("DEBUG> received END_CHUNK_ERROR return code.\n")
        ar->error_comment_or_bracketed_string = 1;
        //check insert_function
      case END_CHUNK: 
        if (flex_token->insert_function == 1) {
          //Insert delimiter FUNCTION at the saved position
          flex_token->insert_function = 0;
          delimiter_union.token = FUNCTION;
          par_insert_delimiter(delimiter_union, 0, function_token_list_number, function_token_pos, &(delimiter_builder[function_token_list_number]), function_current_delim_pos, &(ar->delimiter_list[function_token_list_number]), &(delim_stack[function_token_list_number]), delimiter_realloc_size[function_token_list_number]);
          DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
        }
        break;
    }

    if (flex_token->double_list_ended) {
        flex_token->double_list_ended = 0;
        flex_token->state = 0;
        //Set the branch where the lexer inserts token from now on
        flex_token->insert_token_in_list = 0;
        //Link branch 1 of the double list with delimiter END_DOUBLE_LIST|END_DOUBLE_LIST_NEWLINE
        delimiter_builder[1]->next[1] = delimiter_builder[0];
      }

    if (flex_token->chunk_ended) {
      end_of_chunk = 1;
      if (flex_token->pending_bracketed_string_list != NULL) {
        terminate_all_pending_string(flex_token->pending_bracketed_string_list);
      }
    }
    else {
      //Continue to scan the chunk
      flex_return_code = yylex(scanner); 
    }

  }
  
  ar->list_end = token_builder[0];
  ar->number_tokens_from_last_comment_string = number_tokens_from_last_comment_string[0];
  if (flex_token->first_closing_bracket == 0) {
    //the chunk contains closed brackets ]]
    ar->first_closing_bracket = 1;
    ar->first_closing_bracket_pos = flex_token->first_closing_bracket_pos;
  }

  fclose(yyget_in(scanner));
  yylex_destroy(scanner);

  fclose(f);

  pthread_exit(NULL);

}

void initialize_flex_token(lex_token * flex_token)
{
  flex_token->num_chars = 0;
  flex_token->allocated_buffer_size[0] = MAX_BUFFER_SIZE;
  flex_token->allocated_buffer_size[1] = MAX_BUFFER_SIZE;
  flex_token->string_buffer[0] = (char*) malloc(sizeof(char)*MAX_BUFFER_SIZE); 
  if (flex_token->string_buffer[0] == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> In Flex: could not complete malloc string_buffer. Aborting.\n");
    exit(1);
  }  
  flex_token->string_buffer[1] = (char*) malloc(sizeof(char)*MAX_BUFFER_SIZE); 
  if (flex_token->string_buffer[1] == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> In Flex: could not complete malloc string_buffer. Aborting.\n");
    exit(1);
  }   
  flex_token->current_buffer_length[0] = 0;
  flex_token->current_buffer_length[1] = 0;
  flex_token->first_closing_bracket = 1;
  flex_token->lexing_phase = 0;
  flex_token->state = 0;
  flex_token->first_state = 0;
  flex_token->second_state = 1;
  flex_token->insert_function = 0;
  flex_token->insert_token_in_list = 0;
  flex_token->insert_single_comment_in_list = 2;
  flex_token->chunk_ended = 0;
  flex_token->double_list_ended = 0;
  flex_token->pending_bracketed_string_list = NULL;
  flex_token->top_pending_bracketed_string_list = NULL;
  flex_token->append_pending_bracketed_string = 0;
}

int8_t handle_empty_file(parsing_ctx *ctx)
{
  token_node * end_token = new_token_node(ENDFILE, "ENDFILE") ;
  ctx->token_list = end_token;
  return 1;
}

void lexing_interrupted_bracketed_string(lex_thread_arg *arg, string_thread_arg * string_arg, int32_t string_thread_num)
{
  interrupted_bracketed_string * current_string = interrupted_string_list;
  int32_t i, j = 0;
  pthread_t *string_threads;

  /* Allocate threads. */
  string_threads = (pthread_t *) malloc(sizeof(pthread_t)*string_thread_num);
  if (string_threads == NULL) {
  DEBUG_STDOUT_PRINT("ERROR> string_threads = NULL after malloc\n")
    exit(1);
  }
  
  /* Create and launch threads.*/
  while (current_string != NULL) {
    for (i = current_string->chunk_token_string + 1; i <= current_string->chunk_closed_brackets -1; i++) {
      string_arg[j].id = i;
      string_arg[j].cut_point_sx = arg[i].cut_point_sx;
      DEBUG_STDOUT_PRINT("SECOND LEXING> thread for chunk %d has cut_point_sx = %d\n",i, string_arg[j].cut_point_sx)  
      string_arg[j].cut_point_dx = arg[i].cut_point_dx;
      DEBUG_STDOUT_PRINT("SECOND LEXING> thread for chunk %d has cut_point_dx = %d\n",i, string_arg[j].cut_point_dx)                      
      string_arg[j].file_name = arg[i].file_name;
      pthread_create(&string_threads[j], NULL, string_thread_task, (void *)&string_arg[j]);
      j++;
    }
    //thread for the chunk with the closed brackets
    string_arg[j].id = i;
    string_arg[j].cut_point_sx = arg[i].cut_point_sx;
    DEBUG_STDOUT_PRINT("SECOND LEXING> thread for chunk %d has cut_point_sx = %d\n",i, string_arg[j].cut_point_sx)  
    string_arg[j].cut_point_dx = arg[i].cut_point_sx + arg[i].first_closing_bracket_pos;
    DEBUG_STDOUT_PRINT("SECOND LEXING> thread for chunk %d has cut_point_dx = %d\n",i, string_arg[j].cut_point_dx)
    string_arg[j].file_name = arg[i].file_name;
    pthread_create(&string_threads[j], NULL, string_thread_task, (void *)&string_arg[j]);
    j++;
    current_string = current_string->next;
  }

  /* Wait for all threads to finish. */
  for (j = 0; j<string_thread_num; j++){
    pthread_join(string_threads[j], NULL);
  }

  /* Free threads*/
  DEBUG_STDOUT_PRINT("SECOND LEXING> Freeing threads.\n")
  free(string_threads); 

}
