%option noyywrap
%option noinput
%option reentrant
%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "./../include/grammar_tokens.h"
#include "./../include/flex_return_codes.h"
#include "./../include/flex_token_formatting.h"

#define YY_USER_ACTION flex_token->num_chars += yyleng;

struct lex_token {
	gr_token token;
	void* semantic_value;
	int32_t comment_type;
	int8_t state_before_comment;
	int32_t chunk_length;
	int32_t num_chars;
	int8_t read_new_line;
	int32_t allocated_buffer_size;
	char* string_buffer;
	int32_t current_buffer_length;
};

  

/*TODO: 
-ottimizzazione da aggiungere: 
Crea una tabella hash che memorizza le classi di simboli di commenti chiusi (identificati dal numero di '=') gia' incontrati dall'inizio del chunk.
Tiene traccia di una stack dei simboli di commento multilinea aperti pendenti nel chunk gia' scandito e, se incontra un simbolo di commento chiuso con un numero di '=' 
per cui non ci sono commenti aperti pendenti e il cui numero di = era gia' nella tabella hash dei simboli di commento chiusi incontrati dall'inizio del chunk,
allora interrompe la scansione andando nello stato commentOrError. (hashtable per confrontare il numero di = del simbolo di commento pendente con quelli gia' letti).
Il vantaggio di usare l'ottimizzazione e' che, alla lettura del commento chiuso che soddisfa queste condizioni, si puo' evitare di andare nello stato INITIAL e invece
andare direttamente in commentOrError.
*/
/*Return codes: 
				END_CHUNK_ERROR = -1 : the end of the chunk has been reached. If the chunk is not followed by the proper end of comment symbol, then it has an error
				END_OF_FILE = 0 : EOF
				LEX_CORRECT = 1 : correct lexing
				INSERT_DELIMITER = 2 : insert delimiter in the list
				ADD_SEMI = 3 : insert into the token list both SEMI and the returned token
				INSERT_COMMENT = 4 : insert a comment symbol in the list of delimiters. The type of comment is denoted by the value of comment_type:
									 Singleline comment -- has value 0 (but here it is never returned)
									 Starting multiline comment with n symbols '=' has value n+1
									 Ending multiline comment with n symbols '=' has value -n-1
				INSERT_SINGLEMULTICOMMENT = 5 : insert both a singleline and a multiline comment (with number of '=' symbols denoted by the value of comment_type as stated above)
				END_CHUNK = 6 : the end of the chunk has been reached
				END_CHUNK_INSERT_COMMENT = 7 : the end of the chunk has been reached. Insert a comment symbol in the list of delimiters
				END_CHUNK_INSERT_SINGLEMULTICOMMENT = 8 : the end of the chunk has been reached. Insert both a singleline and a multiline comment
 */
 /*
ENDSTATTOKEN			(NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|RPAREN|RBRACK|NAME|END|BREAK)
BEGINSTATTOKEN 			(LPAREN|NAME|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|FUNCTION|LOCAL)
ENDSTATTOKEN1			(NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|END|BREAK)
BEGINSTATTOKEN1 		(LPAREN|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|LOCAL)
BEGINSTATTOKEN2 		(COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|LOCAL)
 */

