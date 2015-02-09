// #ifndef __TOKEN_NODE_STACK_H_
// #define __TOKEN_NODE_STACK_H_

// #include <stdlib.h>
// #include <stdint.h>

// #include "token_node.h"

// typedef struct token_node_stack {
// 	token_node *token_node_stack; /**< The actual stack. */
// 	int32_t top_of_stack; /**< Current top of the stack. */
// 	uint32_t ceil; /**< Current maximum size of the stack. */
// } token_node_stack;

// void init_token_node_stack(token_node_stack *stack, uint32_t alloc_size);
// token_node *push_token_node_on_stack(token_node_stack *stack, gr_token token, void *value, uint32_t realloc_size);
// token_node *token_node_stack_pop(token_node_stack *stack);
// token_node *get_node_token_node_stack_at_index(token_node_stack *stack, uint32_t index);
// void free_token_node_stack(token_node_stack *stack);

// #endif
