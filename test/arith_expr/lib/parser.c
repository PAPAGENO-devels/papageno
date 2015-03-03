#include <pthread.h>
#include "parser.h"
#include "timers.h"

void compute_preallocation_sizes(parsing_ctx* ctx,int32_t threads){

  float cur_node_estimate;

  ctx->NODE_ALLOC_SIZE = 1;
  cur_node_estimate = 1;
  while (cur_node_estimate < ctx->token_list_length) {
    cur_node_estimate *= __RHS_LENGTH;
    ctx->NODE_ALLOC_SIZE += (uint32_t) cur_node_estimate;
  }
  ctx->NODE_ALLOC_SIZE -= cur_node_estimate;
  ctx->NODE_ALLOC_SIZE = ctx->NODE_ALLOC_SIZE*2/3/threads;
  ctx->NODE_REALLOC_SIZE = ctx->NODE_ALLOC_SIZE/10 + 1;

  ctx->PREC_ALLOC_SIZE = ctx->token_list_length/100;
  ctx->PREC_ALLOC_SIZE += 4096/sizeof(token_node *) - ((ctx->PREC_ALLOC_SIZE*sizeof(token_node *)) % 4096)/sizeof(token_node *);
  ctx->PREC_REALLOC_SIZE = ctx->PREC_ALLOC_SIZE/10;
}

void pretty_print_parse_status(uint32_t parse_status){
   fprintf(stdout, "Parse action finished:");
   switch (parse_status){
     case __PARSE_SUCCESS:
       fprintf(stdout,  "Successful parse\n");
       break;
     case __PARSE_NOT_RECOGNIZED:
      fprintf(stdout, "The string does not belong to the language\n");
      break;
     case __PARSE_IN_PROGRESS:
      fprintf(stdout, "Chunk parse ended, more parsing to be done\n");
      break;
     default:
      fprintf(stdout, "Invalid return code\n");
  }  
}

