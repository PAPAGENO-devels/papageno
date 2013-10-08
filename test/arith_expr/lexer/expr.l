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

#include "grammar_tokens.h"
#include "flex_return_codes.h"

struct lex_token {
  gr_token token;
  void* semantic_value;
};

extern struct lex_token* flex_token;
char *ch;

%}

<INITIAL>{LPAR}  {flex_token->token = LPAR;
        char ch = '(';
        flex_token->semantic_value = (void*) &ch;
        return LEX_CORRECT;}
<INITIAL>{RPAR}  {flex_token->token = RPAR;
        char ch = ')';
        flex_token->semantic_value = (void*) &ch;
        return LEX_CORRECT;}
<INITIAL>{TIMES} {flex_token->token = TIMES;
        char ch = '*';
        flex_token->semantic_value = (void*) &ch;
        return LEX_CORRECT;}
<INITIAL>{PLUS}  {flex_token->token = PLUS;
        char ch = '+';
        flex_token->semantic_value = (void*) &ch;
        return LEX_CORRECT;}
<INITIAL>{DIGIT}+ {flex_token->token = NUMBER;
        long32_t num = strtol(yytext, NULL, 10);
        if ((num == LONG_MAX || num == LONG_MIN) && errno == ERANGE) {
           /* Could not convert. */
           return ERROR;
        }
        flex_token->semantic_value = (void*) &num;
        return LEX_CORRECT;}
<INITIAL>{SPACE}			{}
<INITIAL>{NEWLINE}			{}
<INITIAL>.  {return ERROR;}

%%