%}
%option extra-type="struct lex_token *"
AND			"and"
BREAK		"break"
DO 			"do"
ELSE 		"else"
ELSEIF 		"elseif"
END 		"end"
FALSE 		"false"
FOR 		"for"
FUNCTION 	"function"
GOTO 		"goto"
IF 			"if"
IN 			"in"
LOCAL 		"local"
NIL 		"nil"
NOT 		"not"
OR 			"or"
REPEAT 		"repeat"
RETURN 		"return"
THEN 		"then"
TRUE 		"true"
UNTIL 		"until"
WHILE 		"while"
NAME 		[a-zA-Z_][a-zA-Z0-9_]*
SEMI 		(;)
COLON		(:)
COLON2		(::)
DOT			(\.)
DOT3		(\.\.\.)
COMMA		(,)
LBRACK		(\[)
RBRACK		(\])
LBRACE		(\{)
RBRACE		(\})
LPAREN		(\()
RPAREN		(\))
EQ 			(=)
UMINUS		(-)
PLUS 		(\+)
MINUS		(-)
ASTERISK	(\*)
DIVIDE		(\/)
CARET		(\^)
PERCENT		(%)
DOT2 		(\.\.)
LT			(<)
GT			(>)
LTEQ		(<=)
GTEQ		(>=)
EQ2			(==)
NEQ			(~=)
SHARP		(#)
LPARENFUNC	(\()
RPARENFUNC	(\))
SEMIFIELD	(;)
XEQ			(=)
ESCAPE		[\\\"\'abfnrtv]
DECEXPONENT	([eE][+-]?[0-9]+)
BINEXPONENT	([pP][+-]?[0-9]+)
DECNUMBER	(([0-9]*\.[0-9]+|[0-9]+\.|[0-9]+){DECEXPONENT}?)
HEXNUMBER	(0[xX]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.|[0-9a-fA-F]+){BINEXPONENT}?)
NUMBER 		({DECNUMBER}|{HEXNUMBER})
SPACE		" "|\t
NEWLINE		[\n]

%x endStat1
%x endStat2
%x singleComment
%x multiComment
%x doubleString
%x singleString
%x commentOrError
%x function1
%x function2

%%


%{
struct lex_token * flex_token = yyextra;  
%}

<INITIAL>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "and");
				 ////flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 ////char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "do");
				 ////flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 ////char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "else");
				 ////flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "elseif");
				 ////flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;		
				 return LEX_CORRECT;
                                } 
<INITIAL>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "for");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{FUNCTION}		{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*9);
        		 //strcpy(ch, "function");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(function1);
				 return LEX_CORRECT;
                                }
<INITIAL>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "goto");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "if");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "in");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "local");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "not");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "or");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "repeat");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "return");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "then");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "until");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                                                                                                                                                                                                                                                                                 
<INITIAL>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "while");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }
<INITIAL>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "nil");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "false");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);						
				 return LEX_CORRECT;
                                }
<INITIAL>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "true");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);					
				 return LEX_CORRECT;
                                }
<INITIAL>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);
				 return INSERT_DELIMITER;
                                }
<INITIAL>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "end");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "break");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);		
				 return LEX_CORRECT;
                                }
<INITIAL>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat2);		
				 return LEX_CORRECT;
                                }
<INITIAL>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "]");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }
<INITIAL>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }    
<INITIAL>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ";");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return INSERT_DELIMITER;
                                }                                   
<INITIAL>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ":");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "::");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ".");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ",");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "[");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "{");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return INSERT_DELIMITER;
                                }                                   
<INITIAL>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "(");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<INITIAL>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return INSERT_DELIMITER;
                                }                                  
<INITIAL>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "+");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{UMINUS}		{flex_token->token = UMINUS;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "-");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "*");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "/");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "^");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "%");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }  
<INITIAL>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "..");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "<");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ">");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "<=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, ">=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "==");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "~=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                   
<INITIAL>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "#");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }
<INITIAL>\]=*\]{SPACE}*\n	{int32_t i = 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }
<INITIAL>\]=+\]			{flex_token->semantic_value = NULL;
				 BEGIN(commentOrError);						 
						}
<INITIAL>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = INITIAL;
				 BEGIN(multiComment);							 
				 return INSERT_COMMENT;
                                }
<INITIAL>--		{flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = INITIAL;
				 BEGIN(singleComment);
                                }
<INITIAL>\"		{flex_token->semantic_value = NULL;
				 flex_token->current_buffer_length = 0;
				 BEGIN(doubleString);
                                }
<INITIAL>\'		{flex_token->semantic_value = NULL;
				 flex_token->current_buffer_length = 0;
				 BEGIN(singleString);
                                }
<INITIAL>{SPACE}+		{}
<INITIAL>{NEWLINE}+		{flex_token->semantic_value = NULL;
				if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK;
						}
