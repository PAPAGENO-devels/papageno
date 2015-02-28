#ifndef __VECTORIZED_STACK_H_
#define __VECTORIZED_STACK_H_

#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "token_node.h"

typedef struct vect_stack {
  token_node **vect_stack;
  int32_t top_of_stack;
  uint32_t ceil;
} vect_stack;

void init_vect_stack(vect_stack *stack, uint32_t vect_stack_alloc_size);
token_node *vect_stack_push(vect_stack *stack, token_node *token, uint32_t vect_stack_realloc_size);
token_node *vect_stack_pop(vect_stack *stack);
token_node *get_vect_stack_node_at_index(vect_stack *stack, uint32_t index);
void free_vect_stack(vect_stack *stack);

#endif
