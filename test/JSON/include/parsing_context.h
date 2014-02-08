#ifndef __PARSING_CONTEXT_H_
#define __PARSING_CONTEXT_H_

#include <stdint.h>
#include <grammar_tokens.h>

typedef struct parsing_ctx {
  const struct gr_rule *grammar;
  const uint32_t *rewrite;
  struct token_node *token_list;
  uint32_t token_list_length;
  const gr_token *gr_token_alloc;
  const char * const *gr_token_name;
  uint32_t NODE_ALLOC_SIZE;
  uint32_t NODE_REALLOC_SIZE;
  uint32_t PREC_ALLOC_SIZE;
  uint32_t PREC_REALLOC_SIZE;
} parsing_ctx;

#define __PARSE_SUCCESS 0
#define __PARSE_IN_PROGRESS 1
#define __PARSE_NOT_RECOGNIZED 2
#define __PARSE_ERROR 3

#endif
