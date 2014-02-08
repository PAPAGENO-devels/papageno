#ifndef __SEM_VALUE_STACK_H_
#define __SEM_VALUE_STACK_H_

#include <stdlib.h>
#include <stdint.h>
#include "debug_functions.h"

typedef struct sem_value_stack {
	void *stack; /**< The actual stack. */
	uint32_t tos; /**< Current top of the stack. */
	uint32_t ceil; /**< Current maximum size of the stack. */
	int8_t type;
} sem_value_stack;

void init_sem_value_stack(sem_value_stack *stack, uint32_t alloc_size, int8_t type);
void *push_sem_value_on_stack(sem_value_stack *stack, void *value, uint32_t realloc_size, int8_t type);

#endif
