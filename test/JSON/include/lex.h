#ifndef __LEX_H_
#define __LEX_H_

#include <stdint.h>
#include "config.h"
#include "debug_functions.h"
#include "grammar_tokens.h"
#include "token_node_stack.h"
#include "../lexer/flex.yy.h"

typedef struct lex_token {
  gr_token token;	/**< The gr_token representation of the token. */
  void *semantic_value; /**< The semantic value of the token. */
} lex_token;

/**
 * \brief flex_token is used by flex to save the string tokens inside lex_token_list.
 */
extern lex_token *flex_token;

void perform_lexing(char *file_name, parsing_ctx *ctx);
void compute_alloc_realloc_size(FILE *input_file, uint32_t *alloc_size, uint32_t *realloc_size);
void append_token_node(lex_token *token, token_node **token_builder, parsing_ctx *ctx, token_node_stack *stack, uint32_t realloc_size);

#endif
