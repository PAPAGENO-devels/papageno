#include "par_lex_json.h"

#define __CHAR_TOKENS_LENGTH 21
#define __FIRST_CONTROL 0
#define __LAST_CONTROL 31
#define __FIRST_DIGIT 48
#define __LAST_DIGIT  57


//very very simple hash table for the array char_tokens
int32_t hash_char_tokens_size;
int32_t * hash_char_tokens;

//very very simple hash table for the array bools
int32_t hash_bools_size;
int32_t * hash_bools;

//very very simple hash table for the array char_tokens
int32_t hash_char_number_size;
int32_t * hash_char_number;

int8_t * thread_begin_with_string;

int8_t control_char(int32_t c);
int8_t heuristic_in_string(int32_t c);
int8_t is_inside_tokens(int32_t c, FILE* f, int32_t file_length, regex_t regex);


int32_t find_cut_points(FILE* f, int32_t file_length, int32_t **cut_points, int32_t lex_thread_max_num)
{
  int32_t i = 1, lex_thread_num = 1;
  int32_t max_scanned_chunk;
  int32_t c, prev_c;
  int8_t begin_with_string;
  int8_t next = 1;
  regex_t regex;  //POSIX Regular expression
  int reti;
  int32_t * cut_points_ptr = *cut_points;

  thread_begin_with_string = (int8_t *) malloc(sizeof(int8_t)*lex_thread_max_num); 
  if (thread_begin_with_string == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc thread_begin_with_string. Aborting.\n");
    exit(1);
  }

  /*Characters in char_tokens are not necessarily inside a string.*/
  int32_t* char_tokens = (int[]) {'{', '}', '[', ']', ',', ':', ' ', '+', '-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'E', '.'};  
  int32_t char_tokens_length = __CHAR_TOKENS_LENGTH;

  hash_char_tokens_size = char_tokens_length*char_tokens_length;  //large size
  hash_char_tokens = (int32_t *) malloc(sizeof(int32_t)*hash_char_tokens_size);
  if (hash_char_tokens == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc hash_char_tokens. Aborting.\n");
    exit(1);
  }

  init_table(hash_char_tokens, hash_char_tokens_size, char_tokens, char_tokens_length);

  /*Characters inside a token BOOL: true, false, null.*/
  int32_t* bools = (int[]) {'t', 'r', 'u', 'e', 'f', 'a', 'l', 's', 'n'};  
  int32_t bools_length = 9;

  hash_bools_size = bools_length*bools_length;
  hash_bools = (int32_t *) malloc(sizeof(int32_t)*hash_bools_size);
  if (hash_bools == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc hash_bools. Aborting.\n");
    exit(1);
  }
  init_table(hash_bools, hash_bools_size, bools, bools_length);

  /*Characters inside a token NUMBER: + - .'E' apart from digits.*/
  int32_t* char_number = (int[]) {'+', '-', '.', 'E'};  
  int32_t char_number_length = 4;

  hash_char_number_size = char_number_length*char_number_length;
  hash_char_number = (int32_t *) malloc(sizeof(int32_t)*hash_char_number_size);
  if (hash_char_number == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc hash_char_number. Aborting.\n");
    exit(1);
  }

  init_table(hash_char_number, hash_char_number_size, char_number, char_number_length);

  /*Compiling regular expression for pattern \uXXXX with X in [0-9A-Fa-f]*/
  reti = regcomp(&regex, "\\u[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]", 0);
  if(reti)
  { 
    DEBUG_STDOUT_PRINT("LEXER: Could not compile regex\n"); 
    exit(1); 
  }

  /* We can also set the maximum length of the part of the chunk, which is analyzed while looking for quotes ",
   to the minimum value between the following max_scanned_chunk and a predefined value as, for instance, 1000 chars.
   Note that the analysis can continue also beyond max_scanned_chunk if it should be blocked inside a token.*/
  max_scanned_chunk = (cut_points_ptr[lex_thread_max_num-1]-cut_points_ptr[lex_thread_max_num-2])/3;
  
  while (i<lex_thread_max_num && next)
  {
    begin_with_string = 2;
    fseek(f, cut_points_ptr[i], SEEK_SET);
    c = fgetc(f);

    while(c == '"')   //If it cuts exactly before a ", then it goes on until the next ", in order to get more information from the heuristics
      c = fgetc(f);

    prev_c = c; /*In the first while iteration c != " and prev_c value is not relevant. So it may also assume a value different from the actual character preceding c*/
    int8_t is_control_char = control_char(c);
    int32_t cur_offset = ftell(f)-cut_points_ptr[i];

    /*  If character " is preceded by '\\', then it is escaped.*/
    while(!(c == '"' && prev_c != '\\') && !is_control_char && (!(cur_offset >= max_scanned_chunk) || is_inside_tokens(c, f, file_length, regex)) && !feof(f)) 
    {
      if(begin_with_string != 1 && heuristic_in_string(c))
        begin_with_string = 1;

      prev_c = c;
      c = fgetc(f);
      is_control_char = control_char(c);
      cur_offset = ftell(f)-cut_points_ptr[i];
    }

    //Either the next character to be read is right after " and it is outside a string, or is after a control character and it is outside a string too.
    //In all other cases begin_with_string keeps value 2, which means that it is not known whether the current position is inside a string or not.
    if( (begin_with_string == 1 && c == '"') || is_control_char)
      begin_with_string = 0;

    /*Cannot cut a token in two distinct parts. If character \ is preceded by '\\', then it is escaped, and the token is composed by both symbols.*/
    if (cur_offset>=max_scanned_chunk && c == '\\' && prev_c != '\\')
      fseek(f, -1, SEEK_CUR);

   
    thread_begin_with_string[lex_thread_num] = begin_with_string;
    
    if(!feof(f))
    {
      cut_points_ptr[lex_thread_num] = ftell(f);
      while(i<lex_thread_max_num && cut_points_ptr[i]<=cut_points_ptr[lex_thread_num])
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

 /*Free compiled regular expression.*/
 regfree(&regex);

 //The first chunk cannot begin with a string, unless there are lexical errors in the file
 thread_begin_with_string[0] = 0;

 //lex_thread_num does not necessarily equals lex_thread_max_num
 return lex_thread_num;

}

/*Returns 1 if c is a control character (i.e., its code is between U+0000 and U+001F), 0 otherwise.*/
int8_t control_char(int32_t c)
{
  return !(c > __LAST_CONTROL);

}

/*Returns 1 if c is surely inside a string, 0 otherwise.*/
int8_t heuristic_in_string(int32_t c)
{
  if(!lookup(c, hash_bools, hash_bools_size) && !lookup(c, hash_char_tokens, hash_char_tokens_size))
    return 1;

   if(c == '\\')
  //   Note: if character \\ occurs outside a string, this is an error according to JSON grammar.
  //   So, it does not matter to check whether it is followed by escape characters or not.
  //   Lexical errors will be possibly signaled by the scanner flex.
        return 1;
   
  return 0;
}


/*Returns 0 if character c is not inside a token (bool or number or character \uXXXX); returns 1 it it can be inside a token (bool or number or character \uXXXX).
The tokens the function refers to are not JSON strings.*/
int8_t is_inside_tokens(int32_t c, FILE* f, int32_t file_length, regex_t regex)
{
  int32_t unicode_begin, unicode_end;
  int8_t char_u_length = 6;
  int8_t max_unicode_begin = char_u_length, max_unicode_end = 3;
  int32_t cur_pos = ftell(f);
  char * buf;  //buffer to contain a possible match of \uXXXX in file including character c

  //Data for regex
  regmatch_t match_info;
  int32_t unmatched;
  int32_t end_offset_match;

  if (('a'<= c && c <= 'f') || ('A'<= c && c <= 'F') || (__FIRST_DIGIT <= c && c <= __LAST_DIGIT))
  {
    /*unicode_begin is the lower bound for a string containing \uXXXX and including character c.
    It cannot be set before the beginning of the file.*/
    if(cur_pos/sizeof(char) < max_unicode_begin)
      unicode_begin = cur_pos/sizeof(char);
    else 
      unicode_begin = max_unicode_begin;

    /*unicode_end is the higher bound for a string containing \uXXXX and including character c.
    It cannot be set after the end of the file.*/
    if ((file_length - cur_pos)/sizeof(char) < max_unicode_end)
      unicode_end = (file_length - cur_pos)/sizeof(char);
    else
      unicode_end = max_unicode_end;

    if(unicode_begin+unicode_end >= char_u_length)
    {//There is enough space for a matching.
      fseek(f, -unicode_begin, SEEK_CUR);
      buf = (char *) malloc((unicode_begin+unicode_end+1)*sizeof(char));
      if (buf == NULL) {
       DEBUG_STDOUT_PRINT("ERROR> is_inside_tokens: could not complete malloc buf. Aborting.\n");
       exit(1);
      }

      fgets(buf, unicode_begin+unicode_end+1, f);  //+1 for ending \0

      /* Execute regular expression.*/
      unmatched = regexec(&regex, buf, (size_t) 1, &match_info, REG_NOTBOL|REG_NOTEOL);
      end_offset_match = match_info.rm_eo;

      if(!unmatched)
      {//Matched pattern
        fseek(f, (-unicode_end-unicode_begin+end_offset_match), SEEK_CUR);
        return 0; 
        /*Now is no longer inside a token, since the current positions is at the end of \uXXXX; 
        thus it can exit the while loop in function find_cut_points if more than max_scanned_chunk has been scanned.*/
      }
      else if(unmatched == REG_NOMATCH)
      {//No match
        fseek(f, -unicode_end, SEEK_CUR);
      }
      else{ //regerror(unmatched, &regex, buf, sizeof(buf));
        DEBUG_STDOUT_PRINT("ERROR> is_inside_token: Regex match failed.\n");
        exit(1);
      }
    }
  }

  if(lookup(c, hash_bools, hash_bools_size) || (__FIRST_DIGIT <= c && c <= __LAST_DIGIT) || lookup(c, hash_char_number, hash_char_number_size))
    return 1;

  //Do not put '\\', otherwise it cannot break a sequence of \uXXXX\uXXXX\uXXXX...
  //Do this check only for the first \uXXXX of the chunk.
  
  return 0;

}

/*Initialize thread arguments.*/
void initialize_thread_argument(lex_thread_arg* arg, int32_t thread)
{
  arg[thread].lex_token_list_length[0] = 0;  
  arg[thread].lex_token_list_length[1] = 0;  
  arg[thread].alloc_size = 0;
  arg[thread].realloc_size = 0;
  arg[thread].begin_with_string = thread_begin_with_string[thread]; 
  arg[thread].quotes_number = 0;
  arg[thread].result = 0;

}

int8_t check_thread_mission(lex_thread_arg* arg, int32_t lex_thread_num)
{
  int32_t i;
  int8_t mission = 0;

  for(i = 0; i<lex_thread_num; i++){
    mission += arg[i].result;
    DEBUG_STDOUT_PRINT("Lexing thread %d has result = %d\n", i, arg[i].result)
    if(arg[i].result != 0)
      fprintf(stdout, "Lexing thread number %d failed.\n", i);
  }

  #ifdef __DEBUG
  for(i = 0; i<lex_thread_num; i++)
    DEBUG_STDOUT_PRINT("thread %d: quotes_number = %d\n", i, arg[i].quotes_number)  
  #endif

  return mission;
}

/*Merge token lists produced by the lexing threads.*/
void compute_lex_token_list(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num)
{
  int32_t i = 0, j;
  int32_t quotes_num = arg[0].quotes_number;
  token_node * temp;

  ctx->token_list_length = 0;
  
  while (i < lex_thread_num && arg[i].list_begin[0] == NULL)
    i++;
  if (i == lex_thread_num)
    return;

  ctx->token_list = arg[i].list_begin[0];
  ctx->token_list_length += arg[i].lex_token_list_length[0];
  temp = arg[i].list_end[0];

  for(j = i + 1; j < lex_thread_num; j++)
  {
    if(quotes_num % 2 == 0)
    {//append list 0
      if (arg[j].list_begin[0] != NULL) {
        temp->next = arg[j].list_begin[0];
        temp = arg[j].list_end[0];
        ctx->token_list_length += arg[j].lex_token_list_length[0];
        quotes_num += arg[j].quotes_number;
      }
    }
    else
    {//append list 1
      if (arg[j].list_begin[1] != NULL) {
        assert(arg[j].begin_with_string != 0);
        temp->next = arg[j].list_begin[1];
        temp = arg[j].list_end[1];
        ctx->token_list_length += arg[j].lex_token_list_length[1];
        quotes_num += arg[j].quotes_number;
      }
    }
  }

}

/*Thread task function for reentrant scanner*/
void *lex_thread_task(void *arg)
{  
  lex_thread_arg *ar = (lex_thread_arg*) arg;
  
  FILE * f = fopen(ar->file_name, "r");
  if (f == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> Lexing thread %d could not open input file. Aborting.\n", ar->id);
    exit(1);
  }

  lex_token *flex_token;
  int32_t i;
  yyscan_t scanner;   //reentrant flex instance data
  int32_t flex_return_code;
  token_node *token_builder0 = NULL;
  token_node *token_builder1 = NULL;
  vect_stack stack[2];

  uint32_t alloc_size = 0, realloc_size = 0;

  par_compute_alloc_realloc_size((ar->cut_point_dx - ar->cut_point_sx), &alloc_size, &realloc_size);
  DEBUG_STDOUT_PRINT("LEXER %d > alloc_size %d, realloc_size %d\n", ar->id, alloc_size, realloc_size)

  flex_token = (lex_token*) malloc(sizeof(lex_token));
  if (flex_token == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc flex_token. Aborting.\n");
    exit(1);
  }

  flex_token->begin_with_string = ar->begin_with_string;
  flex_token->quotes_number = ar->quotes_number;

  DEBUG_STDOUT_PRINT("Lexing thread %d: flex_token->begin_with_string = %d\n", ar->id, flex_token->begin_with_string)  

  fseek(f, ar->cut_point_sx, SEEK_SET);

  if(yylex_init_extra(flex_token, &scanner))
  {
    DEBUG_STDOUT_PRINT("ERROR> yylex_init_extra failed.\n")
    exit(1);
  }

  yyset_in(f, scanner);
  
  ar->list_begin[0] = NULL;
  init_vect_stack(&(stack[0]), alloc_size);

  if (ar->begin_with_string != 0)
    {
      ar->list_begin[1] = NULL;
      init_vect_stack(&(stack[1]), alloc_size);
    }

  /*process_list[i] is 1 iff list i can be processed, and no errors have been met until now.*/
  int8_t process_list[2]; 
  process_list[0] = 1;
  process_list[1] = 1;

  int32_t lex_token_length;
  int32_t current_pos = ar->cut_point_sx;

  assert(ar->cut_point_dx - ar->cut_point_sx >= sizeof(char));

  flex_return_code = yylex(scanner);  

  /*The procedure to find cut points cannot cut a single token in two parts.*/
  while(flex_return_code != __END_OF_FILE && current_pos < ar->cut_point_dx)
  {
    lex_token_length = yyget_leng(scanner); 
    current_pos += lex_token_length;
    
    /*Cannot have excessive characters spanning after cut_point_dx if the cut_point does not fall inside a single token.*/
    assert(current_pos <= ar->cut_point_dx);

    if(flex_return_code == __ERROR_BOTH)
      {
        process_list[0] = 0;
        process_list[1] = 0;
        DEBUG_STDOUT_PRINT("Lexing thread %d scanned erroneous input. Abort.\n", ar->id)
        ar->result = 1; /*Signal error by returning result!=0.*/
        fclose(yyget_in(scanner));
        yylex_destroy(scanner);
        pthread_exit(NULL);
      }
    else if(flex_return_code == __SECOND_LIST_LEXING_ERROR)
      {
        process_list[1] = 0;

        if(ar->begin_with_string == 1)
        {/*There is an error in the input file, which does not comply with the lexical grammar: the chunk was expected to begin outside a string*/
          DEBUG_STDOUT_PRINT("Lexing thread %d scanned erroneous input. Abort.\n", ar->id)
          ar->result = 1; /*Signal error by returning result!=0.*/
          fclose(yyget_in(scanner));
          yylex_destroy(scanner);
          pthread_exit(NULL);
        }
      }
    else if(flex_return_code == __FIRST_LIST_LEXING_ERROR)
      {
        process_list[0] = 0;

        if(ar->begin_with_string == 0)
        {/*There is an error in the input file, which does not comply with the lexical grammar: the chunk was expected to begin outside a string*/
          DEBUG_STDOUT_PRINT("Lexing thread %d scanned erroneous input. Abort.\n", ar->id)
          ar->result = 1; /*Signal error by returning result!=0.*/
          fclose(yyget_in(scanner));
          yylex_destroy(scanner);
          pthread_exit(NULL);
        }
      }    

    if (process_list[0] == 1)
    {
      //process list 0
      if(flex_return_code == __LEX_CORRECT_BOTH || flex_return_code == __LEX_FIRST_PAUSE_SEC || flex_return_code == __LEX_FIRST_CHAR_SEC || flex_return_code == __SECOND_LIST_LEXING_ERROR)
      {
        //append a single token
        par_append_token_node(flex_token->token[0], flex_token->semantic_value, &token_builder0, &(ar->list_begin[0]), &(stack[0]), realloc_size);
        (ar->lex_token_list_length[0])++;
      }
      else if(flex_return_code == __CHAR_FIRST_LEX_SEC)
      {
        //append a list of token CHAR, corresponding to (a portion of) a string scanned as a bool or a number
        for(i = 0; i < flex_token->token_lex_list_length; i++)
          par_append_token_node(flex_token->token[0], &((char*) flex_token->semantic_value)[i], &token_builder0, &(ar->list_begin[0]), &(stack[0]), realloc_size);
        ar->lex_token_list_length[0] += flex_token->token_lex_list_length;
      }
    }
    
    if (ar->begin_with_string !=0 && process_list[1] == 1)
    {
      //process list 1
      if(flex_return_code == __LEX_CORRECT_BOTH || flex_return_code == __PAUSE_FIRST_LEX_SEC || flex_return_code == __CHAR_FIRST_LEX_SEC || flex_return_code == __FIRST_LIST_LEXING_ERROR)
      {
        //append a single token
        par_append_token_node(flex_token->token[1], flex_token->semantic_value, &token_builder1, &(ar->list_begin[1]), &(stack[1]), realloc_size);
        (ar->lex_token_list_length[1])++;

      }
      else if(flex_return_code == __LEX_FIRST_CHAR_SEC)
      {
        //append a list of token CHAR, corresponding to (a portion of) a string scanned as a bool or a number
        for(i = 0; i < flex_token->token_lex_list_length; i++)
          par_append_token_node(flex_token->token[1], &((char*) flex_token->semantic_value)[i], &token_builder1, &(ar->list_begin[1]), &(stack[1]), realloc_size);
        ar->lex_token_list_length[1] += flex_token->token_lex_list_length;
      }
    }

    if (current_pos < ar->cut_point_dx)
      {
        flex_return_code = yylex(scanner);  
      }

  }

  ar->quotes_number = flex_token->quotes_number;

  ar->list_end[0] = token_builder0;
  if (ar->begin_with_string != 0)
    ar->list_end[1] = token_builder1;

  fclose(yyget_in(scanner));
  yylex_destroy(scanner);

  pthread_exit(NULL);

}