<INITIAL>.				{
						 flex_token->semantic_value = NULL;
						 BEGIN(commentOrError);						 
						 if(flex_token->num_chars >= flex_token->chunk_length)
							return END_CHUNK_ERROR;
						}              						
<endStat1>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "(");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "::");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "break");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 if(flex_token->read_new_line == 1)	{	
				 	flex_token->read_new_line = 0;	
					return ADD_SEMI;
				 }
				 else {
				 	flex_token->read_new_line = 0;
					return LEX_CORRECT;
				 }
                                }
<endStat1>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "goto");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "do");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				//char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "while");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "repeat");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "if");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "for");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "local");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{FUNCTION}	{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*9);
        		 //strcpy(ch, "function");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(function1);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat1>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "and");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "else");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "elseif");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;	
				 BEGIN(INITIAL);	
				 return LEX_CORRECT;
                                } 
<endStat1>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "in");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "not");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "or");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "return");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "then");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat1>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "until");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }
<endStat1>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "nil");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "false");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "true");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<endStat1>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 return INSERT_DELIMITER;
                                }
<endStat1>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "end");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<endStat1>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "]");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }
<endStat1>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }    
<endStat1>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ";");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<endStat1>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ":");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                                                   
<endStat1>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ".");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ",");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "[");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "{");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<endStat1>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return INSERT_DELIMITER;
                                }                                  
<endStat1>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "+");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                                                   
<endStat1>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "*");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "/");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "^");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "%");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }  
<endStat1>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "..");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "<");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ">");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "<=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, ">=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "==");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "~=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat1>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "#");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                
<endStat1>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 if(flex_token->read_new_line == 1)	{
				 	flex_token->read_new_line = 0;
				 	BEGIN(endStat2);
					return ADD_SEMI;				 	
				 }		
				else {
				 	flex_token->read_new_line = 0;
				 	BEGIN(endStat2);
					return LEX_CORRECT;				 	
				 }	
                                }                                
<endStat1>{MINUS}		{flex_token->token = MINUS;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "-");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }
<endStat1>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }                                
<endStat1>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = endStat1; 
				 BEGIN(multiComment);
				 return INSERT_COMMENT;
                                }
<endStat1>--		{flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = endStat1;
				 BEGIN(singleComment);
                    }                                                                
<endStat1>{SPACE}+		{}
<endStat1>{NEWLINE}+	{flex_token->read_new_line = 1;
						 flex_token->semantic_value = NULL;
						 if(flex_token->num_chars >= flex_token->chunk_length)
							return END_CHUNK;
						}
<endStat1>.				{flex_token->semantic_value = NULL;
						 unput(yytext[yyleng - 1]);
						 (flex_token->num_chars)--;
						 BEGIN(INITIAL);}
<endStat2>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "::");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "break");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 if(flex_token->read_new_line == 1){	
				 	flex_token->read_new_line = 0;
				 	BEGIN(endStat1);		
					return ADD_SEMI;
				 }
				else {
					flex_token->read_new_line = 0;
					BEGIN(endStat1);
					return LEX_CORRECT;
				 }
                                }
<endStat2>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "goto");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "do");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				//char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "while");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "repeat");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "if");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "for");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "local");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{FUNCTION}		{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*9);
        		 //strcpy(ch, "function");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(function1);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<endStat2>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "and");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "else");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "elseif");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "in");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "not");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "or");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*7);
        		 //strcpy(ch, "return");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "then");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "until");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }
<endStat2>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "nil");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "false");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);						
				 return LEX_CORRECT;
                                }
<endStat2>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "true");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);					
				 return LEX_CORRECT;
                                }
<endStat2>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);
				 return INSERT_DELIMITER;
                                }
<endStat2>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "end");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "]");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<endStat2>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }    
<endStat2>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ";");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<endStat2>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ":");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                                                    
<endStat2>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ".");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ",");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "[");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "{");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<endStat2>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "(");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                } 
<endStat2>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return INSERT_DELIMITER;
                                }                                  
