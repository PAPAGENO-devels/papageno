#ifndef FLEX_TOKEN_FORMATTING_H_
#define FLEX_TOKEN_FORMATTING_H_

#include <ctype.h>
#include <limits.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "debug_functions.h"

#define MAX_BUFFER_SIZE 256


int8_t hex2dec(char c);
char * append_to_buffer(char* buffer, char c, int32_t current_buffer_length, int32_t* allocated_buffer_size);
char * concat_to_buffer(char* buffer, char* string_to_concat, int32_t string_to_concat_length, int32_t *current_buffer_length, int32_t* allocated_buffer_size);

#endif
