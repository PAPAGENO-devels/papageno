#ifndef __DELIMITER_STACK_BRACKETED_STRINGS_H_
#define __DELIMITER_STACK_BRACKETED_STRINGS_H_

#include <stdlib.h>
#include <stdint.h>
#include "math.h"

#include "delimiter_bracketed_strings.h"
#include "debug_functions.h"
#include "config.h"

typedef struct delimiter_stack {
	delimiter *stack; 	/**< The actual stack. */
	uint32_t tos; 		/**< Current top of the stack. */
	uint32_t ceil; 		/**< Current maximum size of the stack. */
} delimiter_stack;

void init_delimiter_stack(delimiter_stack *stack, uint32_t alloc_size);
delimiter *push_delimiter_on_stack(delimiter_stack *stack, delimiter_type type, int8_t type_class, uint8_t token_list_number, token_node* last_token, uint32_t realloc_size);
void par_delimiter_compute_alloc_realloc_size(uint32_t chunk_length, uint32_t *alloc_size, uint32_t *realloc_size);
void par_append_delimiter(delimiter_type type, int8_t type_class, uint8_t token_list_number, token_node* last_token, delimiter **delimiter_builder, delimiter** delimiter_list, delimiter_stack *stack, uint32_t realloc_size);
void par_insert_delimiter(delimiter_type type, int8_t type_class, uint8_t token_list_number, token_node* last_token, delimiter **delimiter_builder, delimiter *position_in_list, delimiter** delimiter_list, delimiter_stack *stack, uint32_t realloc_size);

#endif
