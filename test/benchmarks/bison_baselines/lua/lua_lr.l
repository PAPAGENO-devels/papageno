%option noyywrap

%{
#include <string.h>
#include "lua_lr.parser.h"

// Complain about a bad character in the input.
static void PanicWithBadChar(int c) {
  if (c >= 32 && c <= 126) {
    printf("Unexpected character '%c'\n", c);
  } else {
    printf("Unexpected character #%d\n", (unsigned char) c);
  }
}

typedef struct token_node{
	int token; /**< Terminal token if leaf, else nonterminal token corresponding to the reduction of a rule. */
	void *value; /**< Semantic value of the node. Corresponds to the semantic value of the terminal token if the node is a leaf.*/
	struct token_node *next; /**< Next token in the current list. */
	struct token_node *parent; /**< Token corresponding to the token obtained by the reduction of the current one. */
	struct token_node *child; /**< First token of the rhs of the rule from which the current token was generated. */
} token_node;

#define TOKEN(n) { yylval.node=malloc(sizeof(token_node)); yylval.node->token=n; return n; }

static void SingleLineComment(char **ret_string);
static void MultilineCommentOrString(char *prefix, char **ret_string);
%}


%%

"--["=*"["				{ MultilineCommentOrString(yytext, 0); }
"--"					{ SingleLineComment(0); }
[ \t\v\f\r\n]+				{ /* Ignore whitespace */ }

"and"					{ TOKEN(AND); }
"break"					{ TOKEN(BREAK); }
"do"					{ TOKEN(DO); }
"else"					{ TOKEN(ELSE); }
"elseif"				{ TOKEN(ELSEIF); }
"end"					{ TOKEN(END); }
"false"					{ TOKEN(FALSE); }
"for"					{ TOKEN(FOR); }
"function"				{ TOKEN(FUNCTION); }
"if"					{ TOKEN(IF); }
"in"					{ TOKEN(IN); }
"local"					{ TOKEN(LOCAL); }
"nil"					{ TOKEN(NIL); }
"not"					{ TOKEN(NOT); }
"or"					{ TOKEN(OR); }
"repeat"				{ TOKEN(REPEAT); }
"return"				{ TOKEN(RETURN); }
"then"					{ TOKEN(THEN); }
"true"					{ TOKEN(TRUE); }
"until"					{ TOKEN(UNTIL); }
"while"					{ TOKEN(WHILE); }
".."					{ TOKEN(CONCAT); }
"..."					{ TOKEN(ELLIPSES); }
"=="					{ TOKEN(EQ);}
">="					{ TOKEN(GE); }
"<="					{ TOKEN(LE); }
"~="					{ TOKEN(NE); }

"+"  					 {TOKEN(PLUS);}
"*"                                      {TOKEN(TIMES);}
"-"                                      {TOKEN(MINUS);}
"/"					 {TOKEN(DIV);}
"%"					 {TOKEN(MOD);}
"="					 {TOKEN(ASSIGN);}
"("					 {TOKEN(LROUND);}
")"					 {TOKEN(RROUND);}
"["					 {TOKEN(LSQUARE);}
"]"					 {TOKEN(RSQUARE);}
"{"					 {TOKEN(LCURLY);}
"}"					 {TOKEN(RCURLY);}
"<"					 {TOKEN(LESS);}
">"					 {TOKEN(GTR);}
","					 {TOKEN(COMMA);}
":"					 {TOKEN(COLON);}
"^"					 {TOKEN(CARET);}
"#"					 {TOKEN(SHARP);}
"."					 {TOKEN(PERIOD);}

[a-zA-Z_][a-zA-Z_0-9]*			{ yylval.node= malloc(sizeof (token_node));
                                          yylval.node->value = strdup(yytext); 
                                          return IDENTIFIER; }

0[xX][a-fA-F0-9]+			|
[0-9]+([Ee][+-]?[0-9]+)?		|
[0-9]*"."[0-9]+([Ee][+-]?[0-9]+)?	|
[0-9]+"."[0-9]*([Ee][+-]?[0-9]+)?	{ yylval.node= malloc(sizeof (token_node));
                                          yylval.node->value = strdup(yytext); 
                                          return NUMBER; }

\"(\\.|\\\n|[^\\"])*\"			|
\'(\\.|\\\n|[^\\'])*\'			{ yylval.node= malloc(sizeof (token_node));
                                          yylval.node->value = strdup(yytext);
                                          return STRING; }
                                          
"["=*"["				{ char* valuestring;
                                          yylval.node= malloc(sizeof (token_node));
                                          MultilineCommentOrString(yytext, &valuestring); 
                                          yylval.node->value = valuestring;
                                          return STRING; }

";"					{ TOKEN(SEMI); }

<*>.					{ PanicWithBadChar(yytext[0]); }

<<EOF>>					{  return 0; }

%%
// Skip a single line comment in the lexer input file. If ret_string is
// nonzero then save the comment line in the string.
static void SingleLineComment(char **ret_string) {
    char c;
    do{
      c = input();
    } while(c != '\n' && c != EOF);
    if(ret_string){
       *ret_string = strdup("comment");
    }
}

/* in compliance with the OP lexer, this matches only [[ delimited strings */
static void MultilineCommentOrString(char *prefix, char **ret_string) {
  char* endposition;
  if(ret_string){
    if (strstr(prefix+2,"]]")!=NULL){
        *ret_string = strdup("Multiline comment or string");
        }
    else{
        *ret_string = strdup("Multiline comment mismatch");  
        printf("mismatched [[\n");
        } 
  }    
}