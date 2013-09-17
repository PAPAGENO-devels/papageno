#ifndef TOKEN_LIST_H_
#define TOKEN_LIST_H_

#include <stdlib.h>

#include "config.h"
#include "token_node_stack.h"

void par_compute_alloc_realloc_size(uint32_t chunk_length, uint32_t *alloc_size, uint32_t *realloc_size);
void par_append_token_node(gr_token token, void* semantic_value, token_node **token_builder, token_node** list_begin, token_node_stack *stack, uint32_t realloc_size);

#endif