token_node *parse(int32_t threads, int32_t lex_thread_max_num, char *file_name)
{
  uint32_t i, parse_status;
  uint32_t step_size, step_index;
  int32_t num_threads;
  uint8_t *results;
  parsing_ctx ctx;
  token_node **bounds;
  token_node *list_ptr;
  token_node *l_token = NULL;
  pthread_t *thread;
  thread_context_t *contexts;
  struct timespec parse_timer_start, parse_timer_end, lex_timer_start, lex_timer_end;
  double lexing_time, parsing_time;
#if defined __LOG_RECOMBINATION
  uint32_t j;
#endif
  /* Redirect stderr. */
#ifdef __DEBUG
  if (freopen("DEBUG", "w", stderr) == NULL) {
    DEBUG_STDOUT_PRINT("OPP> Error: could not redirect stderr to DEBUG.\n")
  }
#endif

  init_offline_structures(&ctx);

  portable_clock_gettime(&lex_timer_start);

  DEBUG_STDOUT_PRINT("OPP> Lexing...\n")
  perform_lexing(file_name, &ctx);
  portable_clock_gettime(&lex_timer_end);
  
  portable_clock_gettime(&parse_timer_start);

  compute_preallocation_sizes(&ctx,threads);
  bounds = compute_bounds(ctx.token_list_length, threads, ctx.token_list);

  /* Compute number of threads based on mode. */
  num_threads = threads;
  if (threads > 1) {
#if defined __SINGLE_RECOMBINATION
    ++num_threads;
#elif defined __LOG_RECOMBINATION
    num_threads = num_threads*2 -__builtin_popcount(num_threads);
#else
#error "Chunk recombination strategy undefined, define it in config.h"
#endif
  }
  DEBUG_STDOUT_PRINT("OPP> Num_threads %d\n", num_threads)

  /* Allocate threads. */
  contexts = (thread_context_t *) malloc(sizeof(thread_context_t) * num_threads);
  thread = (pthread_t *) malloc(sizeof(pthread_t)*num_threads);
  results = (uint8_t *) malloc(sizeof(uint8_t)*num_threads);
  if (thread == NULL || contexts == NULL || results == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> Thread allocation failed\n")
      return NULL;
  }

  /* Create and launch threads. */
  step_size = threads;
  step_index = 0;
  /* Create initial common threads. */
  for (i = 0; i < threads; ++i) {
    DEBUG_STDOUT_PRINT("OPP> creating thread %d.\n", i)
    contexts[i].id = i;
    /* Set list_begin. */
    if (i == 0) {
      contexts[i].list_begin = bounds[i];
      DEBUG_STDOUT_PRINT("OPP> list begin first thread %s \n", gr_token_to_string(bounds[i]->token));
    } else {
      list_ptr = bounds[i]->next;
      contexts[i].list_begin = list_ptr;
      DEBUG_STDOUT_PRINT("OPP> list begin thread %d is %s \n", i, gr_token_to_string(list_ptr->token));
    }
    /* Get prev context. */
    if (i == 0) {
      l_token = new_token_node(__TERM, NULL);
      DEBUG_STDOUT_PRINT("OPP> c_prev context thread %d is __TERM \n", i);
    } else {
      list_ptr = bounds[i];
      l_token = new_token_node(list_ptr->token, NULL);
      DEBUG_STDOUT_PRINT("OPP> c_prev context thread %d is %s \n", i, gr_token_to_string(list_ptr->token));
    }
    l_token->next = contexts[i].list_begin;
    contexts[i].c_prev = l_token;
    /* Get next context. */
    if (i == threads - 1) {
      l_token = new_token_node(__TERM, NULL);
      DEBUG_STDOUT_PRINT("OPP> c_next context thread %d is __TERM \n", i);
    } else {
      list_ptr = bounds[i + 1]->next;
      l_token = new_token_node(list_ptr->token, NULL);
      DEBUG_STDOUT_PRINT("OPP> c_next context thread %d is %s \n", i, gr_token_to_string(list_ptr->token));
    }
    contexts[i].c_next = l_token;
    /* Set list end. */
    contexts[i].list_end = (i + 1 < threads ? bounds[i + 1]->next : NULL);
    contexts[i].num_parents = 0;
    contexts[i].threads = thread;
    contexts[i].args = contexts;
    contexts[i].results = results;
    contexts[i].ctx = &ctx;
    pthread_create(&thread[i], NULL, thread_task, (void *)&contexts[i]);
  }

  if (threads < num_threads) {
    DEBUG_STDOUT_PRINT("OPP> creating additional threads, starting from i = %d.\n", i)
    /* Create additional threads depending on mode. */
#if defined __SINGLE_RECOMBINATION      
      /* Only one iteration. */
      DEBUG_STDOUT_PRINT("OPP> creating mode ONE thread, i = %d.\n", threads)
      contexts[threads].id = threads;
      contexts[threads].parents = (int16_t *) malloc(sizeof(int16_t)*threads);
      contexts[threads].c_prev = contexts[0].c_prev;
      for (i = 0; i < threads; ++i) {
        contexts[threads].parents[i] = i;
      }
      contexts[threads].c_next = contexts[i - 1].c_next;
      contexts[threads].num_parents = threads;
      contexts[threads].threads = thread;
      contexts[threads].args = contexts;
      contexts[threads].results = results;
      contexts[threads].ctx = &ctx;
      pthread_create(&thread[threads], NULL, thread_task, (void *)&contexts[threads]);
#elif defined __LOG_RECOMBINATION
      unsigned int step_first_index = 0;
      step_size /= 2;
      DEBUG_STDOUT_PRINT("OPP> creating mode LOG threads.\n")
      /* Create different iterations. */
      for (; i < num_threads; ++i) {
        DEBUG_STDOUT_PRINT("OPP> creating thread %d, with step index %d and step size %d.\n", i, step_index, step_size)
        contexts[i].id = i;
        contexts[i].c_prev = contexts[step_first_index + step_index*2].c_prev;
        if (step_index == step_size - 1) {
          contexts[i].num_parents = i - step_index*3 - step_first_index;
          contexts[i].parents = (int16_t *) malloc(sizeof(int16_t)*contexts[i].num_parents);
          for (j = 0; j < contexts[i].num_parents; ++j) {
            contexts[i].parents[j] = step_first_index + step_index*2 + j;
          }
        } else {
          contexts[i].num_parents = 2;
          contexts[i].parents = (int16_t *) malloc(sizeof(int16_t)*2);
          contexts[i].parents[0] = step_first_index + step_index*2;
          contexts[i].parents[1] = step_first_index + step_index*2 + 1;
        }
        contexts[i].c_next = contexts[contexts[i].parents[contexts[i].num_parents - 1]].c_next;
        contexts[i].threads = thread;
        contexts[i].args = contexts;
        contexts[i].results = results;
        contexts[i].ctx = &ctx;
        pthread_create(&thread[i], NULL, thread_task, (void *)&contexts[i]);
        ++step_index;
        if (step_index >= step_size) {
          step_first_index = i - step_size + 1;
          step_index = 0;
          step_size /= 2;
        }
      }
#else
#error "Chunk recombination strategy undefined, define it in config.h"
#endif
  }

  /* Wait for last thread to finish. */
  DEBUG_STDOUT_PRINT("OPP> Waiting for thread %d to finish.\n", num_threads - 1)
  pthread_join(thread[num_threads - 1], NULL);
  parse_status = results[num_threads - 1];

  /* Free threads and arguments. */
  DEBUG_STDOUT_PRINT("OPP> Freeing threads.\n")
  for (i = 0; i < threads; ++i) {
    free(contexts[i].c_prev);
    free(contexts[i].c_next);
  }
  free(thread);

  // clock_gettime(CLOCK_REALTIME, &timer_r);
  portable_clock_gettime(&parse_timer_end);
  pretty_print_parse_status(parse_status);

  lexing_time= compute_time_interval(&lex_timer_start, &lex_timer_end);
  parsing_time=compute_time_interval(&parse_timer_start, &parse_timer_end);

  fprintf(stdout, "\nLexer: %lf s\nParser: %lf s ",lexing_time,parsing_time);

  return ctx.token_list;
}

