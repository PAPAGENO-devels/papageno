%option noyywrap
%option noinput
%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "grammar.h"
#include "flex_token_formatting.h"
#include "parser_tab.h" /*for yyerror routine*/

token_node * node;

int32_t comment_type, matching_comment_type;
int32_t i, result;
int32_t allocated_buffer_size = MAX_BUFFER_SIZE;
int32_t current_buffer_length;
char* ch;
char* string_buffer = (char*) malloc(sizeof(char)*MAX_BUFFER_SIZE); 
if (string_buffer == NULL) {
   yyerror("LEXER> Error: could not complete malloc string_buffer. Aborting.\n");
   exit(1);
}   

/*Scanner for the original grammar of Lua, NOT in operator precedence form, to guarantee a fair comparison of performance between the sequential lexer+parser 
and the parallel ones (the constraints of the operator precedence form would slow down the sequential lexer+parser).
This grammar has the same restrictions as the current grammar used for PAPAGENO: e.g. multiline comments are ended with newline (and the other ones are ignored or
considered errors) and strings between brackets are not allowed.*/

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
ESCAPE		[\\\"\'abfnrtv]
DECEXPONENT	([eE][+-]?[0-9]+)
BINEXPONENT	([pP][+-]?[0-9]+)
DECNUMBER	(([0-9]*\.[0-9]+|[0-9]+\.|[0-9]+){DECEXPONENT}?)
HEXNUMBER	(0[xX]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.|[0-9a-fA-F]+){BINEXPONENT}?)
NUMBER 		({DECNUMBER}|{HEXNUMBER})
SPACE		" "|\a|\b|\f|\t|\v
NEWLINE		\n|\r|\r\n|\n\r


%x singleComment
%x multiComment
%x doubleString
%x singleString

%%


