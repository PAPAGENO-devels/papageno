#ifndef OPP_H_
#define OPP_H_

#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>

#include "config.h"

#include "debug_functions.h"
#include "token_node.h"
#include "token_node_stack.h"
#include "reduction_list.h"
#include "grammar.h"

#include "lex.h"

#include "grammar_tokens.h"
#include "parsing_context.h"

#define _EQ_  0
#define _GT_  1 
#define _LT_  2 
#define _NOP_ 3

void reduction_step(reduction_list *temp_reduction_list, uint32_t red_list_node, token_node *list_itr, parsing_ctx *ctx);
uint32_t opp_parse(token_node *c_prev, token_node *c_next, token_node *list_begin, token_node *list_end, parsing_ctx *ctx);

#endif
