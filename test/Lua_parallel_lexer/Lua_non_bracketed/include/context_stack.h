#ifndef CONTEXT_STACK_H_
#define CONTEXT_STACK_H_

#include <stdlib.h>
#include <stdint.h>
#include "math.h"

#include "delimiter.h"
#include "debug_functions.h"
#include "config.h"

typedef struct context_delimiter {
	delimiter *current;
	struct context_delimiter *prev_in_stack;
} context_delimiter;

void push_context(context_delimiter **stack, delimiter *d);
delimiter *pop_context(context_delimiter **stack);
uint8_t top_context(context_delimiter *stack);

#endif
