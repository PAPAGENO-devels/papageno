#ifndef FLEX_RETURN_CODES_H_
#define FLEX_RETURN_CODES_H_


#define END_CHUNK_ERROR  -1    /*the end of the chunk has been reached. If the chunk is not followed by the proper end of comment symbol, then it has an error*/
#define END_OF_FILE  0 		/* EOF */
#define LEX_CORRECT  1 		/* correct lexing */
#define INSERT_DELIMITER  2 	/* insert delimiter in the list */
#define ADD_SEMI  3 			/* insert into the token list both SEMI and the returned token */
#define INSERT_COMMENT  4 		/* insert a comment symbol in the list of delimiters. The type of comment is denoted by the value of comment_type: 
								Singleline comment -- has value 0 (but here it is never returned)
								Starting multiline comment with n symbols '=' has value n+1
								Ending multiline comment with n symbols '=' has value -n-1 */
#define INSERT_SINGLEMULTICOMMENT  5 	/* insert both a singleline and a multiline comment (with number of '=' symbols denoted by the value of comment_type as stated above) */
#define END_CHUNK  6 					/* the end of the chunk has been reached */
#define END_CHUNK_INSERT_COMMENT  7 	/* the end of the chunk has been reached. Insert a comment symbol in the list of delimiters */
#define END_CHUNK_INSERT_SINGLEMULTICOMMENT  8 	/* the end of the chunk has been reached. Insert both a singleline and a multiline comment */

#endif
