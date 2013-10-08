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

struct lex_token {
  gr_token token;
  void* semantic_value;
};

extern struct lex_token* flex_token;
char *ch;

%}

{LPAR}  {flex_token->token = LPAR;
        ch = (char *) malloc(sizeof(char)*2);
        strcpy(ch, "(");
        flex_token->semantic_value = ch;
        return 1;}
{RPAR}  {flex_token->token = RPAR;
        ch = (char *) malloc(sizeof(char)*2);
        strcpy(ch, ")");
        flex_token->semantic_value = ch;
        return 1;}
{TIMES} {flex_token->token = TIMES;
        ch = (char *) malloc(sizeof(char)*2);
        strcpy(ch, "*");
        flex_token->semantic_value = ch;
        return 1;}
{PLUS}  {flex_token->token = PLUS;
        ch = (char *) malloc(sizeof(char)*2);
        strcpy(ch, "+");
        flex_token->semantic_value = ch;
        return 1;}
{DIGIT}+ {flex_token->token = NUMBER;
        ch = (char *) malloc(sizeof(char)*(yyleng+1));
        strcpy(ch, yytext);
        flex_token->semantic_value = ch;
        return 1;}
{SPACE}				{}
{NEWLINE}			{}

%%

