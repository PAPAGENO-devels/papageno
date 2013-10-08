%option noyywrap
%option noinput
%option nounput
%option reentrant
%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <limits.h>

#include "grammar_tokens.h"
#include "flex_return_codes.h"

#define YY_USER_ACTION flex_token->num_chars += yyleng;

%}
%option extra-type="struct lex_token *"
LPAR    [\(]
RPAR    [\)]
PLUS    [\+]
TIMES   [\*]
DIGIT   [0-9]
SPACE   " "|\t
NEWLINE [\n]

%%

%{
struct lex_token * flex_token = yyextra;
%}

<INITIAL>{LPAR}  {flex_token->token = LPAR;
        char ch = '(';
        flex_token->semantic_value = (void*) &ch;
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return LEX_CORRECT;}
<INITIAL>{RPAR}  {flex_token->token = RPAR;
        char ch = ')';
        flex_token->semantic_value = (void*) &ch;
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return LEX_CORRECT;}
<INITIAL>{TIMES} {flex_token->token = TIMES;
        char ch = '*';
        flex_token->semantic_value = (void*) &ch;
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return LEX_CORRECT;}
<INITIAL>{PLUS}  {flex_token->token = PLUS;
        char ch = '+';
        flex_token->semantic_value = (void*) &ch;
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return LEX_CORRECT;}
<INITIAL>{DIGIT}+ {flex_token->token = NUMBER;
        long32_t num = strtol(yytext, NULL, 10);
		if ((num == LONG_MAX || num == LONG_MIN) && errno == ERANGE) {
		   /* Could not convert. */
		   return ERROR;
		}
		flex_token->semantic_value = (void*) &num;
        return LEX_CORRECT;}
<INITIAL>{SPACE}				{
		if(flex_token->num_chars >= flex_token->chunk_length)
		 	return END_OF_CHUNK;
}
<INITIAL>{NEWLINE}			{
		if(flex_token->num_chars >= flex_token->chunk_length)
		 	return END_OF_CHUNK;
}
<INITIAL>.	{return ERROR;}
							
%%
