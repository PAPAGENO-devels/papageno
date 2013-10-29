%{
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "timers.h"
#include "grammar.h"

#define YYMAXDEPTH 1000000

#define DEBUG 0

extern FILE *yyin;

token_node *bison_tree;

void dump_tree(token_node *tree, uint32_t level)
{
#if DEBUG
	uint32_t itr;
    token_node *child_itr = NULL;

	for (itr = 0; itr < level; itr++) {
		fprintf(stderr, "\t");
	}
	if (tree->value != NULL) {
		fprintf(stderr, "<%s>\n", (char *)tree->value);
	} else {
		fprintf(stderr, "<%u>\n", tree->token);
    }
    child_itr = tree->child;
	while (child_itr != NULL && child_itr->parent == tree) {
		dump_tree(child_itr, level + 1);
        child_itr = child_itr->next;
	}
#endif
}

%}

%union {
	token_node *node;
}

%type <node> chunk
%type <node> block
%type <node> statList
%type <node> stat
%type <node> elseIfBlock
%type <node> retStat
%type <node> label
%type <node> funcName
%type <node> nameDotList
%type <node> varList
%type <node> var
%type <node> nameList
%type <node> exprList
%type <node> expr
%type <node> prefixExp
%type <node> functionCall
%type <node> args
%type <node> functionDef
%type <node> funcBody
%type <node> parList
%type <node> tableConstructor
%type <node> fieldList
%type <node> fieldListBody
%type <node> field

%token <node> BREAK
%token <node> COLON
%token <node> COLON2
%token <node> COMMA
%token <node> DO
%token <node> DOT
%token <node> DOT3
%token <node> ELSE
%token <node> ELSEIF
%token <node> END
%token <node> EQ
%token <node> FALSE
%token <node> FOR
%token <node> FUNCTION
%token <node> GOTO
%token <node> IF
%token <node> IN
%token <node> LBRACE
%token <node> LBRACK
%token <node> LOCAL
%token <node> LPAREN
%token <node> NAME
%token <node> NIL
%token <node> NUMBER
%left <node> OR
%token <node> RBRACE
%token <node> RBRACK
%token <node> REPEAT
%token <node> RETURN
%token <node> RPAREN
%token <node> SEMI
%token <node> STRING
%token <node> THEN
%token <node> TRUE
%token <node> UNTIL
%token <node> WHILE

%left <node> AND
%left <node> LT GT LTEQ GTEQ NEQ EQ2
%right <node> DOT2
%left <node> PLUS MINUS
%left <node> ASTERISK DIVIDE PERCENT
%left <node> NOT SHARP UMINUS
%right <node> CARET

%%


chunk : block {
		fprintf(stderr, "BISON> finished parsing.\n");
		bison_tree = $1;}
	;	

block : /*empty*/ {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$$->next = NULL;
		}
		
	| statList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| statList retStat {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| retStat {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	;
	
statList : stat {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| statList stat {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	;


stat :  SEMI {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| varList EQ exprList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| functionCall {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| label {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| BREAK {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| GOTO NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| DO block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| WHILE expr DO block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		}
	| REPEAT block UNTIL expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		}
	| IF expr THEN block elseIfBlock ELSE block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$6->parent = $$;
		$7->parent = $$;
		$8->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		$5->next = $6;
		$6->next = $7;
		$7->next = $8;
		}
	| IF expr THEN block elseIfBlock END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$6->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		$5->next = $6;
		}
	| IF expr THEN block ELSE block END{
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$6->parent = $$;
		$7->parent = $$;		
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		$5->next = $6;
		$6->next = $7;
		}
	| IF expr THEN block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		}	
	| FOR NAME EQ expr COMMA expr COMMA expr DO block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$6->parent = $$;
		$7->parent = $$;
		$8->parent = $$;
		$9->parent = $$;
		$10->parent = $$;
		$11->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		$5->next = $6;
		$6->next = $7;
		$7->next = $8;
		$8->next = $9;
		$9->next = $10;
		$10->next = $11;
		}
	| FOR NAME EQ expr COMMA expr DO block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$6->parent = $$;
		$7->parent = $$;
		$8->parent = $$;
		$9->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		$5->next = $6;
		$6->next = $7;
		$7->next = $8;
		$8->next = $9;
		}
	| FOR nameList IN exprList DO block END	{
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$6->parent = $$;
		$7->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		$5->next = $6;
		$6->next = $7;
		}
	| FUNCTION funcName funcBody {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| LOCAL FUNCTION NAME funcBody {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		}
	| LOCAL nameList EQ exprList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		}
	| LOCAL nameList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	;

elseIfBlock :  ELSEIF expr THEN block
	| elseIfBlock ELSEIF expr THEN block {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		}
	;	

retStat : RETURN {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| RETURN exprList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| RETURN SEMI {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| RETURN exprList SEMI {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;

label : COLON2 NAME COLON2 {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;
	
funcName : nameDotList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| nameDotList COLON NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;

nameDotList : NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| nameDotList DOT NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;

varList : var {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| varList COMMA var {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;
	
var : NAME {    $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| prefixExp LBRACK expr RBRACK {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		}
	| prefixExp DOT NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;
	
nameList : NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| nameList COMMA NAME {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;

exprList : expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| exprList COMMA expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;
	
expr : NIL {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| FALSE {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| TRUE {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| NUMBER {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| STRING {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| DOT3 {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| functionDef {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| prefixExp {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| tableConstructor {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| expr OR expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr AND expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr LT expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr GT expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr LTEQ expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr GTEQ expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr NEQ expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr EQ2 expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr DOT2 expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr PLUS expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr MINUS expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr ASTERISK expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr DIVIDE expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr PERCENT expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr CARET expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| NOT expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| SHARP expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| MINUS expr %prec UMINUS {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	;
	
prefixExp : var {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| functionCall {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| LPAREN expr RPAREN {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;
	
functionCall : prefixExp args {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| prefixExp COLON NAME args {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		}
	;

args : LPAREN exprList RPAREN {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| LPAREN RPAREN {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| tableConstructor {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| STRING {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	;

functionDef : FUNCTION funcBody {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	;
	
funcBody : LPAREN parList RPAREN block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		}
	| LPAREN RPAREN block END {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;		
		}
	;
	
parList: nameList {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| nameList COMMA DOT3 {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| DOT3 {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	;		

tableConstructor : LBRACE fieldList RBRACE {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| LBRACE RBRACE {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	;

fieldList : fieldListBody {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| fieldListBody COMMA {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	| fieldListBody SEMI {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		}
	;

fieldListBody : field {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	| fieldListBody COMMA field {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| fieldListBody SEMI field {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	;	
	
field : LBRACK expr RBRACK EQ expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$5->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		$3->next = $4;
		$4->next = $5;
		}
	| NAME EQ expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		$1->next = $2;
		$2->next = $3;
		}
	| expr {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
	;
