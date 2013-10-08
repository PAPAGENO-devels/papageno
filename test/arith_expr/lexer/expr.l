%option noyywrap
%option noinput
%option nounput

LPAR    [\(]
RPAR    [\)]
PLUS    [\+]
TIMES   [\*]
DIGIT   [0-9]
SPACE   " "|\t
NEWLINE [\n]

%%

%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <limits.h>

#include "grammar_tokens.h"
#include "flex_return_codes.h"

struct lex_token {
  gr_token token;
  void* semantic_value;
};

extern struct lex_token* flex_token;
char *ch;
uint32_t *num;

%}

<INITIAL>{LPAR}  {flex_token->token = LPAR;
        ch = (char*) malloc(sizeof(char));
        *ch = '(';
        flex_token->semantic_value = (void*) ch;
        return LEX_CORRECT;}
<INITIAL>{RPAR}  {flex_token->token = RPAR;
        ch = (char*) malloc(sizeof(char));
        *ch = ')';
        flex_token->semantic_value = (void*) ch;
        return LEX_CORRECT;}
<INITIAL>{TIMES} {flex_token->token = TIMES;
        ch = (char*) malloc(sizeof(char));
        *ch = '*';
        flex_token->semantic_value = (void*) ch;
        return LEX_CORRECT;}
<INITIAL>{PLUS}  {flex_token->token = PLUS;
        ch = (char*) malloc(sizeof(char));
        *ch = '+';
        flex_token->semantic_value = (void*) ch;
        return LEX_CORRECT;}
<INITIAL>{DIGIT}+ {flex_token->token = NUMBER;
        num = (uint32_t*) malloc(sizeof(uint32_t));
        *num = strtoul(yytext, NULL, 10);
        if ((*num == ULONG_MAX && errno == ERANGE) || (*num == 0 && errno == EINVAL)) {
           /* Could not convert. */
           return ERROR;
        }
        flex_token->semantic_value = (void*) num;
        return LEX_CORRECT;}
<INITIAL>{SPACE}			{}
<INITIAL>{NEWLINE}			{}
<INITIAL>.  {return ERROR;}

%%