<endStat2>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "+");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                                                     
<endStat2>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "*");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "/");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "^");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "%");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }  
<endStat2>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "..");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "<");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ">");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "<=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, ">=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "==");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "~=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                   
<endStat2>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "#");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                
<endStat2>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 if(flex_token->read_new_line == 1)	{
				 	flex_token->read_new_line = 0;		
					return ADD_SEMI;
				 }
				else{
					flex_token->read_new_line = 0;
					return LEX_CORRECT;
				}
                                }                                
<endStat2>{MINUS}		{flex_token->token = MINUS;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "-");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }
<endStat2>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }                                
<endStat2>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = endStat2;
				 BEGIN(multiComment);
				 return INSERT_COMMENT;
                                }
<endStat2>--		{flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = endStat2;
				 BEGIN(singleComment);
                                }                                                                
<endStat2>{SPACE}+		{}
<endStat2>{NEWLINE}+	{flex_token->read_new_line = 1;
						 flex_token->semantic_value = NULL;
						 if(flex_token->num_chars >= flex_token->chunk_length)
							return END_CHUNK;
						}
<endStat2>.				{flex_token->semantic_value = NULL;
						 unput(yytext[yyleng - 1]);
						 (flex_token->num_chars)--;
						 BEGIN(INITIAL);}
<singleComment>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 /*Identify previous state*/
				 if(flex_token->state_before_comment == function1 || flex_token->state_before_comment == function2)
				 	flex_token->semantic_value = (char *) "function";
				 else
				 	flex_token->semantic_value = NULL;
				 /*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_SINGLEMULTICOMMENT;
				 return INSERT_SINGLEMULTICOMMENT;
                                }
<singleComment>{NEWLINE}+	{
				if(flex_token->state_before_comment == function1 || flex_token->state_before_comment == function2)
				 	flex_token->semantic_value = (char *) "function";
				 else
				 	flex_token->semantic_value = NULL;
				 if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				 	flex_token->read_new_line = 1;
				 BEGIN(flex_token->state_before_comment);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK;
                                }
<singleComment>.			{}   
<multiComment>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 /*Identify previous state.*/
				 if(flex_token->state_before_comment == function1 || flex_token->state_before_comment == function2)
				 	flex_token->semantic_value = (char *) "function";
				 else
				 	flex_token->semantic_value = NULL;
				 	/*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }
<multiComment>{NEWLINE}+	{
				 if(flex_token->state_before_comment == function1 || flex_token->state_before_comment == function2)
				 	flex_token->semantic_value = (char *) "function";
				 else flex_token->semantic_value = NULL;
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_ERROR;
                                }
<multiComment>.				{}                                
<doubleString>\\x[0-9a-fA-F]{2}		{
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					/*Append (char)result to string buffer*/
					append_to_buffer(flex_token->string_buffer, (char) result, flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
									}
