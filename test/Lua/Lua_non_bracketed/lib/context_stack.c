#include "context_stack.h"

/*Pushes the token on top of the stack.*/
void push_context(context_token **stack, gr_token t)
{
	context_token * prev_context = *stack;
	*stack = (context_token*) malloc(sizeof(context_token));
	if (*stack == NULL) {
	    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc context stack. Aborting.\n");
	    exit(1);
	}
	(*stack)->prev_in_stack = prev_context;
	(*stack)->current = t;
} 

/*Pops the token from the top of the stack. Assume that the stack is NOT empty.*/
gr_token pop_context(context_token **stack)
{
	gr_token top = (*stack)->current;
	*stack = (*stack)->prev_in_stack;
	return top;
}

/*Returns 0 if the stack is empty or the top of the stack denotes a function context, 1 if it denotes a context within a table.*/
uint8_t top_context(context_token *stack)
{
	if (stack == NULL)
		return 0;

	gr_token top = stack->current;
	//Check whether there is a token LBRACE or one among DO, IF, FUNCTION
	if (top == LBRACE)
		return 1;
	//Otherwise the token is DO, IF or FUNCTION.
	return 0;

}