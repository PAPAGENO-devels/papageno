%option noyywrap
%option noinput

%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "grammar_tokens.h"
#include "flex_return_codes.h"
#include "flex_token_formatting.h"
#include "debug_functions.h"

struct lex_token {
	gr_token token;
	void* semantic_value;
	int8_t handle_context;
	char * string_buffer;
};

extern struct lex_token* flex_token;

int32_t comment_type;
int8_t state_before_comment;
int32_t i, result;
int8_t read_new_line = 0;
int32_t allocated_buffer_size = MAX_BUFFER_SIZE;
int32_t current_buffer_length = 0;
char* ch;  

/*Sequential scanner for Lua grammar as OPG.
This grammar has the same restrictions as the current grammar used for PAPAGENO: e.g. multiline comments are ended with newline (and the other ones are ignored or
considered errors) and strings between brackets are not allowed.*/
/*
ENDSTATTOKEN			(NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|RPAREN|RBRACK|NAME|END|BREAK)
BEGINSTATTOKEN 			(LPAREN|NAME|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|FUNCTION|LOCAL)
ENDSTATTOKEN1			(NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|END|BREAK)
BEGINSTATTOKEN1 		(LPAREN|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|LOCAL)
BEGINSTATTOKEN2 		(COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|LOCAL)
 */
%}

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
SPACE		" "|\a|\b|\f|\t|\v
NEWLINE		\n|\r|\r\n|\n\r

%x endStat1
%x endStat2
%x singleComment
%x multiComment
%x doubleString
%x singleString
%x bracketedString
%x function1
%x function2

%%


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
				 flex_token->handle_context = 1;
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
				 flex_token->handle_context = 1;
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
				 read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "false");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 BEGIN(endStat1);						
				 return LEX_CORRECT;
                                }
<INITIAL>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "true");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 BEGIN(endStat1);					
				 return LEX_CORRECT;
                                }
<INITIAL>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<INITIAL>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }
<INITIAL>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "end");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);			
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }
<INITIAL>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "break");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);		
				 return LEX_CORRECT;
                                }
<INITIAL>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat2);		
				 return LEX_CORRECT;
                                }
<INITIAL>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "]");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }
<INITIAL>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }    
<INITIAL>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ";");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
<INITIAL>--		{
				 state_before_comment = INITIAL;
				 BEGIN(singleComment);
                                }						
<INITIAL>--\[=*\[		{i= 3;
				 comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(comment_type)++;
				 	i++;
				 }
				 state_before_comment = INITIAL;
				 BEGIN(multiComment);							 
                                }                                
<INITIAL,endStat1,endStat2>\"		{flex_token->semantic_value = NULL;
				 current_buffer_length = 0;
				 BEGIN(doubleString);
                                }
<INITIAL,endStat1,endStat2>\'		{flex_token->semantic_value = NULL;
				 current_buffer_length = 0;
				 BEGIN(singleString);
                                }
<INITIAL,endStat1,endStat2>\[\[		{flex_token->semantic_value = NULL;
				 current_buffer_length = 0;
				 BEGIN(bracketedString);
                                }     
<INITIAL>{SPACE}+		{}
<INITIAL>{NEWLINE}+		{}           
<INITIAL>.				{/*Error*/
						 flex_token->semantic_value = NULL;
						 return ERROR;
						}              						
<endStat1>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "(");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)	{	
				 	read_new_line = 0;	
					return ADD_SEMI;
				 }
				 else {
				 	read_new_line = 0;
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
				 if(read_new_line == 1)			
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
				 flex_token->handle_context = 1;
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 flex_token->handle_context = 1;
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "false");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "true");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 return LEX_CORRECT;
                                }
<endStat1>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<endStat1>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }
<endStat1>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "end");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }
<endStat1>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "]");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat2);			
				 return LEX_CORRECT;
                                }
<endStat1>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
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
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }                                   
<endStat1>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "=");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 if(read_new_line == 1)	{
				 	read_new_line = 0;
				 	BEGIN(endStat2);
					return ADD_SEMI;				 	
				 }		
				else {
				 	read_new_line = 0;
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
<endStat1>--		{
				 state_before_comment = endStat1;
				 BEGIN(singleComment);
                                }						
<endStat1>--\[=*\[		{i= 3;
				 comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(comment_type)++;
				 	i++;
				 }
				 state_before_comment = endStat1;
				 BEGIN(multiComment);							 
                                }                                                                                                                      
<endStat1>{SPACE}+		{}
<endStat1>{NEWLINE}+	{read_new_line = 1;
						}
<endStat1>.				{/*Error*/
						 flex_token->semantic_value = NULL;
						 return ERROR;
						}
<endStat2>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*3);
        		 //strcpy(ch, "::");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1){	
				 	read_new_line = 0;
				 	BEGIN(endStat1);		
					return ADD_SEMI;
				 }
				else {
					read_new_line = 0;
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
				 if(read_new_line == 1)			
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
				 flex_token->handle_context = 1;
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 flex_token->handle_context = 1;
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 if(read_new_line == 1)			
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
				 read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*6);
        		 //strcpy(ch, "false");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 BEGIN(endStat1);						
				 return LEX_CORRECT;
                                }
<endStat2>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*5);
        		 //strcpy(ch, "true");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 BEGIN(endStat1);					
				 return LEX_CORRECT;
                                }
<endStat2>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 //strcpy(ch, yytext);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "...");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);			
				 return LEX_CORRECT;
                                }
<endStat2>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }
<endStat2>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*4);
        		 //strcpy(ch, "end");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 BEGIN(endStat1);			
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
                                }
