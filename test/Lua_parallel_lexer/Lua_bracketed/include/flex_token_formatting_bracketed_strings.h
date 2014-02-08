#ifndef __FLEX_TOKEN_FORMATTING_BRACKETED_STRINGS_H_
#define __FLEX_TOKEN_FORMATTING_BRACKETED_STRINGS_H_

#include <ctype.h>
#include <limits.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "debug_functions.h"

#define __MAX_BUFFER_SIZE 256


typedef struct bracketed_string_node{
	char ** pending_bracketed_string_ptr;
	int32_t length;
	int32_t allocated_size;
	struct bracketed_string_node * next;
}bracketed_string_node;

int8_t hex2dec(char c);
char * append_to_buffer(char* buffer, char c, int32_t *current_buffer_length, int32_t* allocated_buffer_size);
char * concat_to_buffer(char* buffer, char* string_to_concat, int32_t string_to_concat_length, int32_t *current_buffer_length, int32_t* allocated_buffer_size);
void append_pending_bracketed_string(bracketed_string_node **head_list, bracketed_string_node ** top, char** string_ptr, int32_t string_length);
void append_to_all_pending_bracketed_string(bracketed_string_node * head_list, char c);
void concat_to_all_pending_bracketed_string(bracketed_string_node * head_list, char* string_to_concat, int32_t string_to_concat_length);
void terminate_all_pending_string(bracketed_string_node * head_list);

#endif
