%option noyywrap
%option noinput
%option nounput
%option reentrant
%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "grammar_tokens.h"
#include "flex_return_codes.h"
#include "flex_token.h"

%}
%option extra-type="struct lex_token *"
LBRACE		[\{]
RBRACE		[\}]
LSQUARE		[\[]
RSQUARE		[\]]
COMMA		[,]
COLON		[:]
BOOL		true|false|null
CHAR		[\x20-\x21\x23-\x5b\x5d-\xff]
QUOTES		[\"]
RSOLIDUS	[\\]
SPECIAL		([\"\\\/bfnrt]|(u[0-9A-Fa-f]{4}))
POINT		[\.]
EXP			[eE]
MINUS		[-]
EXPSIGN		[-+]
DIGIT		[0-9]
SPACE		" "|\a|\b|\f|\t|\v
NEWLINE		\n
DECIMALINTEGERLITERAL	(-?(0|([1-9][0-9]*)))
JSONFRACTION	(\.[0-9]+)
EXPONENTPART	([eE][+-]?[0-9]+)
NUMBER		(-?(0|([1-9][0-9]*))(\.[0-9]+)?([eE][+-]?[0-9]+)?)

%x string
%x escape
%x string1

%%


%{
struct lex_token * flex_token = yyextra;
%}

<INITIAL>{LBRACE}		{flex_token->token[0] = LBRACE;
				 flex_token->token[1] = CHAR;
				 /* Semantic value stub. */
				 //char* ch = (char*) malloc(sizeof(char)*2);
        		 //strcpy(ch, "{");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;				
				 return LEX_CORRECT_BOTH;
                                }
<INITIAL>{RBRACE}		{flex_token->token[0] = RBRACE;
				 flex_token->token[1] = CHAR;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 //strcpy(ch, "}");
				 //flex_token->semantic_value = ch;	
				 flex_token->semantic_value = NULL;	
				 return LEX_CORRECT_BOTH;
                                }
<INITIAL>{LSQUARE}		{flex_token->token[0] = LSQUARE;
				 flex_token->token[1] = CHAR;
				 /* Semantic value stub. */
				 //char* ch = (char *) malloc(sizeof(char)*2);
        		 //strcpy(ch, "[");	
				 flex_token->semantic_value = NULL; 
				 return LEX_CORRECT_BOTH;
                                }
<INITIAL>{RSQUARE}		{flex_token->token[0] = RSQUARE;
				 flex_token->token[1] = CHAR;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, "]");	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT_BOTH;
                                }
<INITIAL>{COMMA}		{flex_token->token[0] = COMMA;
				 flex_token->token[1] = CHAR;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, ",");	
				 flex_token->semantic_value = NULL;
				return LEX_CORRECT_BOTH;
                                }
<INITIAL>{COLON}		{flex_token->token[0] = COLON;
				 flex_token->token[1] = CHAR;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, ":");	
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT_BOTH;
                                }
<INITIAL>{BOOL}			{flex_token->token[0] = BOOL;
				 flex_token->token[1] = CHAR;
				 flex_token->token_lex_list_length = strlen(yytext);
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
				 // strcpy(ch, yytext);
				 // flex_token->semantic_value = ch;
				 flex_token->semantic_value = NULL;
				return LEX_FIRST_CHAR_SEC;
                                }
<INITIAL>{QUOTES}		{flex_token->token[0] = QUOTES;
				 flex_token->token[1] = QUOTES;
				 (flex_token->quotes_number)++;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, "\"");
				 flex_token->semantic_value = NULL;
				 if(flex_token->begin_with_string == 0)
					BEGIN(string1);
				 else	
				 	BEGIN(string);
				 return LEX_CORRECT_BOTH;
                                }
<INITIAL>{NUMBER}		{flex_token->token[0] = NUMBER;
				 flex_token->token[1] = CHAR;
				 flex_token->token_lex_list_length = strlen(yytext);
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
				 // strcpy(ch, yytext);
				 // flex_token->semantic_value = ch;
				 flex_token->semantic_value = NULL;
				 return LEX_FIRST_CHAR_SEC;
                                }	
<INITIAL>{SPACE}			{flex_token->token[1] = CHAR;
				/* Semantic value stub. */
				//char* ch = (char *) malloc(sizeof(char)*2);
        		//strcpy(ch, " ");
				//flex_token->semantic_value = ch;
				flex_token->semantic_value = NULL;
				return PAUSE_FIRST_LEX_SEC;
				}
<INITIAL>{NEWLINE}			{flex_token->token[1] = CHAR;
				/* Semantic value stub. */
				//char* ch = (char *) malloc(sizeof(char)*2);
        		//strcpy(ch, "\n");
				//flex_token->semantic_value = ch;
				flex_token->semantic_value = NULL;
				return PAUSE_FIRST_LEX_SEC;
				}	
<INITIAL>{RSOLIDUS}		{//?save = INITIAL;
				  flex_token->state_before_rsolidus = INITIAL;
				  BEGIN(escape);
				  return PAUSE_BOTH;}										
<INITIAL>{CHAR}			{flex_token->token[1] = CHAR;
				/* Semantic value stub. */
				// char* ch = (char*) malloc(sizeof(char)*2);
				// strcpy(ch, yytext);
				flex_token->semantic_value = NULL;
				return FIRST_LIST_LEXING_ERROR;}