<endStat2>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "]");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<endStat2>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ")");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;	
				 return LEX_CORRECT;
                                }    
<endStat2>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, ";");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 flex_token->handle_context = 1;
				 return LEX_CORRECT;
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
				 if(read_new_line == 1)	{
				 	read_new_line = 0;		
					return ADD_SEMI;
				 }
				else{
					read_new_line = 0;
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
<endStat2>--		{
				 state_before_comment = endStat2;
				 BEGIN(singleComment);
                                }						
<endStat2>--\[=*\[		{i= 3;
				 comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(comment_type)++;
				 	i++;
				 }
				 state_before_comment = endStat2;
				 BEGIN(multiComment);							 
                                }                                                                                                                      
<endStat2>{SPACE}+		{}
<endStat2>{NEWLINE}+	{read_new_line = 1;
						}
<endStat2>.				{/*Error*/
						 flex_token->semantic_value = NULL;
						 return ERROR;
						}
<singleComment>.*{NEWLINE}	{
					BEGIN(state_before_comment);
					read_new_line = 1;
				}						 
<multiComment>\]=*\]{SPACE}*{NEWLINE}	{i= 1;
				 while(yytext[i] == '=') {
				 	i++;
				 }
				 if (comment_type == i-1)
				 	BEGIN(state_before_comment);
				 read_new_line = 1;
                }
<multiComment><<EOF>>		{
						 return ERROR;
							}		                
<multiComment>.				{}                                
<doubleString,singleString,bracketedString>\\x[0-9a-fA-F]{2}		{
					/*Compute the decimal value of the hexadecimal number*/
					result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					/*Append (char)result to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, (char) result, current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
									}
<doubleString,singleString,bracketedString>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX)
						 return ERROR;						 
					/*Append (char)result to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, (char) result, current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<doubleString,singleString,bracketedString>\\{NEWLINE}	{
					/*Append character newline to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\n', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\\\		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\\', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\\"		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\"', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\\'		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\'', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\a		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\a', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\b		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\b',current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\f		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\f',current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\n		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\n',current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\r		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\r',current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\t		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\t',current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString,bracketedString>\\v		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, '\v',current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString>\"		{flex_token->token = STRING;
				 flex_token->string_buffer[current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(current_buffer_length + 1));
        		 //strcpy(ch, flex_token->string_buffer);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;				 
				 BEGIN(endStat1);
				 return LEX_CORRECT;
                        }
<doubleString,singleString,bracketedString>{NEWLINE}	{
						 flex_token->semantic_value = NULL;
						 return ERROR;
						} 
<doubleString,singleString,bracketedString><<EOF>>		{
						 flex_token->semantic_value = NULL;
						 return ERROR;
							}	
<doubleString>[^\\\"\n\r]+			{
						 /*Append chars to string buffer*/
						 flex_token->string_buffer = concat_to_buffer(flex_token->string_buffer, yytext, yyleng, &(current_buffer_length), &allocated_buffer_size);
						} 													                       
<doubleString>.			{
						 /*Append char to string buffer*/
						flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, yytext[0],current_buffer_length, &allocated_buffer_size);
						current_buffer_length++;
						}
<singleString>\'		{flex_token->token = STRING;
				 flex_token->string_buffer[current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(current_buffer_length + 1));
        		 //strcpy(ch, flex_token->string_buffer);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;				 
				 BEGIN(endStat1);
				 return LEX_CORRECT;
                        }	
<singleString>[^\\\'\n\r]+			{
						 /*Append chars to string buffer*/
						 flex_token->string_buffer = concat_to_buffer(flex_token->string_buffer, yytext, yyleng, &(current_buffer_length), &allocated_buffer_size);
						}                        							                       
<singleString>.			{
						 /*Append char to string buffer*/
						flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, yytext[0],current_buffer_length, &allocated_buffer_size);
						current_buffer_length++;
						}
<bracketedString>\]\]		{flex_token->token = STRING;
				 flex_token->string_buffer[current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 //char * ch = (char*) malloc(sizeof(char)*(current_buffer_length + 1));
        		 //strcpy(ch, flex_token->string_buffer);
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;
				 read_new_line = 0;				 
				 BEGIN(endStat1);
				 return LEX_CORRECT;
                        }	
<bracketedString>[^\\\]\n\r]+			{
						 /*Append chars to string buffer*/
						 flex_token->string_buffer = concat_to_buffer(flex_token->string_buffer, yytext, yyleng, &(current_buffer_length), &allocated_buffer_size);
						}                        							                       
<bracketedString>.			{
						 /*Append char to string buffer*/
						flex_token->string_buffer = append_to_buffer(flex_token->string_buffer, yytext[0],current_buffer_length, &allocated_buffer_size);
						current_buffer_length++;
						}						
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
<function1>--\[=*\[		{i= 3;
				 comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	comment_type++;
				 	i++;
				 }
				 state_before_comment = function1;
				 BEGIN(multiComment);							 
                                }
<function1>--	{
				 state_before_comment = function1;
				 BEGIN(singleComment);
                                }                                     
<function1>{SPACE}+		{}
<function1>{NEWLINE}+	{}
<function1>.	{
				 return ERROR;
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
<function2>--\[=*\[		{i= 3;
				 comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	comment_type++;
				 	i++;
				 }
				 state_before_comment = function2;
				 BEGIN(multiComment);							 
                                }
<function2>--	{
				 state_before_comment = function2;
				 BEGIN(singleComment);
                                }                                     
<function2>{SPACE}+		{}
<function2>{NEWLINE}+	{}
<function2>.	{
				 return ERROR;
				}
%%