<INITIAL>{AND}		{/* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "and");
        		 node = (token_node*) malloc(sizeof(token_node));
				 node->token = AND;
				 node->value = ch;
				 yylval.node = node;
				 return AND_NODE;
                                } 
<INITIAL>{BREAK}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = BREAK;
				 node->value = ch;
				 yylval.node = node;
				 return BREAK_NODE;
                                }                                
<INITIAL>{DO}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "do");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = DO;
				 node->value = ch;
				 yylval.node = node;
				 return DO_NODE;
                                } 
<INITIAL>{ELSE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "else");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = ELSE;
				 node->value = ch;
				 yylval.node = node;
				 return ELSE_NODE;
                                } 
<INITIAL>{ELSEIF}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "elseif");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = ELSEIF;
				 node->value = ch;
				 yylval.node = node;		
				 return ELSEIF_NODE;
                                }
<INITIAL>{END}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = END;
				 node->value = ch;
				 yylval.node = node;
				 return END_NODE;
                                } 
<INITIAL>{FALSE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = FALSE;
				 node->value = ch;
				 yylval.node = node;
				 return FALSE_NODE;
                                }                                                                
<INITIAL>{FOR}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "for");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = FOR;
				 node->value = ch;
				 yylval.node = node;
				 return FOR_NODE;
                                } 
<INITIAL>{FUNCTION}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*9);
        		 strcpy(ch, "function");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = FUNCTION;
				 node->value = ch;
				 yylval.node = node;
				 return FUNCTION_NODE;
                                }
<INITIAL>{GOTO}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "goto");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = GOTO;
				 node->value = ch;
				 yylval.node = node;
				 return GOTO_NODE;
                                } 
<INITIAL>{IF}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "if");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = IF;
				 node->value = ch;
				 yylval.node = node;
				 return IF_NODE;
                                } 
<INITIAL>{IN}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "in");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = IN;
				 node->value = ch;
				 yylval.node = node;
				 return IN_NODE;
                                } 
<INITIAL>{LOCAL}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "local");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = LOCAL;
				 node->value = ch;
				 yylval.node = node;
				 return LOCAL_NODE;
                                } 
<INITIAL>{NIL}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = NIL;
				 node->value = ch;
				 yylval.node = node;
				 return NIL_NODE;
                                }                                
<INITIAL>{NOT}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "not");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = NOT;
				 node->value = ch;
				 yylval.node = node;
				 return NOT_NODE;
                                } 
<INITIAL>{OR}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "or");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = OR;
				 node->value = ch;
				 yylval.node = node;
				 return OR_NODE;
                                } 
<INITIAL>{REPEAT}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "repeat");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = REPEAT;
				 node->value = ch;
				 yylval.node = node;
				 return REPEAT_NODE;
                                } 
<INITIAL>{RETURN}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "return");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = RETURN;
				 node->value = ch;
				 yylval.node = node;
				 return RETURN_NODE;
                                } 
<INITIAL>{THEN}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "then");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = THEN;
				 node->value = ch;
				 yylval.node = node;
				 return THEN_NODE;
                                } 
<INITIAL>{TRUE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = TRUE;
				 node->value = ch;
				 yylval.node = node;
				 return TRUE_NODE;
                                }                                
<INITIAL>{UNTIL}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "until");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = UNTIL;
				 node->value = ch;
				 yylval.node = node;
				 return UNTIL_NODE;
                                }                                                                                                                                                                                                                                                                                                 
<INITIAL>{WHILE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "while");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = WHILE;
				 node->value = ch;
				 yylval.node = node;
				 return WHILE_NODE;
                                }
<INITIAL>{NUMBER}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = NUMBER;
				 node->value = ch;
				 yylval.node = node;
				 return NUMBER_NODE;
                                }
<INITIAL>{NAME}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = NAME;
				 node->value = ch;
				 yylval.node = node;
				 return NAME_NODE;
                                }  
<INITIAL>{SEMI}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ";");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = SEMI;
				 node->value = ch;
				 yylval.node = node;
				 return SEMI_NODE;
                                }
<INITIAL>{COLON}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = COLON;
				 node->value = ch;
				 yylval.node = node;
				 return COLON_NODE;
                                }                                   
<INITIAL>{COLON2}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "::");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = COLON2;
				 node->value = ch;
				 yylval.node = node;
				 return COLON2_NODE;
                                }
<INITIAL>{DOT}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ".");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = DOT;
				 node->value = ch;
				 yylval.node = node;
				 return DOT_NODE;
                                }                                                                                                                                          
<INITIAL>{DOT3}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = DOT3;
				 node->value = ch;
				 yylval.node = node;
				 return DOT3_NODE;
                                }
<INITIAL>{COMMA}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = COMMA;
				 node->value = ch;
				 yylval.node = node;
				 return COMMA_NODE;
                                } 
<INITIAL>{LBRACK}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "[");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = LBRACK;
				 node->value = ch;
				 yylval.node = node;
				 return LBRACK_NODE;
                                }                                                                  
<INITIAL>{RBRACK}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = RBRACK;
				 node->value = ch;
				 yylval.node = node;
				 return RBRACK_NODE;
                                }
<INITIAL>{LBRACE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "{");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = LBRACE;
				 node->value = ch;
				 yylval.node = node;
				 return LBRACE_NODE;
                                }                                     
<INITIAL>{RBRACE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = RBRACE;
				 node->value = ch;
				 yylval.node = node;
				 return RBRACE_NODE;
                                }
<INITIAL>{LPAREN}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = LPAREN;
				 node->value = ch;
				 yylval.node = node;
				 return LPAREN_NODE;
                                }                                                                 
<INITIAL>{RPAREN}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = RPAREN;
				 node->value = ch;
				 yylval.node = node;
				 return RPAREN_NODE;
                                }                                                                                                                                                                                   
<INITIAL>{EQ}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "=");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = EQ;
				 node->value = ch;
				 yylval.node = node;
				 return EQ_NODE;
                                }                                  
<INITIAL>{PLUS}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "+");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = PLUS;
				 node->value = ch;
				 yylval.node = node;
				 return PLUS_NODE;
                                }                                   
<INITIAL>{MINUS}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "-");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = MINUS;
				 node->value = ch;
				 yylval.node = node;
				 return MINUS_NODE;
                                }                                   
<INITIAL>{ASTERISK}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "*");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = ASTERISK;
				 node->value = ch;
				 yylval.node = node;
				 return ASTERISK_NODE;
                                }                                   
<INITIAL>{DIVIDE}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "/");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = DIVIDE;
				 node->value = ch;
				 yylval.node = node;
				 return DIVIDE_NODE;
                                }                                   
<INITIAL>{CARET}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "^");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = CARET;
				 node->value = ch;
				 yylval.node = node;
				 return CARET_NODE;
                                }                                   
<INITIAL>{PERCENT}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "%");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = PERCENT;
				 node->value = ch;
				 yylval.node = node;
				 return PERCENT_NODE;
                                }  
<INITIAL>{DOT2}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "..");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = DOT2;
				 node->value = ch;
				 yylval.node = node;
				 return DOT2_NODE;
                                }                                   
<INITIAL>{LT}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "<");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = LT;
				 node->value = ch;
				 yylval.node = node;
				 return LT_NODE;
                                }                                   
<INITIAL>{GT}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ">");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = GT;
				 node->value = ch;
				 yylval.node = node;
				 return GT_NODE;
                                }                                   
<INITIAL>{LTEQ}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "<=");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = LTEQ;
				 node->value = ch;
				 yylval.node = node;
				 return LTEQ_NODE;
                                }                                   
<INITIAL>{GTEQ}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, ">=");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = GTEQ;
				 node->value = ch;
				 yylval.node = node;
				 return GTEQ_NODE;
                                }                                   
<INITIAL>{EQ2}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "==");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = EQ2;
				 node->value = ch;
				 yylval.node = node;
				 return EQ2_NODE;
                                }                                   
<INITIAL>{NEQ}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "~=");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = NEQ;
				 node->value = ch;
				 yylval.node = node;
				 return NEQ_NODE;
                                }                                   
<INITIAL>{SHARP}		{
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "#");
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = SHARP;
				 node->value = ch;
				 yylval.node = node;
				 return SHARP_NODE;
                                }
<INITIAL>--		{
				 BEGIN(singleComment);
                                }						
<INITIAL>--\[=*\[		{i= 3;
				 comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(comment_type)++;
				 	i++;
				 }
				 BEGIN(multiComment);							 
                                }
<INITIAL>\"		{
				 current_buffer_length = 0;
				 BEGIN(doubleString);
                                }
<INITIAL>\'		{
				 current_buffer_length = 0;
				 BEGIN(singleString);
                                }
<INITIAL>({SPACE}|{NEWLINE})+		{}
<INITIAL>.				{/*Error*/
						 	yyerror("LEXER> Error: unexpected character.")
							exit(1);
						}              						