<doubleString>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX)
						 BEGIN(commentOrError);						 
					/*Append (char)result to string buffer*/
					append_to_buffer(flex_token->string_buffer, (char) result, flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<doubleString>\\{NEWLINE}		{
					/*Append character newline to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\n', flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\\\		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\\', flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\\"		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\"', flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\\'		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\'', flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\a		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\a', flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\b		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\b',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\f		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\f',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\n		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\n',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\r		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\r',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\t		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\t',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\\v		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\v',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<doubleString>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }
<doubleString>\"		{flex_token->token = STRING;
				 flex_token->string_buffer[flex_token->current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length + 1));
        		 //strcpy(ch, flex_token->string_buffer);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;				 
				 BEGIN(endStat1);
				 return LEX_CORRECT;
                        }
<doubleString>{NEWLINE}	{
						 flex_token->semantic_value = NULL;
						 BEGIN(commentOrError);						 
						 if(flex_token->num_chars >= flex_token->chunk_length)
							return END_CHUNK_ERROR;
						}                        
<doubleString>.			{
						 /*Append char to string buffer*/
						append_to_buffer(flex_token->string_buffer, yytext[0],flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
						(flex_token->current_buffer_length)++;
						}
<singleString>\\x[0-9a-fA-F]{2}		{
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					/*Append (char)result to string buffer*/
					append_to_buffer(flex_token->string_buffer, (char) result,flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
									}
<singleString>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX)
						BEGIN(commentOrError);
					/*Append (char)result to string buffer*/
					append_to_buffer(flex_token->string_buffer, (char) result,flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<singleString>\\{NEWLINE}		{
					/*Append character newline to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\n',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\\\		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\\',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\\"		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\"',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\\'		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\'',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\a		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\a',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\b		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\b',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\f		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\f',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\n		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\n',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\r		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\r',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\t		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\t',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\\v		{
					/*Append escaped character to string buffer*/
					append_to_buffer(flex_token->string_buffer, '\v',flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
					(flex_token->current_buffer_length)++;
								}
<singleString>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }
<singleString>\'		{flex_token->token = STRING;
				 flex_token->string_buffer[flex_token->current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length + 1));
        		 //strcpy(ch, flex_token->string_buffer);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->read_new_line = 0;				 
				 BEGIN(endStat1);
				 return LEX_CORRECT;
                        }
<singleString>{NEWLINE}	{
						 flex_token->semantic_value = NULL;
						 BEGIN(commentOrError);						 
						 if(flex_token->num_chars >= flex_token->chunk_length)
							return END_CHUNK_ERROR;
						}                        
<singleString>.			{
						 /*Append char to string buffer*/
						append_to_buffer(flex_token->string_buffer, yytext[0],flex_token->current_buffer_length, &(flex_token->allocated_buffer_size));
						(flex_token->current_buffer_length)++;
						}
<commentOrError>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }

<commentOrError>{NEWLINE}	{
						 flex_token->semantic_value = NULL;
						 if(flex_token->num_chars >= flex_token->chunk_length)
							return END_CHUNK_ERROR;
							}                        
<commentOrError><<EOF>>		{
						 flex_token->semantic_value = NULL;
						 return END_CHUNK_ERROR;
							}							
<commentOrError>.			{}
<function1>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                        }
<function1>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ".");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                } 
<function1>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ":");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                                         
<function1>{LPAREN}		{flex_token->token = LPARENFUNC;
				 /*Return LPARENFUNC instead of LPAREN*/
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "(");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(function2);
				 return LEX_CORRECT;
                                }                                                                     
<function1>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = function1;
				 BEGIN(multiComment);							 
				 return INSERT_COMMENT;
                                }
<function1>--	{flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = function1;
				 BEGIN(singleComment);
                                }
<function1>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }                                     
<function1>{SPACE}+		{}
<function1>{NEWLINE}+	{flex_token->semantic_value = (char *) "function";
				if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK;
						}
<function1>.	{flex_token->semantic_value = NULL;
				 BEGIN(commentOrError);
				}                                                                                                                
<function2>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                        }
<function2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }
<function2>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ",");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT;
                                }                                                                                         
<function2>{RPAREN}		{flex_token->token = RPARENFUNC;
				 /*Return RPARENFUNC instead of RPAREN*/
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT;
                                }                                            
<function2>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = function2;
				 BEGIN(multiComment);							 
				 return INSERT_COMMENT;
                                }
<function2>--	{flex_token->semantic_value = NULL;
				 flex_token->state_before_comment = function2;
				 BEGIN(singleComment);
                                }
<function2>\]=*\]{SPACE}*\n	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK_INSERT_COMMENT;
				 return INSERT_COMMENT;
                                }                                 
<function2>{SPACE}+		{}
<function2>{NEWLINE}+	{flex_token->semantic_value = (char *) "function";
				if(flex_token->num_chars >= flex_token->chunk_length)
					return END_CHUNK;
						}
<function2>.	{flex_token->semantic_value = NULL;
				 BEGIN(commentOrError);
				}
%%
