#include "par_lex_expr.h"

#define __FIRST_DIGIT 48
#define __LAST_DIGIT  57


int32_t find_cut_points(FILE* f, int32_t file_length, int32_t **cut_points, int32_t lex_thread_max_num)
{
  int32_t i = 1, lex_thread_num = 1;
  int32_t c;
  int8_t next = 1;
  int32_t * cut_points_ptr = *cut_points;
  
  while (i<lex_thread_max_num && next)
  {
    fseek(f, cut_points_ptr[i], SEEK_SET);
    c = fgetc(f);

    while(__FIRST_DIGIT<=c && c<=__LAST_DIGIT && !feof(f)) 
      c = fgetc(f);

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
  
 //realloc cut_points (for short chunks)
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
  arg[thread].lex_token_list_length = 0;
  arg[thread].alloc_size = 0;
  arg[thread].realloc_size = 0;
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

  return mission;
}

/*Merge token lists produced by the lexing threads.*/
void compute_lex_token_list(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num)
{
  int32_t i = 0, j;
  token_node * temp;

  ctx->token_list_length = 0;

  while (i < lex_thread_num && arg[i].list_begin == NULL)
    i++;
  if (i == lex_thread_num)
    return;

  ctx->token_list = arg[i].list_begin;
  ctx->token_list_length += arg[i].lex_token_list_length;
  temp = arg[i].list_end;

  for(j = i + 1; j < lex_thread_num; j++)
  {
    //append list
    if (arg[j].list_begin != NULL) {
      temp->next = arg[j].list_begin;
      temp = arg[j].list_end;
      ctx->token_list_length += arg[j].lex_token_list_length;
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
  int8_t end_of_chunk = 0;
  yyscan_t scanner;   //reentrant flex instance data
  int32_t flex_return_code;
  token_node *token_builder = NULL;
  token_node_stack stack;
  sem_value_stack stack_char;
  sem_value_stack stack_int;

  uint32_t alloc_size = 0, realloc_size = 0;

  uint32_t chunk_length = ar->cut_point_dx - ar->cut_point_sx;

  par_compute_alloc_realloc_size((ar->cut_point_dx - ar->cut_point_sx), &alloc_size, &realloc_size);
  DEBUG_STDOUT_PRINT("LEXER %d > alloc_size %d, realloc_size %d\n", ar->id, alloc_size, realloc_size)

  /*Initialization flex_token*/
  flex_token = (lex_token*) malloc(sizeof(lex_token));
  if (flex_token == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc flex_token. Aborting.\n");
    exit(1);
  }
  flex_token->chunk_length = chunk_length;
  flex_token->num_chars = 0;
  flex_token->chunk_ended = 0;
  //Initialize stack for semantic values.
  //Since the possible semantic values are only char or int, we can allocate two different stacks, one for each type, avoiding to waste memory.
  init_sem_value_stack(&stack_char, alloc_size, 0);
  init_sem_value_stack(&stack_int, alloc_size, 1);
  flex_token->stack_char = &stack_char;
  flex_token->stack_int = &stack_int;
  flex_token->realloc_size = realloc_size;

  fseek(f, ar->cut_point_sx, SEEK_SET);

  if(yylex_init_extra(flex_token, &scanner))
  {
    DEBUG_STDOUT_PRINT("ERROR> yylex_init_extra failed.\n")
    exit(1);
  }

  yyset_in(f, scanner);
  
  ar->list_begin = NULL;
  init_token_node_stack(&(stack), alloc_size);

  flex_return_code = yylex(scanner); 

  /*The procedure to find cut points cannot cut a single token in two parts.*/
  while(!end_of_chunk && flex_return_code != __END_OF_CHUNK && flex_return_code != __END_OF_FILE)
  {
    if(flex_return_code == __LEX_CORRECT) {
      //append a token
      par_append_token_node(flex_token->token, flex_token->semantic_value, &token_builder, &(ar->list_begin), &stack, realloc_size);
      ar->lex_token_list_length++;
    }
    else {
      //flex_return_code is __ERROR)
      DEBUG_STDOUT_PRINT("Lexing thread %d scanned erroneous input. Abort.\n", ar->id)
      ar->result = 1; /*Signal error by returning result!=0.*/
      fclose(yyget_in(scanner));
      yylex_destroy(scanner);
      fclose(f);
      pthread_exit(NULL);
    }

    if (flex_token->chunk_ended)
      end_of_chunk = 1;
    else {
      //Continue to scan the chunk
      flex_return_code = yylex(scanner); 
    }
  }

  ar->list_end = token_builder;

  fclose(yyget_in(scanner));
  yylex_destroy(scanner);

  fclose(f);

  pthread_exit(NULL);

}