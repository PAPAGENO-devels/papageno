#include "interrupted_strings.h"

void append_interrupted_bracketed_string(token_node* token_string, int32_t chunk_token_string, int32_t chunk_closed_brackets, interrupted_bracketed_string **interrupted_string_builder, interrupted_bracketed_string** interrupted_string_list) 
{
  interrupted_bracketed_string * interrupted_string = (interrupted_bracketed_string *) malloc(sizeof(interrupted_bracketed_string)); 
  if (interrupted_string == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc interrupted_string. Aborting.\n");
    exit(1);
  }
  //initialize the new element
  interrupted_string->token_string = token_string;
  interrupted_string->chunk_token_string = chunk_token_string;
  interrupted_string->chunk_closed_brackets = chunk_closed_brackets;
  interrupted_string->next = NULL;

  //update interrupted_string_list and interrupted_string_builder
  if (*interrupted_string_list == NULL) {
    *interrupted_string_list = interrupted_string;
    *interrupted_string_builder = interrupted_string;
  } else {
    (*interrupted_string_builder)->next = interrupted_string;
    *interrupted_string_builder = interrupted_string;
  }
}


/*Thread task function for reentrant scanner.*/
void *string_thread_task(void *arg)
{  
  string_thread_arg *ar = (string_thread_arg*) arg;
  
  FILE * f = fopen(ar->file_name, "r");
  if (f == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> Lexing thread %d could not open input file. Aborting.\n", ar->id);
    exit(1);
  }
  
  lex_token *flex_token;
  yyscan_t scanner;   //reentrant flex instance data
  int32_t flex_return_code;
  
  uint32_t chunk_length = ar->cut_point_dx - ar->cut_point_sx;

  /*Initialization flex_token*/
  flex_token = (lex_token*) malloc(sizeof(lex_token));
  if (flex_token == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc flex_token. Aborting.\n");
    exit(1);
  }
  // initialize_flex_token(flex_token);
  flex_token->chunk_length = chunk_length;
  flex_token->num_chars = 0;
  flex_token->allocated_buffer_size[0] = __MAX_BUFFER_SIZE;
  flex_token->string_buffer[0] = (char*) malloc(sizeof(char)*__MAX_BUFFER_SIZE); 
  if (flex_token->string_buffer[0] == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> In Flex: could not complete malloc string_buffer. Aborting.\n");
    exit(1);
  }  
  flex_token->current_buffer_length[0] = 0;
  flex_token->lexing_phase = 1;

  fseek(f, ar->cut_point_sx, SEEK_SET);

  if (yylex_init_extra(flex_token, &scanner)) {
    DEBUG_STDOUT_PRINT("ERROR> yylex_init_extra failed.\n")
    exit(1);
  }

  yyset_in(f, scanner);
  
  flex_return_code = yylex(scanner);

  if (flex_return_code == __LEX_CORRECT || flex_return_code == __END_CHUNK) {
    //Possible return values are __LEX_CORRECT and __END_CHUNK: in both cases the content of the chunk, until its left cut point, has been stored into the string buffer.
    ar->chunk_string = flex_token->string_buffer[0];
    ar->string_length = flex_token->current_buffer_length[0];
  }

  #ifdef __DEBUG
    //Handle errors: these values are never returned 
    if(flex_return_code == __END_CHUNK_ERROR || flex_return_code == __END_OF_FILE)
    {
      DEBUG_STDOUT_PRINT("SECOND LEXING> Lexing thread %d scanned erroneous input. Abort.\n", ar->id)
      fclose(yyget_in(scanner));
      yylex_destroy(scanner);
      pthread_exit(NULL);
      exit(1);
    }
  #endif

  fclose(yyget_in(scanner));
  yylex_destroy(scanner);

  fclose(f);
  
  pthread_exit(NULL);
}
