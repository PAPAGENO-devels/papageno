#ifndef __DEBUG_FUNCTIONS_H_
#define __DEBUG_FUNCTIONS_H_

#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "parsing_context.h"
#include "reduction_tree.h"
#include "grammar.h"
#include "token_node.h"

#ifdef __DEBUG
#define DEBUG_PRINT(...) fprintf(stderr, __VA_ARGS__);
#define DEBUG_STDOUT_PRINT(...) fprintf(stdout, __VA_ARGS__);
#define PRINT_TOKEN_NODE_FRONTIER(ctx) {\
  token_node *debug_lex_temp = (ctx)->token_list; \
  uint32_t debug_lex_index = 0; \
  fprintf(stderr, "Printing token_list:\n|- "); \
  while (debug_lex_temp != NULL) { \
    fprintf(stderr, "<%d, %p, %s, %s> ", debug_lex_index, debug_lex_temp, (ctx)->gr_token_name[token_value(debug_lex_temp->token)], (char *) debug_lex_temp->value); \
    debug_lex_temp = debug_lex_temp->next; \
    ++debug_lex_index; \
  } \
  fprintf(stderr, "-|\n"); \
}
#define PRINT_PRECEDENCE_STACK(precedence_stack) {\
  uint32_t debug_precedence_index; \
  fprintf(stderr, "Prec_stack: <"); \
  for(debug_precedence_index = 0; debug_precedence_index < (precedence_stack)->tos; ++debug_precedence_index) { \
    fprintf(stderr, "%p, ", (precedence_stack)->stack[debug_precedence_index]); \
  } \
  fprintf(stderr, ">\n"); \
}
#define PRINT_REDUCTION_LIST(reduction_list) {\
  uint32_t debug_reduction_index; \
  fprintf(stderr, "Reduction_list: <"); \
  for (debug_reduction_index = 0; debug_reduction_index < (reduction_list)->tol; ++debug_reduction_index) { \
    fprintf(stderr, "%d, ", (reduction_list)->list[debug_reduction_index]); \
  } \
  fprintf(stderr, ">\n"); \
}
#define PRINT_TOKEN_NODE_TREE(ctx, level, tree) print_token_node_tree((ctx), (level), (tree));
void print_token_node_tree(parsing_ctx *ctx, uint32_t level, token_node *tree);
#define PRINT_GRAMMAR_RULE(rule, ctx) {\
  int32_t debug_rhs_i; \
  fprintf(stdout, "%s ->", (ctx)->gr_token_name[token_value((rule)->lhs)]); \
  for (debug_rhs_i = 0; debug_rhs_i < (rule)->rhs_length; debug_rhs_i++) { \
    fprintf(stdout, " %s", (ctx)->gr_token_name[token_value((rule)->rhs[debug_rhs_i])]); \
  } \
}
#define PRINT_REWRITE_RULES(ctx) {\
  uint32_t itr, offset; \
  uint32_t *ptr, *end; \
  fprintf(stdout, "Rewrite array:\n"); \
  for (itr = 0; itr < __NTERM_LEN; ++itr) { \
    fprintf(stdout, "Rewrite(%s) = {", (ctx)->gr_token_name[token_value(gr_nterm_token(itr))]); \
    offset = (ctx)->rewrite[itr]; \
    ptr = &(ctx)->rewrite[offset]; \
    end = ptr + *ptr + 1; \
    for (++ptr; ptr != end; ++ptr) { \
      fprintf(stdout, " %s", (ctx)->gr_token_name[token_value(*ptr)]); \
    } \
    fprintf(stdout, " }\n"); \
  } \
}
#define PRINT_BOUNDS(bounds, threads) {\
  uint32_t i; \
  fprintf(stdout, "OPP> Printing bounds: "); \
  for (i = 0; i < (threads); ++i) { \
    fprintf(stdout, "%p ", (bounds)[i]); \
  } \
  fprintf(stdout, "\n"); \
}
#else
#define DEBUG_PRINT(...)
#define DEBUG_STDOUT_PRINT(...)
#define PRINT_TOKEN_NODE_FRONTIER(ctx)
#define PRINT_PRECEDENCE_STACK(stack)
#define PRINT_REDUCTION_LIST(reduction_list)
#define PRINT_TOKEN_NODE_TREE(ctx, level, tree)
#define PRINT_GRAMMAR_RULE(rule, ctx)
#define PRINT_REWRITE_RULES(ctx)
#define PRINT_BOUNDS(bounds, threads)
#endif

#endif
