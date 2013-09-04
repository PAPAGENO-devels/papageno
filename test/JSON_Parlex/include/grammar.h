#ifndef GRAMMAR_H_
#define GRAMMAR_H_

#include <stdio.h>

#include "config.h"
#include "parsing_context.h"
#include "grammar_tokens.h"
#include "grammar_semantics.h"
#include "token_node.h"
#include "token_node_stack.h"
#define GRAMMAR_SIZE 18

typedef void (*gr_function) (token_node *, token_node_stack *, parsing_ctx *);
typedef struct gr_rule {
  gr_token lhs;
  gr_function semantics;
  uint8_t rhs_length;
  gr_token *rhs;
} gr_rule;

void init_grammar(parsing_ctx *ctx);

const char * gr_token_to_string(gr_token token);

#endif
