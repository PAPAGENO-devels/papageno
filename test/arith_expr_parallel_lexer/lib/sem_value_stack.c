#include "sem_value_stack.h"

/*type is 0 for char, 1 for uint32_t*/
void init_sem_value_stack(sem_value_stack *stack, uint32_t alloc_size, int8_t type)
{
	if (type == 0)
		stack->stack = (char*) malloc(sizeof(char)*alloc_size);
	else
		stack->stack = (uint32_t*) malloc(sizeof(uint32_t)*alloc_size);
	
	if (stack->stack == NULL) {
		DEBUG_STDOUT_PRINT("ERROR> could not complete malloc stack->stack. Aborting.\n");
		exit(1);
	}
	stack->ceil = alloc_size;
	stack->tos = 0;
}

void * push_sem_value_on_stack(sem_value_stack *stack, void *value, uint32_t realloc_size, int8_t type)
{
    void * new_sem_value = NULL;
	if (stack->tos >= stack->ceil) {
		if (type == 0)
			stack->stack = (char*) malloc(sizeof(char)*realloc_size);
		else
			stack->stack = (uint32_t*) malloc(sizeof(uint32_t)*realloc_size);

		if (stack->stack == NULL) {
			DEBUG_STDOUT_PRINT("ERROR> could not complete malloc stack->stack. Aborting.\n");
			exit(1);
		}
		stack->ceil = realloc_size;
		stack->tos = 0;
	}
	if (type == 0) {
		char * stack_char = (char*) stack->stack;
		stack_char[stack->tos] = *((char*)value);
		new_sem_value = &stack_char[stack->tos];
	}
	else {
		uint32_t * stack_int = (uint32_t*) stack->stack;
		stack_int[stack->tos] = *((uint32_t*)value);
		new_sem_value = &stack_int[stack->tos];
	}
	++stack->tos;
	return new_sem_value;
}

