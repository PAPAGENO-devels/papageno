%option noyywrap
%option nounput
%option noinput
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
SPACE		" "|\t
NEWLINE		[\n]
DECIMALINTEGERLITERAL	(-?(0|([1-9][0-9]*)))
JSONFRACTION	(\.[0-9]+)
EXPONENTPART	([eE][+-]?[0-9]+)
NUMBER		(-?(0|([1-9][0-9]*))(\.[0-9]+)?([eE][+-]?[0-9]+)?)

%x string
%x escape
%x number

%%

%{

#include <stdlib.h>

#include "grammar_tokens.h"

struct lex_token {
	gr_token token;
	void* semantic_value;
};

extern struct lex_token* flex_token;

%}

<INITIAL>{LBRACE}										{flex_token->token = LBRACE;
														/* Semantic value stub. */
														 // ch = (char*) malloc(sizeof(char)*2);
														 // ch[0] = '{';
														 // ch[1] = '\0';
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{RBRACE}										{flex_token->token = RBRACE;
														/* Semantic value stub. */
														 // ch = (char*) malloc(sizeof(char)*2);
														 // ch[0] = '}';
														 // ch[1] = '\0';
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{LSQUARE}										{flex_token->token = LSQUARE;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// ch[0] = '[';
														// ch[1] = '\0';
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{RSQUARE}										{flex_token->token = RSQUARE;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// ch[0] = ']';
														// ch[1] = '\0';
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{COMMA}										{flex_token->token = COMMA;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// ch[0] = ',';
														// ch[1] = '\0';
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{COLON}										{flex_token->token = COLON;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// ch[0] = ':';
														// ch[1] = '\0';
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{BOOL}											{flex_token->token = BOOL;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*6);
														// strcpy(ch, yytext);
														flex_token->semantic_value = NULL;
														return 1;}
<INITIAL>{QUOTES}										{flex_token->token = QUOTES;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// ch[0] = '"';
														// ch[1] = '\0';
														flex_token->semantic_value = NULL;
														BEGIN(string);
														return 1;}
<string>{CHAR}											{flex_token->token = CHAR;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// strcpy(ch, yytext);
														flex_token->semantic_value = NULL;
														return 1;}
<string>{RSOLIDUS}										{BEGIN(escape);}
<string>{QUOTES}										{flex_token->token = QUOTES;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*2);
														// ch[0] = '"';
														// ch[1] = '\0';
														flex_token->semantic_value = NULL;
														BEGIN(INITIAL);
														return 1;}
<escape>{SPECIAL}										{flex_token->token = CHAR;
														/* Semantic value stub. */
														//// ch = (char*) malloc(sizeof(char)*3);
														//// ch[0] = '\\';
														//// ch[1] = yytext[0];
														//// ch[2] = '\0';
														// ch = (char*) malloc(sizeof(char)*(2+strlen(yytext)));
														// ch[0] = '\\';
														// ch[1] = '\0';
														// strcat(ch, yytext);
														flex_token->semantic_value = NULL;
														BEGIN(string);
														return 1;}
<INITIAL>{NUMBER}										{flex_token->token = NUMBER;
														/* Semantic value stub. */
														// ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
														// strcpy(ch, yytext);
														//flex_token->semantic_value = ch;
														flex_token->semantic_value = NULL;
														return 1;}															
<INITIAL>{SPACE}										{}
<INITIAL>{NEWLINE}										{}


%%



