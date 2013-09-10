#ifndef PAR_LEX_LUA_H_
#define PAR_LEX_LUA_H_

#include "assert.h"
#include "pthread.h"

#include "utilities.h"
#include "debug_functions.h"
#include "delimiter_stack.h"
#include "token_list.h"
#include "flex_return_codes.h"
#include "flex_token_formatting.h"

#include "flex.yy.h"

typedef struct lex_thread_arg {
  uint8_t id;
  int32_t cut_point_sx;
  int32_t cut_point_dx;
  token_node *list_begin;
  token_node *list_end;
  int32_t number_tokens_from_last_comment; /**< Number of tokens from the last comment, or from the beginning of the chunk if there is no comment symbol. */
  delimiter * delimiter_list;
  char * file_name;
  uint32_t alloc_size, realloc_size;
  uint8_t need_end_comment; /**< If it is 1, there is an error if the chunk is not followed by an ending comment symbol; otherwise it is 0. */
} lex_thread_arg;


typedef struct lex_token {
  gr_token token;       /**< The gr_token representation of the token. */
  void *semantic_value; /**< The semantic value of the token. */
  int32_t comment_type;
  int8_t state_before_comment;
  uint32_t chunk_length;
  int32_t num_chars;
  int8_t read_new_line;
  int32_t allocated_buffer_size;
  char* string_buffer; /**< Buffer for a string token. */
  int32_t current_buffer_length;
} lex_token;

/*flex_token is used by flex to save the tokens inside lex_token_list.*/


int32_t find_cut_points(FILE* f, int32_t file_length, int32_t * cut_points, int32_t lex_thread_max_num);
void initialize_thread_argument(lex_thread_arg* arg, int32_t thread);
int8_t check_thread_mission(lex_thread_arg* arg, int32_t lex_thread_num);
void compute_lex_token_list(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num);
void *lex_thread_task(void *arg);
int8_t handle_empty_file(parsing_ctx *ctx);

#endif
