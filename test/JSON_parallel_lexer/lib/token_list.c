#include "token_list.h"

void par_compute_alloc_realloc_size(uint32_t chunk_length, uint32_t *alloc_size, uint32_t *realloc_size)
{
  *alloc_size = ((float) chunk_length) / __TOKEN_SIZE;
  *realloc_size = *alloc_size/10;
}

void par_append_token_node(gr_token token, void* semantic_value, token_node **token_builder, token_node** list_begin, token_node_stack *stack, uint32_t realloc_size)
{
  token_node *tok = push_token_node_on_stack(stack, token, semantic_value, realloc_size);
  if (*list_begin == NULL) {
    *list_begin = tok;
    *token_builder = tok;
  } else {
    (*token_builder)->next = tok;
    *token_builder = tok;
  }
}
