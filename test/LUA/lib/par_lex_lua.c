#include "par_lex_lua.h"

//very very simple hash table for the array hash_end_stat_f
int32_t hash_end_stat_f_size;
int32_t * hash_end_stat_f;

//very very simple hash table for the array hash_begin_stat
int32_t hash_begin_stat_size;
int32_t * hash_begin_stat;

//very very simple hash table for the array hash_prev_minus
int32_t hash_prev_minus_size;
int32_t * hash_prev_minus;

delimiter * handle_comment(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, delimiter *d, int32_t *current_thread, uint8_t * check_end_chunk);
delimiter * next_matching_comment(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_matching_comment_thread, delimiter *current_comment, int32_t current_comment_thread);
delimiter * next_delimiter(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_delimiter_thread, delimiter *current_delimiter, int32_t current_delimiter_thread);
int8_t check_tokens(token_node * t, token_node * t_next);


/*Find the bounds of the file chunks that will be scanned by the lexing threads.*/
int32_t find_cut_points(FILE* f, int32_t file_length, int32_t * cut_points, int32_t lex_thread_max_num)
{
  int32_t i = 1, lex_thread_num = 1;
  int32_t c, prev_c, prev_prev_c;
  int8_t next = 1, read_z = 0;

  while (i<lex_thread_max_num && next)
  {
    fseek(f, cut_points[i], SEEK_SET);
    c = fgetc(f);

    //Find cut points avoiding to choose a newline inside a string which is preceded by / or by the escape sequence \z
    if(c == 'z' && !feof(f)){
       read_z = 1;
       c = fgetc(f);
     }

    while ((c == '\n' || c == ' ' || c == '\t' || c == '\f' || c == '\r' || c == '\v') && !feof(f))
      c = fgetc(f);

    //If input file contains only spaces, it is still accepted since the empty string belongs to the grammar.
    if(feof(f) && !read_z)
      return 0;

    //Since c!=\n and c cannot be the character z inside a sequence \z, in the first while iteration the value of prev_c and prev_prev_c is not relevant. 
    //Thus, they may also assume a value different from the actual characters preceding c.
    prev_c = ' ';
    prev_prev_c = ' '; 

    while ((c != '\n' || prev_c == '\\' || (prev_prev_c == '\\' && prev_c == 'z')) && !feof(f)) 
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
        cut_points[lex_thread_num] = ftell(f);
        while (i<lex_thread_max_num && cut_points[i]<=cut_points[lex_thread_num])
          i++;
        lex_thread_num++;
      }
    else
      next = 0;
  }

  if (lex_thread_num < lex_thread_max_num)
   {//realloc cut_points
    if (realloc(cut_points, lex_thread_num) == NULL){
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
  arg[thread].number_tokens_from_last_comment = 0;
  arg[thread].alloc_size = 0;
  arg[thread].realloc_size = 0;
  arg[thread].need_end_comment = 0;
}


int8_t check_thread_mission(lex_thread_arg* arg, int32_t lex_thread_num)
{
  return 0;
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
  DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
  // for (i = 0; i < lex_thread_num; i++)
  //   check_end_chunk[i] = 1;

  i = 0;
  while (arg[i].list_begin == NULL && i < lex_thread_num)
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

  ctx->token_list =  arg[i].list_begin;
  t = arg[i].list_end;
  check_end_chunk[i] = 1;
  i++;

  while (i < lex_thread_num)
  {
      while (i < lex_thread_num && arg[i].list_begin == NULL)
      {
        check_end_chunk[i] = 0;
        i++;
      }
      if (i == lex_thread_num){
        t->next = NULL;
      }
      else{
        t->next = arg[i].list_begin;
        t = arg[i].list_end;
        check_end_chunk[i] = 1;
        i++;
      }
  }

  #if DEBUG
  int8_t k;
  for (k = 0; k< lex_thread_num; k++){
    if (arg[k].list_begin == NULL)
      DEBUG_STDOUT_PRINT("arg[%d].list_begin is NULL\n", k)
    else
      DEBUG_STDOUT_PRINT("arg[%d].list_begin is not NULL\n", k)
    DEBUG_STDOUT_PRINT("Check_end_chunk[%d] = %d\n", k, check_end_chunk[k])
    DEBUG_STDOUT_PRINT("need_end_comment[%d] = %d\n", k, arg[k].need_end_comment)
  }
  
  DEBUG_STDOUT_PRINT("delimiter lists:\n")
  delimiter * temp_delim;
  for(k = 0; k< lex_thread_num; k++)
  {
    temp_delim = arg[k].delimiter_list;
    DEBUG_STDOUT_PRINT("Chunk %d has delimiters:\n", k)
    while(temp_delim != NULL){
      if(temp_delim->type_class == 0)
        DEBUG_STDOUT_PRINT("token = %d = %s\n", temp_delim->type.token, gr_token_to_string(temp_delim->type.token))
      else
        DEBUG_STDOUT_PRINT("comment = %d with number_tokens_from_last_comment = %d\n", temp_delim->type.comment, temp_delim->number_tokens_from_last_comment) 
    temp_delim = temp_delim->next;
    }
  }
  #endif

  //Scan the delimiters' list, and update the token list accordingly.
  //Find the first delimiter.
  d = arg[current_thread].delimiter_list;

  while (d == NULL && current_thread < lex_thread_num) 
  {
    //We have to check whether or not this chunk ended with an unexpected lexeme and it needed to be inside a comment: if the chunk ended with
    //an unexpected lexeme, then yylex returned END_CHUNK_ERROR and arg[current_delimiter_thread]->need_end_comment was set to 1.
    if (arg[current_thread].need_end_comment == 1) {
      fprintf(stdout, "Unexpected character in the input file while reading chunk %d. Exit.\n", current_thread);
      exit(1);
    }
    current_thread++;
    d = arg[current_thread].delimiter_list;
  }

  while (d != NULL && current_thread < lex_thread_num) 
  {
    if (d->type_class == 0)
    {//the delimiter is a token
      switch (d->type.token)
      {
        case XEQ:
          if (braces_difference > 0)
            d->last_token->token = EQ;
          d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          break;
        case LBRACE:
          braces_difference++;
          d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          break;
        case RBRACE:
          if (braces_difference == 0) {
            fprintf(stdout, "Input file has non balanced braces. Exit.\n");
            exit(1);
          }
          braces_difference--;
          d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          break;  
        case SEMI:
          if (braces_difference > 0)
            d->last_token->token = SEMIFIELD;
          d = next_delimiter(arg, lex_thread_num, &current_thread, d, current_thread);
          break;  
        case FUNCTION:
          d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d, current_thread);
          //Handle all the possible comments which follow the delimiter FUNCTION.
          while (d1 != NULL && d1->type_class == 1 && d1->type.comment != -1){
            d1 = handle_comment(ctx, arg, lex_thread_num, d1, &next_delimiter_thread, check_end_chunk);
            // d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d1, next_delimiter_thread);
          }
          //Replace LPAREN and RPAREN with tokens LPARENFUNC and RPARENFUNC.
          t = d->last_token; //token FUNCTION
          t = t->next;
          while (t!= NULL && (t->token == NAME || t->token == DOT || t->token == COLON))
            t = t->next;
          if (t!= NULL && t->token == LPAREN)
            t->token = LPARENFUNC;
          else{
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
            if(!(d1 != NULL && d1->type_class == 0 && d1->type.token == SEMI))
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
    else { //the delimiter is a comment symbol
      d = handle_comment(ctx, arg, lex_thread_num, d, &current_thread, check_end_chunk);
    }

  }

  //Check whether a SEMI must be inserted between the end of the token list of a chunk and the beginning of the following one, and check the presence of token MINUS/UMINUS.
  for (i = first_nonempty_chunk; i < lex_thread_num -1; i++){
    if (check_end_chunk[i] == 1){
      t = arg[i].list_end;
      added_tokens = check_tokens(t, t->next);
      ctx->token_list_length += added_tokens;
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    }
  }

  //Update the length of the whole token list
  for (i = first_nonempty_chunk; i < lex_thread_num; i++){
    if (check_end_chunk[i] == 1){
      ctx->token_list_length += arg[i].number_tokens_from_last_comment;
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    }
  }

}

//Precondition of function handle_comment: d != NULL && current_thread < lex_thread_num && d->type_class == 1
delimiter * handle_comment(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num, delimiter *d, int32_t *current_thread, uint8_t * check_end_chunk)
{ //the delimiter is a comment symbol
  delimiter * d1;
  delimiter * closing_comment;
  token_node * before_comment, * after_comment;
  int32_t closing_comment_thread = 0, next_delimiter_thread = 0;
  int32_t i, added_tokens = 0;
  uint8_t next;
  if (d->type.comment > 0)
  {//the delimiter is a starting symbol [=*[
    ctx->token_list_length += d->number_tokens_from_last_comment;
    DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    closing_comment = next_matching_comment(arg, lex_thread_num, &closing_comment_thread, d, *current_thread);
    //Check whether the comment is followed by other comments without valid tokens in between
    d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, closing_comment, closing_comment_thread);
    next = 1;
    while (next && d1 != NULL && d1->type_class == 1 && d1->type.comment >= 0)
    {
      next = 0;
      if(d1->type.comment == 0 && d1->next->number_tokens_from_last_comment == 0){
        next = 1;
        closing_comment = d1->next; //singleline comment symbol -- is followed by ]=*]
        closing_comment_thread = next_delimiter_thread;
        d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, closing_comment, next_delimiter_thread);
      }
      else if (d1->type.comment > 0 && d1->number_tokens_from_last_comment == 0){
        next = 1;
        closing_comment = next_matching_comment(arg, lex_thread_num, &closing_comment_thread, d1, next_delimiter_thread);
        d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d1, next_delimiter_thread);
      }
    }
    //At this point, delimiter d1 is NULL or is not a starting comment symbol.
    //Link the tokens in the token list pointed to by d and closing_comment, bypassing the whole comment.
    before_comment = d->last_token;
    after_comment = closing_comment->last_token;
    int32_t after_comment_thread = closing_comment_thread;
    int32_t before_comment_thread = *current_thread;

    if (after_comment != NULL)
      after_comment = after_comment->next;
    else{
      while (after_comment_thread < lex_thread_num && after_comment == NULL){
        after_comment = arg[after_comment_thread].list_begin;
        after_comment_thread++;
      }
    }

    if(before_comment != NULL){
      before_comment->next = after_comment;
      added_tokens = check_tokens(before_comment, after_comment);
      ctx->token_list_length += added_tokens;
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    }
    else
    {//the comment is at the beginning of a chunk
      if (arg[*current_thread].list_begin == ctx->token_list)
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
        //Thus, increment before_comment_thread so that the corresponding value of check_end_chunk is not reset. 
        // added_tokens = check_tokens(before_comment, after_comment);
        // ctx->token_list_length += added_tokens;
        // DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
        before_comment_thread++;
      }
    }

    for (i = before_comment_thread; i < after_comment_thread; i++)
    {
      check_end_chunk[i] = 0;
    }

    //Update delimiter position
    *current_thread = next_delimiter_thread;
   // d = d1;
    return d1;
  }
  else if (d->type.comment < 0)
  {//the delimiter is an ending symbol ]=*]
    if(d->type.comment == -1)
    {//symbol ]] is not interpreted as a comment, but as the sequence of tokens RBRACK RBRACK
      ctx->token_list_length += d->number_tokens_from_last_comment;
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
      d1 = next_delimiter(arg, lex_thread_num, current_thread, d, *current_thread);
      //If it is followed by a comment, then postpone the check of the tokens
      if (!(d1 != NULL && d1->type_class == 1 && d1->type.comment >= 0 && d1->number_tokens_from_last_comment == 0))
      {
        //Do not postpone the check
        before_comment = d->last_token;
        after_comment = d->last_token->next;
        if (after_comment != NULL){
          added_tokens = check_tokens(before_comment, after_comment);
          ctx->token_list_length += added_tokens;
          DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
        }
      }
     // d = d1;
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
    d = d->next;
    ctx->token_list_length += d->number_tokens_from_last_comment;
    DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
    //Check constraints on the tokens before and after the comment
    d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d, *current_thread);
    //If it is followed by a multiline comment, then postpone the check of the tokens; otherwise do it now.
    //Skip possible following singleline comments.
    while (d1 != NULL && d1->type_class == 1 && d1->type.comment == 0 && d1->number_tokens_from_last_comment == 0)
    {
      d1 = d1->next; //skip ]=*] after singleline comment symbol --
      ctx->token_list_length += d1->number_tokens_from_last_comment;
      DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
      d1 = next_delimiter(arg, lex_thread_num, &next_delimiter_thread, d1, next_delimiter_thread);
    }
    if (!(d1 != NULL && d1->type_class == 1 && d1->type.comment > 0 && d1->number_tokens_from_last_comment == 0))
    {//Do not postpone the check
      before_comment = d->last_token;
      if (before_comment == NULL)
      {
        (*current_thread)--;
        while(*current_thread >= 0 && arg[*current_thread].list_end == NULL)
          (*current_thread)--;
        if (*current_thread >= 0)
          before_comment = arg[*current_thread].list_end;
      }
      if (before_comment != NULL){
        after_comment = before_comment->next;
        if (after_comment != NULL){
          added_tokens = check_tokens(before_comment, after_comment);
          ctx->token_list_length += added_tokens;
          DEBUG_STDOUT_PRINT("ctx->token_list_length = %d\n", ctx->token_list_length)
        }
      }
    }
    
    *current_thread = next_delimiter_thread;
    //d = d1; 
    return d1;
  }  

}

