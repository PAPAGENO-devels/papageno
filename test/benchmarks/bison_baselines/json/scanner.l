%option noyywrap
%option noinput

%{
#include <string.h>
#include "grammar.h"
#include "parser.h"

token_node *node;
%}

LBRACE		[\{]
RBRACE		[\}]
LSQUARE		[\[]
RSQUARE		[\]]
COMMA		[,]
COLON		[:]
BOOL		true|false|null
CHAR		[\x00-\x21\x23-\x5b\x5d-\xff]
QUOTES		[\"]
RSOLIDUS	[\\]
SPECIAL		[\"\\\/bfnrtu]
POINT		[\.]
EXP		[eE]
MINUS		[-]
EXPSIGN		[-+]
DIGIT		[0-9]
SPACE		" "
NEWLINE		[\n]

%x string
%x escape
%x number

%%

<INITIAL>{LBRACE} {/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, "{");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = LBRACE;
 				node->value = NULL;
 				yylval.node = node;
 				return LBR;}
<INITIAL>{RBRACE} {/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, "}");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = RBRACE;
 				node->value = NULL;
 				yylval.node = node;
 				return RBR;}
<INITIAL>{LSQUARE} {/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, "[");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = LSQUARE;
 				node->value = NULL;
 				yylval.node = node;
 				return LSQ;}
<INITIAL>{RSQUARE} {/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, "]");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = RSQUARE;
 				node->value = NULL;
 				yylval.node = node;
 				return RSQ;}
<INITIAL>{COMMA} {/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, ",");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = COMMA;
 				node->value = NULL;
 				yylval.node = node;
 				return COM;}
<INITIAL>{COLON} {/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, ":");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = COLON;
 				node->value = NULL;
 				yylval.node = node;
 				return COL;}
<INITIAL>{BOOL} 	{/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*8);
 				// strcpy(ch, yytext);
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = BOOL;
 				node->value = NULL;
 				yylval.node = node;
 				return BOO;}
<INITIAL>{QUOTES} {BEGIN(string);
 				/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, "\"");
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = QUOTES;
 				node->value = NULL;
 				yylval.node = node;
 				return QUO;}
<string>{CHAR} 	{/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, yytext);
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = CHAR;
 				node->value = NULL;
 				yylval.node = node;
 				return CHA;}
<string>{RSOLIDUS} {BEGIN(escape);
 				yymore();}
<string>{QUOTES} {BEGIN(INITIAL);
 				/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*2);
 				// strcpy(ch, yytext);
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = QUOTES;
 				node->value = NULL;
 				yylval.node = node;
 				return QUO;}
<escape>{SPECIAL} {BEGIN(string);
 				/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*3);
 				// strcpy(ch, yytext);
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = CHAR;
 				node->value = NULL;
 				yylval.node = node;
 				return CHA;}
<INITIAL>{DIGIT}|{MINUS}								{yymore();
 				BEGIN(number);}
<number>{DIGIT}|{EXP}|{EXPSIGN}|{POINT}					{yymore();}
<number>{COMMA}|{SPACE}|{RBRACE}|{RSQUARE}				{/* Semantic value stub. */
 				// ch = (char*) malloc(sizeof(char)*strlen(yytext));
 				// strcpy(ch, yytext);
 				// ch[strlen(yytext) - 1] = '\0';
 				unput(yytext[yyleng - 1]);
 				node = (token_node*) malloc(sizeof(token_node));
 				node->token = NUMBER;
 				node->value = NULL;
 				yylval.node = node;
 				BEGIN(INITIAL);
 				return NUM;}
<INITIAL>{SPACE} {}
<INITIAL>{NEWLINE} {}
%%