#ifndef __OPP_H_
#define __OPP_H_

#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>

#include "config.h"

#include "debug_functions.h"
#include "token_node.h"
#include "token_node_stack.h"
#include "grammar.h"

#include "lex.h"

#include "grammar_tokens.h"
#include "parsing_context.h"

#define __EQ  0
#define __GT  1 
#define __LT  2 
#define __NOP 3

uint32_t opp_parse(token_node *c_prev, token_node *c_next, token_node *list_begin, token_node *list_end, parsing_ctx *ctx);

#endif
