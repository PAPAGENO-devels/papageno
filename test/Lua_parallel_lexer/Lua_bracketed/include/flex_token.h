#ifndef __FLEX_TOKEN_H_
#define __FLEX_TOKEN_H_

#include "grammar_tokens.h"
#include "delimiter_bracketed_strings.h"
#include "flex_token_formatting_bracketed_strings.h"

typedef enum state_tuple {
  __DOUBLE_STRING = 0, __SINGLE_STRING, __BRACKETED_STRING, __SINGLE_COMMENT
} state_tuple;

typedef enum state_comment {
	initial_state = 0, endStat1_state, endStat2_state, function1_state, function2_state
} state_comment;

typedef struct lex_token {
  gr_token token;     /**< The gr_token representation of the token. */
  void* semantic_value[2];	//semantic values of the two possible returned tokens. The value is undefined if no token is returned.
  int32_t comment_type;
  bracket_delimiter_type bracket_delimiter; 
  int8_t state_before_comment;
  state_comment before_comment[2];
  state_tuple state;
  int32_t chunk_length;
  int32_t num_chars;
  int8_t read_new_line;
  int32_t allocated_buffer_size[2];
  char* string_buffer[2];
  int32_t current_buffer_length[2];
  int8_t  first_closing_bracket;
  int32_t first_closing_bracket_pos;
  int8_t lexing_phase;
  int8_t insert_token_in_list; /*0 for token list 0, 1 for token list 1, 2 for none, 3 for both*/
  int8_t insert_single_comment_in_list; /*0 for delimiter list 0, 1 for delimiter list 1, 2 for none, 3 for both*/
  int8_t error[2]; 
  int8_t first_state, second_state, insert_function;
  bracketed_string_node * pending_bracketed_string_list, * top_pending_bracketed_string_list;
  int8_t append_pending_bracketed_string; /*1 if there is an interrupted bracketed string and it has to be appended to the pending bracketed string list; 0 otherwise*/
  int8_t chunk_ended; /*0 if the chunk did not end, 1 if the chunk ended*/
  int8_t double_list_ended; /*0 if the double_list did not end, 1 if the double_list ended*/
  } lex_token;

/*lex_token is used by flex to save the tokens inside lex_token_list.*/

#endif