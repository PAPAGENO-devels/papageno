%option noyywrap
%option nounput
%option noinput

%{

#include <stdlib.h>
#include "grammar_tokens.h"

struct lex_token {
	gr_token token;
	void* semantic_value;
};

extern struct lex_token* flex_token;


%}

LBRACE  [\{]
RBRACE  [\}]
LSQUARE  [\[]
RSQUARE  [\]]
COMMA  [,]
COLON  [:]
BOOL  true|false|null
CHAR  [\x20-\x21\x23-\x5b\x5d-\xff]
QUOTES  [\"]
RSOLIDUS [\\]
SPECIAL  ([\"\\\/bfnrt]|(u[0-9A-Fa-f]{4}))
POINT  [\.]
EXP   [eE]
MINUS  [-]
EXPSIGN  [-+]
DIGIT  [0-9]
SPACE  " "|\t
NEWLINE  [\n]
DECIMALINTEGERLITERAL (-?(0|([1-9][0-9]*)))
JSONFRACTION (\.[0-9]+)
EXPONENTPART ([eE][+-]?[0-9]+)
NUMBER  (-?(0|([1-9][0-9]*))(\.[0-9]+)?([eE][+-]?[0-9]+)?)

%x string
%x escape
%x number

%%

<INITIAL>{LBRACE} { flex_token->token = LBRACE;
                    flex_token->semantic_value = NULL;
                    return 1;}
<INITIAL>{RBRACE} { flex_token->token = RBRACE;
                    flex_token->semantic_value = NULL;
                    return 1;}
<INITIAL>{LSQUARE} { flex_token->token = LSQUARE;
                     flex_token->semantic_value = NULL;
                     return 1;}
<INITIAL>{RSQUARE} { flex_token->token = RSQUARE;
                     flex_token->semantic_value = NULL;
                     return 1;}
<INITIAL>{COMMA}          {flex_token->token = COMMA;
              flex_token->semantic_value = NULL;
              return 1;}
<INITIAL>{COLON}          {flex_token->token = COLON;
              flex_token->semantic_value = NULL;
              return 1;}
<INITIAL>{BOOL}           {flex_token->token = BOOL;
              flex_token->semantic_value = NULL;
              return 1;}
<INITIAL>{QUOTES}          {flex_token->token = QUOTES;
              flex_token->semantic_value = NULL;
              BEGIN(string);
              return 1;}
<string>{CHAR}           {flex_token->token = CHAR;
              flex_token->semantic_value = NULL;
              return 1;}
<string>{RSOLIDUS}          {BEGIN(escape);}
<string>{QUOTES}          {flex_token->token = QUOTES;
              flex_token->semantic_value = NULL;
              BEGIN(INITIAL);
              return 1;}
<escape>{SPECIAL}          {flex_token->token = CHAR;
              flex_token->semantic_value = NULL;
              BEGIN(string);
              return 1;}
<INITIAL>{NUMBER}          {flex_token->token = NUMBER;
              flex_token->semantic_value = NULL;
              return 1;}
<INITIAL>{SPACE}          {}
<INITIAL>{NEWLINE}          {}

%%

