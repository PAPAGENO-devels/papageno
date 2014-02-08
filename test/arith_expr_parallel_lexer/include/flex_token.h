#ifndef __FLEX_TOKEN_H_
#define __FLEX_TOKEN_H_

#include "grammar_tokens.h"
#include "sem_value_stack.h"

typedef struct lex_token {
  gr_token token;  /**< The gr_token representation of the token. */
  void *semantic_value; /**< The semantic value of the token. */
  int32_t chunk_length;
  int32_t num_chars;    /*number of chars read during the scanning of the chunk*/
  int8_t chunk_ended; /*0 if the chunk did not end, 1 if the chunk ended*/
  sem_value_stack * stack_char;
  sem_value_stack * stack_int;
  uint32_t realloc_size;
} lex_token;

/*lex_token is used by flex to save the tokens inside lex_token_list.*/

#endif