<singleComment>.*{NEWLINE}	{}
<multiComment>\]=*\]{SPACE}*{NEWLINE}	{i= 1;
				 matching_comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	matching_comment_type++;
				 	i++;
				 }
				 if (comment_type == matching_comment_type)
				 	BEGIN(INITIAL);
                   		}
<multiComment>{NEWLINE}+	{}
<multiComment>.				{}                                
<doubleString,singleString>\\x[0-9a-fA-F]{2}		{
					/*Compute the decimal value of the hexadecimal number*/
					result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					/*Append (char)result to string buffer*/
					string_buffer = append_to_buffer(string_buffer, (char) result, current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
									}
<doubleString,singleString>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX)
						 {
						 	yyerror("LEXER> Error: unexpected character.")
							exit(1);
						 }					 
					/*Append (char)result to string buffer*/
					string_buffer = append_to_buffer(string_buffer, (char) result, current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<doubleString,singleString>\\{NEWLINE}		{
					/*Append character newline to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\n', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\\\		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\\', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\\"		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\"', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\\'		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\'', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\a		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\a', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\b		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\b', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\f		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\f', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\n		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\n', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\r		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\r', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\t		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\t', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString,singleString>\\v		{
					/*Append escaped character to string buffer*/
					string_buffer = append_to_buffer(string_buffer, '\v', current_buffer_length, &allocated_buffer_size);
					current_buffer_length++;
								}
<doubleString>\"		{
				 string_buffer[current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*(current_buffer_length + 1));
        		 strcpy(ch, string_buffer);
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = STRING;
				 node->value = ch;
				 yylval.node = node;
				 BEGIN(INITIAL);
				 return STRING_NODE;
                        }
<doubleString,singleString>{NEWLINE}	{
						 yyerror("LEXER> Error: unexpected character.")
						 exit(1);
						}  
<doubleString,singleString><<EOF>>		{
					 	 yyerror("LEXER> Error: End of file while reading a string.")
						 exit(1);
			}	
<doubleString>[^\\\"\n\r]+			{
						 /*Append chars to string buffer*/
						 string_buffer = concat_to_buffer(string_buffer, yytext, yyleng, &current_buffer_length, &allocated_buffer_size);				
						} 								                      
<doubleString>.			{ /*Append char to string buffer*/
						string_buffer = append_to_buffer(string_buffer, yytext[0], current_buffer_length, &allocated_buffer_size);
						current_buffer_length++;
						}
<singleString>\'		{
				 string_buffer[current_buffer_length] = '\0';
				 /* Semantic value stub. */
				 ch = (char*) malloc(sizeof(char)*(current_buffer_length + 1));
        		 strcpy(ch, string_buffer);
				 node = (token_node*) malloc(sizeof(token_node));
				 node->token = STRING;
				 node->value = ch;
				 yylval.node = node;
				 BEGIN(INITIAL);
				 return STRING_NODE;
                        } 
<singleString>[^\\\'\n\r]+			{
						 /*Append chars to string buffer*/
						 string_buffer = concat_to_buffer(string_buffer, yytext, yyleng, &current_buffer_length, &allocated_buffer_size);				
						}                                    
<singleString>.			{ /*Append char to string buffer*/
						string_buffer = append_to_buffer(string_buffer, yytext[0], current_buffer_length, &allocated_buffer_size);
						current_buffer_length++;
						}						
%%