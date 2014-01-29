#include "token_node_stack.h"

void init_token_node_stack(token_node_stack *stack, uint32_t alloc_size)
{
        void* baseptr;
	posix_memalign(&baseptr,CACHE_LINE_SIZE,sizeof(token_node)*alloc_size);
	stack->stack = (token_node*) baseptr;
	stack->ceil = alloc_size;
	stack->tos = 0;
}

token_node *push_token_node_on_stack(token_node_stack *stack, gr_token token, void *value, uint32_t realloc_size)
{
    token_node *new_token_node = NULL;
	if (stack->tos >= stack->ceil) {
  /* TODO: fix memory corruptions happening in the lexer when the allocation
     of further slabs is aligned */
  //     void* new_slab; 
  //     posix_memalign(&new_slab,CACHE_LINE_SIZE,sizeof(token_node)*realloc_size);
    stack->stack = (token_node*) malloc(sizeof(token_node)*realloc_size);// (token_node*) new_slab;
		stack->ceil = realloc_size;
		stack->tos = 0;
	}
        new_token_node = &stack->stack[stack->tos];
	new_token_node->token = token;
	new_token_node->value = value;
	new_token_node->next = NULL;
	new_token_node->parent = NULL;
        new_token_node->child = NULL;
	++stack->tos;
	return new_token_node;
}