delimiter * next_matching_comment(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_matching_comment_thread, delimiter *current_comment, int32_t current_comment_thread)
{
  delimiter * matching_comment = current_comment->next;
  uint8_t not_matching_comment = 1;
  while (not_matching_comment)
  {
    if (matching_comment == NULL)
    {//reached the end of the delimiter list of the chunk
      current_comment_thread++;
      if (current_comment_thread < lex_thread_num){
        matching_comment = arg[current_comment_thread].delimiter_list;
        // check_end_chunk[current_comment_thread-1] = 0;
        //need_end_comment of current_comment_thread -1 can be put to 0
      }
      else{
        DEBUG_STDOUT_PRINT("ERROR> Found open comment without matching closing symbol. Aborting.\n");
        exit(1);
      }
    }
    else if (matching_comment->type_class == 0 || matching_comment->type.comment + current_comment->type.comment != 0)
      matching_comment = matching_comment->next;
    else
      not_matching_comment = 0;
  }
  *next_matching_comment_thread = current_comment_thread;
  return matching_comment;
}

delimiter * next_delimiter(lex_thread_arg *arg, int32_t lex_thread_num, int32_t *next_delimiter_thread, delimiter *current_delimiter, int32_t current_delimiter_thread)
{
  if (current_delimiter->next != NULL){
    *next_delimiter_thread = current_delimiter_thread;
    return current_delimiter->next;
  }
  //else the end of the delimiter list of the chunk has been reached.
  //This ending part of the chunk is not inside a comment; otherwise function next_matching_comment would have been called while processing it.
  //Thus, we have to check whether or not this chunk ended with an unexpected lexeme and it needed instead to be inside a comment.
  //If the chunk ended with an unexpected lexeme, then yylex returned END_CHUNK_ERROR and arg[current_delimiter_thread]->need_end_comment was set to 1.
  if (arg[current_delimiter_thread].need_end_comment == 1) {
    DEBUG_STDOUT_PRINT("next_delimiter> Current delimiter has type class = %d\n", current_delimiter->type_class)
    fprintf(stdout, "Unexpected character in the input file while reading the end of chunk %d. Exit.\n", current_delimiter_thread);
    exit(1);
  }
  //Finds the next delimiter
  current_delimiter_thread++;
  while (current_delimiter_thread < lex_thread_num && arg[current_delimiter_thread].delimiter_list == NULL){
    if (arg[current_delimiter_thread].need_end_comment == 1) {
      DEBUG_STDOUT_PRINT("next_delimiter> ")
      fprintf(stdout, "Unexpected character in the input file while reading the end of chunk %d. Exit.\n", current_delimiter_thread);
      exit(1);
    }
    
    current_delimiter_thread++;
  }
  if (current_delimiter_thread == lex_thread_num)
    return NULL;
  else {
    *next_delimiter_thread = current_delimiter_thread;
    return arg[current_delimiter_thread].delimiter_list;
  }

}

