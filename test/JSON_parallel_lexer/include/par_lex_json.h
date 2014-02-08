#ifndef __PAR_LEX_JSON_H_
#define __PAR_LEX_JSON_H_

#include "regex.h"
#include "utilities.h"
#include "assert.h"
#include "debug_functions.h"

#include "pthread.h"
#include "token_list.h"
#include "flex_token.h"
#include "flex_return_codes.h"

#include "flex.yy.h"

typedef struct lex_thread_arg {
  uint8_t id;
  int32_t cut_point_sx;
  int32_t cut_point_dx;
  token_node *list_begin[2];
  token_node *list_end[2];
  int32_t lex_token_list_length[2];
  char * file_name;
  uint32_t alloc_size, realloc_size;
  int8_t begin_with_string;
  int32_t quotes_number;
  uint8_t result;
} lex_thread_arg;


int32_t find_cut_points(FILE* f, int32_t file_length, int32_t **cut_points, int32_t lex_thread_max_num);
void initialize_thread_argument(lex_thread_arg* arg, int32_t thread);
int8_t check_thread_mission(lex_thread_arg* arg, int32_t lex_thread_num);
void compute_lex_token_list(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num);
void *lex_thread_task(void *arg);

#endif
