#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "token_node.h"
#include "vect_stack.h"

void init_vect_stack(vect_stack *stack, uint32_t vect_stack_alloc_size)
{
  stack->vect_stack = (token_node**) calloc(vect_stack_alloc_size,sizeof(token_node*));
  stack->ceil = vect_stack_alloc_size;
  stack->top_of_stack = 0;
}

token_node *vect_stack_push(vect_stack *stack, token_node *token, 
                         uint32_t vect_stack_realloc_size)
{
  if (stack->top_of_stack >= stack->ceil) {
    stack->vect_stack = (token_node**) realloc(stack->vect_stack, 
                           sizeof(token_node*)*(stack->ceil + vect_stack_realloc_size));
    stack->ceil += vect_stack_realloc_size;
  }
  stack->vect_stack[stack->top_of_stack] = token;
  stack->top_of_stack=(stack->top_of_stack)+1;

  return token;
}

token_node *vect_stack_pop(vect_stack *stack)
{
  --stack->top_of_stack;
  return stack->vect_stack[stack->top_of_stack];
}

token_node *get_vect_stack_node_at_index(vect_stack *stack, uint32_t index)
{
  if (index >= stack->top_of_stack) {
    return NULL;
  }
  return stack->vect_stack[index];
}

void free_vect_stack(vect_stack *stack)
{
  free(stack->vect_stack);
}