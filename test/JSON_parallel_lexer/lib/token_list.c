#include "token_list.h"
#include "vect_stack.h"

void par_compute_alloc_realloc_size(uint32_t chunk_length, uint32_t *alloc_size, uint32_t *realloc_size)
{
  *alloc_size = ((float) chunk_length) / __TOKEN_SIZE;
  *realloc_size = *alloc_size/10;
}

void par_append_token_node(gr_token token, void* semantic_value, token_node **token_builder, token_node** list_begin, vect_stack *stack, uint32_t realloc_size)
{
  token_node *ttp = (token_node*) malloc(sizeof(token_node));
  ttp->token = token;
  ttp->value = semantic_value;
  ttp->next = NULL;
  ttp->parent = NULL;
  ttp->child = NULL;

  token_node *tok = vect_stack_push(stack, ttp, realloc_size);
  if (*list_begin == NULL) {
    *list_begin = tok;
    *token_builder = tok;
  } else {
    (*token_builder)->next = tok;
    *token_builder = tok;
  }
}
