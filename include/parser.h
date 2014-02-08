#ifndef __PARSER_H_
#define __PARSER_H_

#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <pthread.h>

#include "config.h"

#include "debug_functions.h"
#include "grammar.h"
#include "lex.h"
#include "opp.h"

typedef struct thread_context_t{
  uint8_t id;
  int16_t *parents;
  uint16_t num_parents;
  uint8_t *results;
  token_node *list_begin;
  token_node *list_end;
  token_node *c_prev;
  token_node *c_next;
  parsing_ctx *ctx;
  pthread_t *threads;
  struct thread_context_t *args;
} thread_context_t;

token_node *parse(int32_t threads,int32_t lex_thread_max_num, char *file_name);
void init_offline_structures(parsing_ctx *ctx);
token_node **compute_bounds(uint32_t length, uint8_t n, token_node *token_list);
void *thread_task(void *arg);
#endif
