#include "context_stack_bracketed_strings.h"

/*Pushes the delimiter on top of the stack.*/
void push_context(context_delimiter **stack, delimiter * d)
{
	context_delimiter * prev_context = *stack;
	*stack = (context_delimiter*) malloc(sizeof(context_delimiter));
	if (*stack == NULL) {
	    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc context stack. Aborting.\n");
	    exit(1);
	}
	(*stack)->prev_in_stack = prev_context;
	(*stack)->current = d;
} 

/*Pops the delimiter from the top of the stack. Returns NULL if the stack is empty.*/
delimiter *pop_context(context_delimiter **stack)
{
	if (*stack == NULL)
		return NULL;
	delimiter * top = (*stack)->current;
	*stack = (*stack)->prev_in_stack;
	return top;
}

/*Returns 0 if the stack is empty or the top of the stack denotes a function context, 1 if it denotes a context within a table.*/
uint8_t top_context(context_delimiter *stack)
{
	if (stack == NULL)
		return 0;

	delimiter * top = stack->current;
	//Check whether there is a delimiter LBRACE or one among DO, IF, FUNCTION, __CHECKED_FUCTION
	if (top->type_class == 0 && top->type.token == LBRACE)
		return 1;
	//Otherwise type_class is 2 for delimiter __CHECKED_FUNCTION or type_class is 0 but the type is DO, IF or FUNCTION.
	return 0;

}