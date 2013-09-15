#include "token_node_stack.h"

void init_token_node_stack(token_node_stack *stack, uint32_t alloc_size)
{
	stack->stack = (token_node *) malloc(sizeof(token_node)*alloc_size);
	stack->ceil = alloc_size;
	stack->tos = 0;
}

token_node *push_token_node_on_stack(token_node_stack *stack, gr_token token, void *value, uint32_t realloc_size)
{
    token_node *new_token_node = NULL;
	if (stack->tos >= stack->ceil) {
		stack->stack = (token_node*) malloc(sizeof(token_node)*realloc_size);
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

