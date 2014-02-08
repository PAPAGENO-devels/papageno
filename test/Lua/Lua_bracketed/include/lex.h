#ifndef __LEX_H_
#define __LEX_H_

#include <stdint.h>
#include "config.h"
#include "debug_functions.h"
#include "grammar_tokens.h"
#include "token_node_stack.h"
#include "flex.yy.h"
#include "flex_return_codes.h"
#include "flex_token_formatting.h"
#include "context_stack.h"


typedef struct lex_token {
  gr_token token;	/**< The gr_token representation of the token. */
  void *semantic_value; /**< The semantic value of the token. */
  int8_t handle_context;
  char * string_buffer;
} lex_token;

/**
 * \brief flex_token is used by flex to save the string tokens inside lex_token_list.
 */
extern lex_token *flex_token;

void compute_alloc_realloc_size(FILE *input_file, uint32_t *alloc_size, uint32_t *realloc_size);

void append_token_node(gr_token token, void* semantic_value, token_node **token_builder, token_node_stack *stack, uint32_t realloc_size, int8_t handle_context);

void perform_lexing(char *file_name, parsing_ctx *ctx);
#endif
