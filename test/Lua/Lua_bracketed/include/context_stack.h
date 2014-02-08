#ifndef __CONTEXT_STACK_H_
#define __CONTEXT_STACK_H_

#include <stdlib.h>
#include <stdint.h>
#include "math.h"

#include "grammar_tokens.h"
#include "debug_functions.h"
#include "config.h"

typedef struct context_token {
	gr_token current;
	struct context_token *prev_in_stack;
} context_token;

void push_context(context_token **stack, gr_token t);
gr_token pop_context(context_token **stack);
uint8_t top_context(context_token *stack);

#endif
