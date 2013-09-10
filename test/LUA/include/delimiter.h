#ifndef DELIMITER_H_
#define DELIMITER_H_

#include "stdint.h"
#include "token_node.h"

// typedef enum comment_type {
//  	SINGLECOMMENT = 0, LMULTICOMMENT, RMULTICOMMENT
// } comment_type;

typedef union delim_type {
		gr_token token;
		// comment_type comment;
		int32_t comment;	/*The value for each type of comment is:
							Singleline comment -- has value 0
							Starting multiline comment with n symbols '=' has value n+1
							Ending multiline comment with n symbols '=' has value -n-1*/
	} delimiter_type;

typedef struct delimiter {
  //delimiters: LBRACE, RBRACE, EQ, SEMI, FUNCTION, SINGLECOMMENT, LMULTICOMMENT, RMULTICOMMENT	
	delimiter_type type;
	int8_t type_class; /*0 if the union field is a token; 1 if it is a comment*/
	//int32_t equal_number; /*If the delimiter is a comment long bracket, equal_number represents the number of equal characters in the symbol of the delimiter.*/
	uint32_t number_tokens_from_last_comment;
	token_node *last_token; /*Token within the token list which corresponds to the delimiter: 
							if the delimiter is a comment, last_token is the last token in the token list preceding the occurrence of the comment delimiter in the code.*/
	struct delimiter* next; /*Next delimiter in the delimiter list*/
} delimiter;


delimiter *new_delimiter(delimiter_type type, int8_t type_class);
void free_delimiter(delimiter *d);

#endif