<INITIAL>.			{return ERROR_BOTH;}
<escape>{SPECIAL}		{int32_t i;
					if(flex_token->state_before_rsolidus == INITIAL){
					flex_token->token[1] = CHAR;
					i = -1;
					BEGIN(INITIAL);
				}
				else if(flex_token->state_before_rsolidus == string)
				{
					flex_token->token[0] = CHAR;
					i = -2;
					BEGIN(string);
				}
				else if(flex_token->state_before_rsolidus == string1)
				{
					flex_token->token[0] = CHAR;
					i = -2;
					BEGIN(string1);
				}
				else{
					i = -3;
				}
				/* Semantic value stub. */
				// char* ch = (char*) malloc(sizeof(char)*(2+strlen(yytext)));
				// ch[0] = '\\';
				// ch[1] = '\0';
				// strcat(ch, yytext);
				// flex_token->semantic_value = ch;
				flex_token->semantic_value = NULL;
				return i;}
<escape>.			{return ERROR_BOTH;}				
<string>{RSOLIDUS}		{flex_token->state_before_rsolidus = string;
				BEGIN(escape);
				return PAUSE_BOTH;
                                }
<string>{QUOTES}		{flex_token->token[0] = QUOTES;
				 flex_token->token[1] = QUOTES;
				 (flex_token->quotes_number)++;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, "\"");
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT_BOTH;
                                }				
<string>{LBRACE}		{flex_token->token[0] = CHAR;
				 flex_token->token[1] = LBRACE;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, "{");
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT_BOTH;
                                }
<string>{RBRACE}		{flex_token->token[0] = CHAR;
				 flex_token->token[1] = RBRACE;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, "}");
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT_BOTH;
                                }
<string>{LSQUARE}		{flex_token->token[0] = CHAR;
				flex_token->token[1] = LSQUARE;
				/* Semantic value stub. */
				// char* ch = (char*) malloc(sizeof(char)*2);
				// strcpy(ch, "[");
				flex_token->semantic_value = NULL;
				return LEX_CORRECT_BOTH;
                                }
<string>{RSQUARE}		{flex_token->token[0] = CHAR;
				flex_token->token[1] = RSQUARE;
				/* Semantic value stub. */
				// char* ch = (char*) malloc(sizeof(char)*2);
				// strcpy(ch, "]");
				flex_token->semantic_value = NULL;
				return LEX_CORRECT_BOTH;
                                }
<string>{COMMA}			{flex_token->token[0] = CHAR;
				flex_token->token[1] = COMMA;
				/* Semantic value stub. */
				// char* ch = (char*) malloc(sizeof(char)*2);
				// strcpy(ch, ",");
				flex_token->semantic_value = NULL;
				return LEX_CORRECT_BOTH;
                                }
<string>{COLON}			{flex_token->token[0] = CHAR;
				 flex_token->token[1] = COLON;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, ":");
				 flex_token->semantic_value = NULL;
				 return LEX_CORRECT_BOTH;
                                }
<string>{BOOL}				{flex_token->token[0] = CHAR;
				flex_token->token[1] = BOOL;
				flex_token->token_lex_list_length = strlen(yytext);
				/* Semantic value stub. */
				// char* ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
				// strcpy(ch, yytext);
				// flex_token->semantic_value = ch;
				flex_token->semantic_value = NULL;
				return CHAR_FIRST_LEX_SEC;
                                }
<string>{NUMBER}		{flex_token->token[0] = CHAR;
				 flex_token->token[1] = NUMBER;
				 flex_token->token_lex_list_length = strlen(yytext);
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
				 // strcpy(ch, yytext);
				 // flex_token->semantic_value = ch;
				 flex_token->semantic_value = NULL;
				 return CHAR_FIRST_LEX_SEC;
                                }	
<string>{SPACE}				{flex_token->token[0] = CHAR;
				/* Semantic value stub. */
				//char* ch = (char *) malloc(sizeof(char)*2);
        		//strcpy(ch, " ");
				//flex_token->semantic_value = ch;
				flex_token->semantic_value = NULL;
				return LEX_FIRST_PAUSE_SEC;}
<string>{NEWLINE}			{flex_token->token[0] = CHAR;
				/* Semantic value stub. */
				//char* ch = (char *) malloc(sizeof(char)*2);
        		//strcpy(ch, "\n");
				//flex_token->semantic_value = ch;
				flex_token->semantic_value = NULL;
				return LEX_FIRST_PAUSE_SEC;
                                }		
<string>{CHAR}			{flex_token->token[0] = CHAR;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, yytext);
				 flex_token->semantic_value = NULL;
				 return SECOND_LIST_LEXING_ERROR;
                                }	
<string>.				{return ERROR_BOTH;}				
<string1>{CHAR}			{flex_token->token[0] = CHAR;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, yytext);
				 flex_token->semantic_value = NULL;
				return SECOND_LIST_LEXING_ERROR;
                                }
<string1>{RSOLIDUS}		{flex_token->state_before_rsolidus = string1;
				 BEGIN(escape);
				 return PAUSE_BOTH;
                                }
<string1>{QUOTES}		{flex_token->token[0] = QUOTES;
				 (flex_token->quotes_number)++;
				 /* Semantic value stub. */
				 // char* ch = (char*) malloc(sizeof(char)*2);
				 // strcpy(ch, "\"");
				 flex_token->semantic_value = NULL;
				 BEGIN(INITIAL);
				 return LEX_CORRECT_BOTH;
                                }	
<string1>.			{ return ERROR_BOTH; }								
%%
