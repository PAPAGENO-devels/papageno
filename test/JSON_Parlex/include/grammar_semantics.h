#ifndef GRAMMAR_SEMANTICS_H_
#define GRAMMAR_SEMANTICS_H_

#include "token_node.h"
#include "token_node_stack.h"
#include "parsing_context.h"

void r_OBJECT_LBRACERBRACE(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_OBJECT_LBRACEMEMBERSRBRACE(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_MEMBERS_PAIR(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_MEMBERS_PAIRCOMMAMEMBERS(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_PAIR_STRINGCOLONVALUE(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_VALUE_STRING(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_VALUE_NUMBER(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_VALUE_OBJECT(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_VALUE_ARRAY(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_VALUE_BOOL(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_STRING_QUOTESQUOTES(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_STRING_QUOTESCHARSQUOTES(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_CHARS_CHAR(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_CHARS_CHARCHARS(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_ARRAY_LSQUARERSQUARE(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_ARRAY_LSQUAREELEMENTSRSQUARE(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_ELEMENTS_VALUE(token_node *p, token_node_stack *stack, parsing_ctx *ctx);
void r_ELEMENTS_VALUECOMMAELEMENTS(token_node *p, token_node_stack *stack, parsing_ctx *ctx);

#endif
