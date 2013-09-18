#ifndef FLEX_TOKEN_H_
#define FLEX_TOKEN_H_

#include "grammar_tokens.h"
#include "flex_token_formatting.h"

typedef struct lex_token {
  gr_token token;       /**< The gr_token representation of the token. */
  void *semantic_value; /**< The semantic value of the token. */
  int32_t comment_type;
  int8_t state_before_comment;
  uint32_t chunk_length;
  int32_t num_chars;
  int8_t read_new_line;
  int8_t insert_function;
  int32_t allocated_buffer_size;
  char* string_buffer; /**< Buffer for a string token. */
  int32_t current_buffer_length;
} lex_token;

/*lex_token is used by flex to save the tokens inside lex_token_list.*/

#endif

