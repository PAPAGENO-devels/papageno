#ifndef PAR_LEX_LUA_BRACKETED_STRINGS_H_
#define PAR_LEX_LUA_BRACKETED_STRINGS_H_

#include "assert.h"
#include "pthread.h"

#include "utilities.h"
#include "debug_functions.h"
#include "delimiter_stack_bracketed_strings.h"
#include "token_list.h"
#include "flex_return_codes_bracketed_strings.h"
#include "flex_token_formatting_bracketed_strings.h"
#include "interrupted_strings.h"
#include "flex_token.h"

#include "flex.yy.h"

typedef struct lex_thread_arg {
  uint8_t id;
  int32_t cut_point_sx;
  int32_t cut_point_dx;
  token_node *list_begin[2];
  token_node *list_end;
  int32_t number_tokens_from_last_comment_string; /**< Number of tokens from the last comment, or from the beginning of the chunk if there is no comment symbol. */
  delimiter * delimiter_list[2];
  char * file_name;
  uint32_t alloc_size[2], realloc_size[2];
  uint8_t error_comment_or_bracketed_string; /**< If it is 1, there is an error if the chunk is not followed by the proper end of comment symbol or 
                                   it does not belong to  a bracketed string spanning over the previous and following chunks; otherwise it is 0. */
  int8_t  first_closing_bracket;  /** It is 0 if the chunk has no pair of closing brackets; 1 otherwise.*/
  int32_t first_closing_bracket_pos;  /**If the chunk has a pair of closing brackets, it denotes the position of the first pair of closing brackets in the input file.*/
  delimiter * first_closing_bracket_delim; /**If the chunk has a pair of closing brackets, it denotes the delimiter for the first pair of closing brackets in the input file.*/
} lex_thread_arg;


int32_t find_cut_points(FILE* f, int32_t file_length, int32_t **cut_points, int32_t lex_thread_max_num);
void initialize_thread_argument(lex_thread_arg* arg, int32_t thread);
void compute_lex_token_list(parsing_ctx *ctx, lex_thread_arg *arg, int32_t lex_thread_num);
void *lex_thread_task(void *arg);
int8_t handle_empty_file(parsing_ctx *ctx);


#endif