/*Given two tokens separated by newline, checks the constraints needed to put the grammar in operator precedence form.*/
int8_t check_tokens(token_node * t, token_node * t_next)
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
  if(lookup(token_next, hash_begin_stat, hash_begin_stat_size) && (lookup(token, hash_end_stat_f, hash_end_stat_f_size) || ((token == NAME || token == RPAREN || token == RBRACK) && token_next != LPAREN)))
  {
    //add token SEMI to the token list
    token_node * new_node = new_token_node(SEMI, ";");
    t->next = new_node;
    new_node->next = t_next;
    added_tokens = 1;
    DEBUG_STDOUT_PRINT("Added SEMI while checking adjacent tokens: %d and %d\n", token, token_next)
  }
  //2)When '-' is preceded by tokens in hash_prev_minus, rename token as MINUS
  else if (token_next == UMINUS && lookup(token, hash_prev_minus, hash_prev_minus_size))
    t_next->token = MINUS;

  return added_tokens;
}


/*Thread task function for reentrant scanner.*/
void *lex_thread_task(void *arg)
{  
  /*lex_thread_task:
  -Inizializza lex_token
  -Gestisce valori di ritorno (lexing corretto, aggiunta punto e virgola alla lista token, inserimento delimitatori e commenti nella lista delimitatori, errori, fine chunk, eccetera) di par_in_lua.l
  -Inserisce token con il loro valore semantico nella lista token
  -Inserisce i delimitatori e i commenti nella lista delimitatori, facendoli puntare alla posizione corretta nella lista token
  */

lex_thread_arg *ar = (lex_thread_arg*) arg;
  
  FILE * f = fopen(ar->file_name, "r");
  if (f == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> Lexing thread %d could not open input file. Aborting.\n", ar->id);
    exit(1);
  }

  lex_token *flex_token;
  yyscan_t scanner;   //reentrant flex instance data
  int32_t flex_return_code;
  token_node *token_builder;
  delimiter *delimiter_builder = NULL;
  token_node_stack stack;
  delimiter_stack delim_stack;
  delimiter_type delimiter_union;
  
  //If yylex returns token FUNCTION, the lexer thread assigns to function_token_pos the position of FUNCTION in the token list 
  //and it assigns to function_current_delim_pos the current position in the delimiters' list (which is NULL if this list is empty).
  token_node *function_token_pos = NULL;
  delimiter *function_current_delim_pos = NULL;

  uint32_t alloc_size = 0, realloc_size = 0;
  uint32_t delimiter_alloc_size = 0, delimiter_realloc_size = 0;

  /*Associate to each comment symbol in the delimiter list the number of tokens read since the previous comment symbol of the delimiter list. 
  These numbers are needed to compute subsequently the length of the final token list, which is used by the parser.*/
  uint32_t number_tokens_from_last_comment = 0;    

  int8_t end_of_chunk = 0;
  uint32_t chunk_length = ar->cut_point_dx - ar->cut_point_sx;

  par_compute_alloc_realloc_size(chunk_length, &alloc_size, &realloc_size);
  par_delimiter_compute_alloc_realloc_size(chunk_length, &delimiter_alloc_size, &delimiter_realloc_size);  
  DEBUG_STDOUT_PRINT("LEXER %d > alloc_size %d, realloc_size %d\n", ar->id, alloc_size, realloc_size)
  DEBUG_STDOUT_PRINT("LEXER %d > delimiter_alloc_size %d, delimiter_realloc_size %d\n", ar->id, delimiter_alloc_size, delimiter_realloc_size)

  flex_token = (lex_token*) malloc(sizeof(lex_token));
  if (flex_token == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc flex_token. Aborting.\n");
    exit(1);
  }

  flex_token->chunk_length = chunk_length;
  flex_token->num_chars = 0;
  flex_token->read_new_line = 0;
  flex_token->allocated_buffer_size = MAX_BUFFER_SIZE;
  flex_token->string_buffer = (char*) malloc(sizeof(char)*MAX_BUFFER_SIZE); 
  if (flex_token->string_buffer == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> In Flex: could not complete malloc string_buffer. Aborting.\n");
    exit(1);
  }   
  flex_token->current_buffer_length = 0;

  fseek(f, ar->cut_point_sx, SEEK_SET);

  if (yylex_init_extra(flex_token, &scanner))
  {
    DEBUG_STDOUT_PRINT("ERROR> yylex_init_extra failed.\n")
    exit(1);
  }

  yyset_in(f, scanner);
  
  ar->list_begin = NULL;
  init_token_node_stack(&stack, alloc_size);
  init_delimiter_stack(&delim_stack, delimiter_alloc_size);

  flex_return_code = yylex(scanner);

  /*Return codes of yylex are: 
        END_CHUNK_ERROR = -1 : the end of the chunk has been reached. If the chunk is not followed by the proper end of comment symbol, then it has an error
        END_OF_FILE = 0 : EOF
        LEX_CORRECT = 1 : correct lexing
        INSERT_DELIMITER = 2 : insert delimiter in both the token list and the delimiter list
        ADD_SEMI = 3 : insert into the token list both SEMI and the returned token
        INSERT_COMMENT = 4 : insert a comment symbol in the list of delimiters. The type of comment is denoted by the value of comment_type:
                   Singleline comment -- has value 0;
                   Starting multiline comment with n symbols '=' has value n+1
                   Ending multiline comment with n symbols '=' has value -n-1
        INSERT_SINGLEMULTICOMMENT = 5 : insert both a singleline and a multiline comment (with number of '=' symbols denoted by the value of comment_type as stated above)
        END_CHUNK = 6 : the end of the chunk has been reached
        END_CHUNK_INSERT_COMMENT = 7 : the end of the chunk has been reached. Insert a comment symbol in the list of delimiters
        END_CHUNK_INSERT_SINGLEMULTICOMMENT = 8 : the end of the chunk has been reached. Insert both a singleline and a multiline comment in the list of delimiters
  */

  while (flex_return_code != END_OF_FILE && !end_of_chunk)
  {
    //1)Handle errors.

    // if(flex_return_code == ERROR)
    // {
    //   DEBUG_STDOUT_PRINT("Lexing thread %d scanned erroneous input. Abort.\n", ar->id)
    //   ar->result = 1; /*Signal error by returning result!=0.*/
    //   fclose(yyget_in(scanner));
    //   yylex_destroy(scanner);
    //   pthread_exit(NULL);
    // }
    if (flex_return_code == END_CHUNK_ERROR || flex_return_code == END_CHUNK || flex_return_code == END_CHUNK_INSERT_COMMENT || flex_return_code == END_CHUNK_INSERT_SINGLEMULTICOMMENT)
    {
      end_of_chunk = 1;
      if (flex_return_code == END_CHUNK_ERROR)
        ar->need_end_comment = 1;
    }

    //2)Insert the token returned by flex into the token list.
    
    //Insert token received with return codes LEX_CORRECT, INSERT_DELIMITER, ADD_SEMI.
    //If the token returned by yylex is FUNCTION, then it saves both the position of the token in the token list and the current position in the delimiter list.
    //In particular, token FUNCTION is received with LEX_CORRECT or ADD_SEMI.
    //If the delimiters' list is empty when yylex returns a token FUNCTION, then the current position which is saved is NULL: if afterwards FUNCTION should be
    //inserted into the delimiters' list, then it would be put at the head of the list.
  
    if (flex_return_code == LEX_CORRECT) 
    {
      par_append_token_node(flex_token->token, flex_token->semantic_value, &token_builder, &(ar->list_begin), &stack, realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value)
      number_tokens_from_last_comment++;
      DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment = %d\n", ar->id, number_tokens_from_last_comment)
      if (flex_token->token == FUNCTION)
      {
        function_token_pos = token_builder;
        function_current_delim_pos = delimiter_builder;
      }
    }
    else if (flex_return_code == INSERT_DELIMITER)
      {
        par_append_token_node(flex_token->token, flex_token->semantic_value, &token_builder, &(ar->list_begin), &stack, realloc_size); 
        DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value)     
        number_tokens_from_last_comment++;
        DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment = %d\n", ar->id, number_tokens_from_last_comment)
        //Insert delimiter into the delimiter list.
        delimiter_union.token = flex_token->token;
        par_append_delimiter(delimiter_union, 0, 0, token_builder, &delimiter_builder, &(ar->delimiter_list), &delim_stack, delimiter_realloc_size);
        DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value)     
      }
    else if (flex_return_code == ADD_SEMI)
    {//append both SEMI and token to the token list
      par_append_token_node((gr_token) SEMI, ";", &token_builder, &(ar->list_begin), &stack, realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d added token SEMI\n", ar->id)           
      par_append_token_node(flex_token->token, flex_token->semantic_value, &token_builder, &(ar->list_begin), &stack, realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d read token : %x = %s\n", ar->id, flex_token->token, (char *)flex_token->semantic_value)     
      number_tokens_from_last_comment += 2;
      DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment = %d\n", ar->id, number_tokens_from_last_comment)
      if (flex_token->token == FUNCTION)
      {
        function_token_pos = token_builder;
        function_current_delim_pos = delimiter_builder;
      }
    }


    //3)Insert comment symbol into the delimiter list.
    //Handle return codes INSERT_COMMENT, INSERT_SINGLEMULTICOMMENT, END_CHUNK_INSERT_COMMENT, END_CHUNK_INSERT_SINGLEMULTICOMMENT.
    if (flex_return_code == INSERT_COMMENT || flex_return_code == END_CHUNK_INSERT_COMMENT)
    {
      //If the return code is INSERT_COMMENT, INSERT_SINGLEMULTICOMMENT, END_CHUNK_INSERT_COMMENT or END_CHUNK_INSERT_SINGLEMULTICOMMENT,
      //and the number of equal signs in the comment symbol is 0, the symbol of comment could be also RBRACK RBRACK and the two parentheses should
      //be put into the token list (the pointer of the delimiter of the comment symbol will keep the position of the second RBRACK in the token listen).
      //However, if the semantic value is "function", the symbol must be a comment (otherwise it would be an error).
      //Furthermore, if the return code is INSERT_SINGLEMULTICOMMENT or END_CHUNK_INSERT_SINGLEMULTICOMMENT, the two parentheses belong to the singleline comment
      //since they are immediately followed by a newline; thus it is not necessary to insert them into the token list.
      //Thus, only INSERT_COMMENT and END_CHUNK_INSERT_COMMENT should be considered.
      if (flex_token->comment_type == -1 && (flex_token->semantic_value == NULL || strcmp(flex_token->semantic_value,"function") != 0)) {
         par_append_token_node((gr_token) RBRACK, "]", &token_builder, &(ar->list_begin), &stack, realloc_size);      
         par_append_token_node((gr_token) RBRACK, "]", &token_builder, &(ar->list_begin), &stack, realloc_size);
         DEBUG_STDOUT_PRINT("Lexing thread %d added tokens RBRACK RBRACK to the token list.\n", ar->id)     
         number_tokens_from_last_comment += 2;
         DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment = %d\n", ar->id, number_tokens_from_last_comment)
      }
      delimiter_union.comment = flex_token->comment_type;
      par_append_delimiter(delimiter_union, 1, number_tokens_from_last_comment, token_builder, &delimiter_builder, &(ar->delimiter_list), &delim_stack, delimiter_realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->comment_type)     
      number_tokens_from_last_comment = 0;
      DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment = %d\n", ar->id, number_tokens_from_last_comment)
    }
    else if (flex_return_code == INSERT_SINGLEMULTICOMMENT || flex_return_code == END_CHUNK_INSERT_SINGLEMULTICOMMENT)
    {
      delimiter_union.comment = 0;
      par_append_delimiter(delimiter_union, 1, 0, token_builder, &delimiter_builder, &(ar->delimiter_list), &delim_stack, delimiter_realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter 0 for -- singleline comment\n", ar->id)     
      delimiter_union.comment = flex_token->comment_type;
      par_append_delimiter(delimiter_union, 1, number_tokens_from_last_comment, token_builder, &delimiter_builder, &(ar->delimiter_list), &delim_stack, delimiter_realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter %d\n", ar->id, flex_token->comment_type)     
      number_tokens_from_last_comment = 0;
      DEBUG_STDOUT_PRINT("Lexing thread %d:number_tokens_from_last_comment = %d\n", ar->id, number_tokens_from_last_comment)
    }


    //4)If the end of the chunk or a comment occurred while reading a function declaration, then insert token FUNCTION into the delimiter list at the position saved beforehand while
    //reading the token. The delimiter has a pointer to the position of FUNCTION in the token list.
    if (flex_token->semantic_value != NULL && strcmp(flex_token->semantic_value, "function") == 0)
    {
      delimiter_union.token = FUNCTION;
      par_insert_delimiter(delimiter_union, 0, 0, function_token_pos, &delimiter_builder, function_current_delim_pos, &(ar->delimiter_list), &delim_stack, delimiter_realloc_size);
      DEBUG_STDOUT_PRINT("Lexing thread %d inserted delimiter FUNCTION\n", ar->id)     
    }
    //5)Continue to scan the chunk
    if (!end_of_chunk)
      flex_return_code = yylex(scanner);  

  }
  
  ar->list_end = token_builder;
  ar->number_tokens_from_last_comment = number_tokens_from_last_comment;

  fclose(yyget_in(scanner));
  yylex_destroy(scanner);

  pthread_exit(NULL);

}

int8_t handle_empty_file(parsing_ctx *ctx)
{
  token_node * end_token = new_token_node(ENDFILE, "ENDFILE") ;
  ctx->token_list = end_token;
  return 1;
}
