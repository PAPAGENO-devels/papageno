#ifndef INTERRUPTED_STRING_H_
#define INTERRUPTED_STRING_H_

#include "stdint.h"
#include "pthread.h"
#include "token_node.h"
#include "debug_functions.h"
#include "flex_return_codes_bracketed_strings.h"
#include "flex_token.h"

#include "flex.yy.h"

typedef struct interrupted_bracketed_string {
	token_node *token_string; 		/*Token of the bracketed string*/
	int32_t chunk_token_string;  	/*Chunk where the open brackets of the string occurred*/
	int32_t chunk_closed_brackets;  /*Chunk where the closed brackets of the string occurred*/
	struct interrupted_bracketed_string *next;
} interrupted_bracketed_string;

typedef struct string_thread_arg {
	uint8_t id;
	int32_t cut_point_sx;
	int32_t cut_point_dx;
	char * file_name;
	char * chunk_string;
	int32_t string_length; 
} string_thread_arg;


void append_interrupted_bracketed_string(token_node* token_string, int32_t chunk_token_string, int32_t chunk_closed_brackets, interrupted_bracketed_string **interrupted_string_builder, interrupted_bracketed_string** interrupted_string_list);
void *string_thread_task(void *arg);
#endif
