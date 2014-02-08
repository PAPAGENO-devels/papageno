#ifndef __FLEX_TOKEN_FORMATTING_H_
#define __FLEX_TOKEN_FORMATTING_H_

#include <ctype.h>
#include <limits.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "debug_functions.h"

#define __MAX_BUFFER_SIZE 256


typedef struct bracketed_string_node{
	char * pending_bracketed_string;
	int32_t length;
	struct bracketed_string_node * next;
}bracketed_string_node;

int8_t hex2dec(char c);
char * append_to_buffer(char* buffer, char c, int32_t current_buffer_length, int32_t* allocated_buffer_size);

#endif
