%option noyywrap
%option noinput
%option nounput
%option reentrant
%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <limits.h>

#include "flex_token.h"
#include "grammar_tokens.h"
#include "sem_value_stack.h"
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
		flex_token->semantic_value = push_sem_value_on_stack(flex_token->stack_char, (void *)&ch, flex_token->realloc_size, 0); 
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return __LEX_CORRECT;}
<INITIAL>{RPAR}  {flex_token->token = RPAR;
        char ch = ')';
        flex_token->semantic_value = push_sem_value_on_stack(flex_token->stack_char, (void *)&ch, flex_token->realloc_size, 0); 
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return __LEX_CORRECT;}
<INITIAL>{TIMES} {flex_token->token = TIMES;
        char ch = '*';
        flex_token->semantic_value = push_sem_value_on_stack(flex_token->stack_char, (void *)&ch, flex_token->realloc_size, 0); 
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return __LEX_CORRECT;}
<INITIAL>{PLUS}  {flex_token->token = PLUS;
        char ch = '+';
        flex_token->semantic_value = push_sem_value_on_stack(flex_token->stack_char, (void *)&ch, flex_token->realloc_size, 0); 
        if(flex_token->num_chars >= flex_token->chunk_length)
		 	flex_token->chunk_ended = 1;
        return __LEX_CORRECT;}
<INITIAL>{DIGIT}+ {flex_token->token = NUMBER;
        uint32_t num = strtoul(yytext, NULL, 10);
		if ((num == ULONG_MAX && errno == ERANGE) || (num == 0 && errno == EINVAL)) {
		   /* Could not convert. */
		   return __ERROR;
		}
		flex_token->semantic_value = push_sem_value_on_stack(flex_token->stack_int, (void *)&num, flex_token->realloc_size, 1); 
        return __LEX_CORRECT;}
<INITIAL>{SPACE}				{
		if(flex_token->num_chars >= flex_token->chunk_length)
		 	return __END_OF_CHUNK;
}
<INITIAL>{NEWLINE}			{
		if(flex_token->num_chars >= flex_token->chunk_length)
		 	return __END_OF_CHUNK;
}
<INITIAL>.	{return __ERROR;}
							
%%