void init_offline_structures(parsing_ctx *ctx)
{
  ctx->token_list = NULL;
  ctx->grammar = NULL;
  ctx->token_list_length = 0;
  init_grammar(ctx);
}

token_node **compute_bounds(uint32_t length, uint8_t n, token_node *token_list)
{
  token_node **bounds;
  token_node *list;
  uint32_t n_len, n_itr, t_pos;

  bounds = (token_node**) malloc(sizeof(token_node*)*n);
  n_len = length / n;
  list = token_list;
  bounds[0] = list;
  list = list->next;
  t_pos = 1;
  n_itr = 1;
  while (list != NULL && t_pos < n_len*n) {
    if (t_pos % n_len == 0) {
      bounds[n_itr] = list;
      DEBUG_STDOUT_PRINT("PARSER> bounds %d has token %s in position %d \n", n_itr, gr_token_to_string(list->token), t_pos);
      ++n_itr;
    }
    list = list->next;
    ++t_pos;
  }
  return bounds;
}


void *thread_task(void *worker_thread_ctx)
{
  thread_context_t *thread_context, *thread_arguments;
  uint32_t parse_result,i;
  uint32_t parent_index;
  token_node *list_ptr;
  uint32_t parse_status = __PARSE_IN_PROGRESS;

  thread_context = (thread_context_t*) worker_thread_ctx;
  thread_arguments = thread_context->args;
  if (thread_context->num_parents > 0) {
    /* Wait for parent threads to finish. */
    for (i = 0; i < thread_context->num_parents; ++i) {
      pthread_join(thread_context->threads[thread_context->parents[i]], NULL);
      parse_status = thread_context->results[thread_context->parents[i]];
      if (parse_status != __PARSE_IN_PROGRESS) {
        break;
      }
    }
    /* Join subtrees. */
    for (i = 0; i < thread_context->num_parents; ++i) {
      parent_index = thread_context->parents[i];
      list_ptr = thread_arguments[parent_index].c_prev;
      while (list_ptr->parent != NULL) {
        list_ptr = list_ptr->parent;
      }
      if (list_ptr != thread_context->ctx->token_list) {
        list_ptr->next = thread_arguments[parent_index].c_prev->next;
      }
    }
    /* Get list_begin and list_end. */
    list_ptr = thread_arguments[thread_context->parents[0]].list_begin;
    while (list_ptr->parent != NULL) {
      list_ptr = list_ptr->parent;
    }
    thread_context->list_begin = list_ptr;
    thread_context->list_end = thread_arguments[thread_context->parents[thread_context->num_parents - 1]].list_end;
  }
  /* Launch parser. */
  if (parse_status == __PARSE_IN_PROGRESS) { 
    parse_result = opp_parse(thread_context->c_prev, thread_context->c_next, thread_context->list_begin, thread_context->list_end, thread_context->ctx);

    fprintf(stdout, "Pthread %d> result %d\n", thread_context->id, parse_result);
    thread_context->results[thread_context->id] = parse_result;

#ifdef __DEBUG
    if (parse_result== 0) {
      PRINT_TOKEN_NODE_TREE(thread_context->ctx, 0, thread_context->ctx->token_list)
    }
#endif

  } else {
    thread_context->results[thread_context->id] = parse_status;
  }
  pthread_exit(NULL);
}

