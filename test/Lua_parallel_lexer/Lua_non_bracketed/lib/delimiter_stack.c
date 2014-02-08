#include <math.h>
#include "delimiter_stack.h"

#define __DEPTH 3			//Rough guess: another possibility to compute the line length could be to consider the average of the lengths of the lines scanned
				//in each chunk while computing the cut points.

void init_delimiter_stack(delimiter_stack * stack, uint32_t alloc_size)
{
        void *new_delimiter = NULL;
        posix_memalign( &new_delimiter,__CACHE_LINE_SIZE,sizeof(delimiter)*alloc_size);
	stack->stack = (delimiter*)new_delimiter;
	stack->ceil = alloc_size;
        stack->tos = 0;
}

delimiter *push_delimiter_on_stack(delimiter_stack * stack,
				   delimiter_type type, int8_t type_class,
				   uint32_t
				   number_tokens_from_last_comment,
				   token_node * last_token,
				   uint32_t realloc_size)
{
    delimiter *new_delimiter = NULL;
    if (stack->tos >= stack->ceil) {
	        posix_memalign( (void**)&new_delimiter,__CACHE_LINE_SIZE,sizeof(delimiter)*realloc_size);
		stack->stack =  new_delimiter;
	stack->ceil = realloc_size;
	stack->tos = 0;
    }
    new_delimiter = &stack->stack[stack->tos];
    if (type_class == 0)
	(new_delimiter->type).token = type.token;
    else
	(new_delimiter->type).comment = type.comment;
    new_delimiter->type_class = type_class;
    new_delimiter->number_tokens_from_last_comment =
	number_tokens_from_last_comment;
    new_delimiter->last_token = last_token;
    new_delimiter->next = NULL;
    ++stack->tos;
    return new_delimiter;
}

/*Compute allocation and reallocation size to handle a list of delimiters by a stack.*/
void par_delimiter_compute_alloc_realloc_size(uint32_t chunk_length,
					      uint32_t * alloc_size,
					      uint32_t * realloc_size)
{
    uint32_t l_length = __RHS_LENGTH * pow(__RHS_LENGTH / 2, __DEPTH - 1) * __TOKEN_SIZE;	//try very very roughly to estimate the length of a line
    *alloc_size = ((float) chunk_length) / l_length;	//very very rough estimate of the number of lines
    *realloc_size = *alloc_size / 10+1;
}

/*Append a delimiter to the tail of the list*/
void par_append_delimiter(delimiter_type type, int8_t type_class,
			  uint32_t number_tokens_from_last_comment,
			  token_node * last_token,
			  delimiter ** delimiter_builder,
			  delimiter ** delimiter_list,
			  delimiter_stack * stack, uint32_t realloc_size)
{
    delimiter *d =
	push_delimiter_on_stack(stack, type, type_class,
				number_tokens_from_last_comment,
				last_token, realloc_size);
    if (*delimiter_list == NULL) {
	*delimiter_list = d;
	*delimiter_builder = d;
    } else {
	(*delimiter_builder)->next = d;
	*delimiter_builder = d;
    }
}

/*Insert a delimiter at a given position in the list.*/
void par_insert_delimiter(delimiter_type type, int8_t type_class,
			  uint32_t number_tokens_from_last_comment,
			  token_node * last_token,
			  delimiter ** delimiter_builder,
			  delimiter * position_in_list,
			  delimiter ** delimiter_list,
			  delimiter_stack * stack, uint32_t realloc_size)
{
    delimiter *prev_delimiter;

    delimiter *d =
	push_delimiter_on_stack(stack, type, type_class,
				number_tokens_from_last_comment,
				last_token, realloc_size);
    if (*delimiter_list == NULL) {
	*delimiter_list = d;
	*delimiter_builder = d;
    } else if (position_in_list == NULL) {	//Insert at the head of the list
	d->next = *delimiter_list;
	*delimiter_list = d;
    } else {
	prev_delimiter = position_in_list->next;
	position_in_list->next = d;
	d->next = prev_delimiter;
    }
}
