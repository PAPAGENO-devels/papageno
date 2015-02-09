// #include "token_node_stack.h"

// void init_token_node_stack(token_node_stack *stack, uint32_t alloc_size)
// {
//   void* baseptr;
//   posix_memalign(&baseptr,__CACHE_LINE_SIZE,sizeof(token_node)*alloc_size);
//   stack->token_node_stack = (token_node*) baseptr;
//   stack->ceil = alloc_size;
//   stack->top_of_stack = 0;
// }

// token_node *push_token_node_on_stack(token_node_stack *stack, gr_token token, void *value, uint32_t realloc_size)
// {
//   token_node *new_token_node = NULL;
  
//   /*the token stack is a list of stacks, if the current slab is full, allocate
//    a new slab*/
//   if (stack->top_of_stack >= stack->ceil) {
//     void* new_slab;
//     posix_memalign(&new_slab,__CACHE_LINE_SIZE,sizeof(token_node)*realloc_size);
//     stack->token_node_stack = (token_node*) new_slab;
//     stack->ceil = realloc_size;
//     stack->top_of_stack = 0;
//   }
//   new_token_node = &stack->token_node_stack[stack->top_of_stack];
//   new_token_node->token = token;
//   new_token_node->value = value;
//   new_token_node->next = NULL;
//   new_token_node->parent = NULL;
//   new_token_node->child = NULL;
//   stack->top_of_stack = (stack->top_of_stack) +1;
//   return new_token_node;
// }

// token_node *token_node_stack_pop(token_node_stack *stack)
// {
//   --stack->top_of_stack;
//   return &stack->token_node_stack[stack->top_of_stack];
// }

// token_node *get_node_token_node_stack_at_index(token_node_stack *stack, uint32_t index)
// {
//   if (index >= stack->top_of_stack){
//     return NULL;
//   }
//   return &stack->token_node_stack[index];
// }

// void free_token_node_stack(token_node_stack *stack)
// {
//   free(stack->token_node_stack);
// }

