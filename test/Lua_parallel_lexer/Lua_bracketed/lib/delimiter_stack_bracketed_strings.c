#include "delimiter_stack_bracketed_strings.h"

#define DEPTH 3 //Rough guess: another possibility to compute the line length could be to consider the average of the lengths of the lines scanned 
				//in each chunk while computing the cut points.

void init_delimiter_stack(delimiter_stack *stack, uint32_t alloc_size)
{  
        void *new_delimiter = NULL;
        posix_memalign( &new_delimiter,CACHE_LINE_SIZE,sizeof(delimiter)*alloc_size);
	stack->stack = (delimiter *)new_delimiter;
	if (stack->stack == NULL) {
	    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc stack->stack. Aborting.\n");
	    exit(1);
	}
	stack->ceil = alloc_size;
	stack->tos = 0;
}

delimiter *push_delimiter_on_stack(delimiter_stack *stack, delimiter_type type, int8_t type_class, uint8_t token_list_number, token_node* last_token, uint32_t realloc_size)
{
    delimiter *new_delimiter = NULL;
	if (stack->tos >= stack->ceil) {
	        posix_memalign( (void **)&new_delimiter,CACHE_LINE_SIZE,sizeof(delimiter)*realloc_size);
		stack->stack =  (delimiter*) new_delimiter;
		if (stack->stack == NULL) {
		    DEBUG_STDOUT_PRINT("ERROR> could not complete malloc stack->stack. Aborting.\n");
		    exit(1);
		}
		stack->ceil = realloc_size;
		stack->tos = 0;
	}   
    new_delimiter = &stack->stack[stack->tos];
	if(type_class == 0)
    	(new_delimiter->type).token = type.token;
    else if(type_class == 1)
    	(new_delimiter->type).comment = type.comment;
    else
    	(new_delimiter->type).bracket_delimiter = type.bracket_delimiter;
    new_delimiter->type_class = type_class;
	new_delimiter->number_tokens_from_last_comment_string[0] = 0;
	new_delimiter->number_tokens_from_last_comment_string[1] = 0;
	new_delimiter->last_token[token_list_number] = last_token;	
	new_delimiter->next[token_list_number] = NULL;	//Delimiters use next[0] or next[1] depending on their branch of the delimiter list.
	++stack->tos;
	return new_delimiter;
}

/*Compute allocation and reallocation size to handle a list of delimiters by a stack.*/
void par_delimiter_compute_alloc_realloc_size(uint32_t chunk_length, uint32_t *alloc_size, uint32_t *realloc_size)
{
  uint32_t l_length = RHS_LENGTH * pow(RHS_LENGTH/2, DEPTH-1) * TOKEN_SIZE; //try very very roughly to estimate the length of a line
  *alloc_size = ((float) chunk_length) / l_length; //very very rough estimate of the number of lines
  *realloc_size = *alloc_size/10+1;
  
}

/*Append a delimiter to the tail of the list*/
void par_append_delimiter(delimiter_type type, int8_t type_class, uint8_t token_list_number, token_node* last_token, delimiter **delimiter_builder, delimiter** delimiter_list, delimiter_stack *stack, uint32_t realloc_size)
{
  delimiter *d = push_delimiter_on_stack(stack, type, type_class, token_list_number, last_token, realloc_size);
  DEBUG_STDOUT_PRINT("LEXING> par_insert_delimiter: Inserted delimiter.\n");
  if (*delimiter_list == NULL) {
  	DEBUG_STDOUT_PRINT("LEXING> par_insert_delimiter: delimiter_list is NULL. Inserted delimiter.\n");
    *delimiter_list = d;
    if (*delimiter_builder != NULL){
    	/*delimiter_list is NULL and delimiter_builder is not NULL at the end of the first double list of delimiters, when CLOSED_BRACKETS_IN_STRING_OR_COMMENT is read*/
    	(*delimiter_builder)->next[token_list_number] = d;
    }
    *delimiter_builder = d;
  } else {
  	DEBUG_STDOUT_PRINT("LEXING> par_insert_delimiter: delimiter_list is not NULL. Inserted delimiter as delimiter_builder's next.\n");
    (*delimiter_builder)->next[token_list_number] = d;
    *delimiter_builder = d;
  }
}

/*Insert a delimiter at a given position in the list.
Since FUNCTION is the only delimiter inserted in a delimiter list, number_tokens_from_last_comment_string is always 0 and is not set again.*/
void par_insert_delimiter(delimiter_type type, int8_t type_class, uint8_t token_list_number, token_node* last_token, delimiter **delimiter_builder, delimiter *position_in_list, delimiter** delimiter_list, delimiter_stack *stack, uint32_t realloc_size)
{
	delimiter * prev_delimiter;

	delimiter *d = push_delimiter_on_stack(stack, type, type_class, token_list_number, last_token, realloc_size);
	if (*delimiter_list == NULL) {
      *delimiter_list = d;
      *delimiter_builder = d;
    } else if (position_in_list == NULL)
	{//Insert at the head of the list
		d->next[token_list_number] = *delimiter_list;
		*delimiter_list = d;
	} else {
		prev_delimiter = position_in_list->next[token_list_number];
		position_in_list->next[token_list_number] = d;
		d->next[token_list_number] = prev_delimiter;
	}
}
