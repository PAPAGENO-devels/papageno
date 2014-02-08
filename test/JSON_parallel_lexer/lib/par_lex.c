#include "par_lex.h"

void perform_lexing(int32_t lex_thread_max_num, char *file_name, parsing_ctx *ctx)
{
  int32_t i, lex_thread_num;
  int8_t mission = 0;

  assert(lex_thread_max_num>1);

  pthread_t *lex_threads;
  lex_thread_arg *arg;

  //Step 1: Finds cut points in the input file
  FILE* f = fopen(file_name, "r");
  if (f == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not open input file. Aborting.\n");
    exit(1);
  }

  fseek(f, 0, SEEK_END);
  int32_t file_length = ftell(f);
  DEBUG_STDOUT_PRINT("File length: %d \n", file_length);

  //Empty input file
  if(file_length == 0) {
    fprintf(stdout, "Input file is empty. Exit.\n");
    fclose(f); 
    exit(1);
  }

  //At least a character per chunk.
  int32_t max_num_chunk = file_length/sizeof(char);
  if(lex_thread_max_num > max_num_chunk)
  {
    DEBUG_STDOUT_PRINT("Too many threads for the length of the input file: %d > %d\n", lex_thread_max_num, max_num_chunk);
    lex_thread_max_num = max_num_chunk;
  }

  int32_t * cut_points = (int32_t *) malloc(sizeof(int32_t)*lex_thread_max_num); 
  if (cut_points == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc cut_points. Aborting.\n");
    exit(1);
  }
  
  for (i=0; i<lex_thread_max_num; i++)
    cut_points[i] = i* (file_length / lex_thread_max_num);
 
  lex_thread_num = find_cut_points(f, file_length, &cut_points, lex_thread_max_num);

  DEBUG_STDOUT_PRINT("lex_thread_num = %d\n", lex_thread_num)

  for (i=0; i<lex_thread_num; i++)
     DEBUG_STDOUT_PRINT("cut_points number %d is %d\n", i, cut_points[i]);

  //Step 2:Create and launch the lexer threads
  /* Allocate threads. */
  arg = (lex_thread_arg *) malloc(sizeof(lex_thread_arg)*lex_thread_num);
  lex_threads = (pthread_t *) malloc(sizeof(pthread_t)*lex_thread_num);
  if (lex_threads == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> lex_threads = NULL after malloc\n")
      exit(1);
  }
  if (arg == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> arg = NULL after malloc\n")
      exit(1);
  }

  /* Create and launch threads. */
  for (i = 0; i < lex_thread_num; ++i) {
    DEBUG_STDOUT_PRINT("OPP> creating thread %d.\n", i)
    arg[i].id = i;
    arg[i].cut_point_sx = cut_points[i];
    DEBUG_STDOUT_PRINT("OPP> thread %d has cut_point_sx = %d\n",i, cut_points[i])
    if(i != lex_thread_num-1)
      {
        arg[i].cut_point_dx = cut_points[i+1];
        DEBUG_STDOUT_PRINT("OPP> thread %d has cut_point_dx = %d\n",i, cut_points[i+1])
      }
    else
      {
        arg[i].cut_point_dx = file_length;
        DEBUG_STDOUT_PRINT("OPP> thread %d has cut_point_dx = %d\n",i, file_length)
      }
    arg[i].file_name = file_name;

    initialize_thread_argument(arg, i);

    pthread_create(&lex_threads[i], NULL, lex_thread_task, (void *)&arg[i]);
  }

  /* Wait for all threads to finish. */
  for(i = 0; i<lex_thread_num; i++){
    pthread_join(lex_threads[i], NULL);
  }

  mission = check_thread_mission(arg, lex_thread_num);

  if(mission != 0)
  {
    fprintf(stdout, "Input file does not comply with the lexical grammar. Exit.\n");
    DEBUG_STDOUT_PRINT("OPP> Freeing threads.\n")
    free(lex_threads);
    fclose(f); 
    exit(1);
  }

  /*Merge token lists produced by the lexing threads.*/
  compute_lex_token_list(ctx, arg, lex_thread_num);

  /* Free threads*/
  DEBUG_STDOUT_PRINT("OPP> Freeing threads.\n")
  free(lex_threads); 

  fclose(f);

  //Empty input file (only with spaces)
  if(ctx->token_list_length == 0) {
    fprintf(stdout, "Input file is empty. Exit.\n");
    exit(1);
  }

  #ifdef __DEBUG
  DEBUG_STDOUT_PRINT("ctx->token_list_length is %d\n", ctx->token_list_length)
  token_node * temp = ctx->token_list;
  for(i = 0; i<ctx->token_list_length; i++)
  {
    DEBUG_STDOUT_PRINT("token number %d is %s = %x with semantic_value = %s\n", i, gr_token_to_string(temp->token), temp->token, (char*) temp->value)
    temp = temp->next;
  }
  #endif

}