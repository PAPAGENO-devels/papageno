// Misc directives.
%start file
%expect 2

%{
#include <string.h>
#include <stdarg.h>
#include <stdio.h>
#include "timers.h"

typedef struct token_node{
	int token; /**< Terminal token if leaf, else nonterminal token corresponding to the reduction of a rule. */
	void *value; /**< Semantic value of the node. Corresponds to the semantic value of the terminal token if the node is a leaf.*/
	struct token_node *next; /**< Next token in the current list. */
	struct token_node *parent; /**< Token corresponding to the token obtained by the reduction of the current one. */
	struct token_node *child; /**< First token of the rhs of the rule from which the current token was generated. */
} token_node;

void yyerror(char* msg){
}
extern FILE *yyin;
%}

%union {
	struct token_node *node;
}
// Tokens. @@@ This list must match other files that use lua.lex.
%token <node> BREAK DO ELSE ELSEIF END FALSE FOR FUNCTION IF IN LOCAL NIL NOT REPEAT RETURN THEN TRUE UNTIL WHILE ELLIPSES SEMI LCURLY LROUND LSQUARE RCURLY RROUND RSQUARE
%token <node> SHARP SPECIAL COLON COMMA
%token <node> NUMBER STRING IDENTIFIER
%token <node> NONTERM
// Operator precedence.
%left <node> ASSIGN
%left <node> OR
%left <node> AND
%left <node> LESS GTR LE GE
%left <node> EQ NE
%right <node> CONCAT
%left <node> PLUS MINUS
%left <node> TIMES DIV MOD
%left <node> UNARY_OPERATOR
%right <node> CARET
%right <node> PERIOD

// type the nonterms as a common AST node 
%type <node> identifier_list opt_special opt_field_separator field_separator opt_semicolon field field_list table_constructor opt_parameter_list function_body 
%type <node> arguments br_function_call nobr_function_call br_variable nobr_variable nobr_prefix_expression expression_list expression opt_block opt_block_statements
%type <node> class_1_statement class_2_statement class_3_statement class_4_statement func_name_list br_variable_list nobr_variable_list last_statement
%type <node> elseif_block opt_else_block elseif_block_list opt_elseif_block_list br_statement nobr_statement statement_list statement_list_1 statement_list_2
%type <node> statement_list_3 statement_list_4

%%

file: opt_block	{ printf("done"); } ;

opt_block: opt_block_statements { 
                $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		} ;

opt_block_statements: { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL;
		}
  | last_statement { 
                $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
  | statement_list{ 
                $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
  | statement_list last_statement { 
                $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;}  ;

// Statement lists are divided into four sub-lists, each of which ends in
// a different kind of statement. Transitions between the different kinds
// of list are carefully written to disallow statements that start with
// brackets from following function calls that don't end in a semicolon.
//
// Individual statements are distinguished based on:
//   - If they start with a bracket LROUND.
//   - If they are function calls.
//   - If they end with a semicolon SEMI.
//
// The 8 possible kinds of statement are grouped into classes as follows:
//   Class 1: Unbracketed function calls.
//      function-call()
//   Class 2: Bracketed function calls.
//      (function-call)()
//   Class 3: Safe unbracketed statements that can be followed by anything.
//      non-function-call
//      function-call();
//	non-function-call;
//   Class 4: Safe bracketed statements that can be followed by anything.
//      (non-function-call)
//      (non-function-call);
//      (function-call)();
//
// Each of the four statement lists ends in one of these classes. The allowed
// and disallowed transitions between classes are:
//
//     From |To: 1   2   3   4 
//     -----+------+---+---+---
//       1  |    .   X   .   X      . = yes
//       2  |    .   X   .   X      X = no
//       3  |    .   .   .   .
//       4  |    .   .   .   .
  
class_1_statement:
    nobr_function_call	{                 
                $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;} ;

class_2_statement:
    br_function_call	{  
                $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

class_3_statement:
    nobr_statement opt_special			{                 $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | nobr_statement SEMI opt_special		{                 $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | nobr_function_call SEMI			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

class_4_statement:
    br_statement  { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | br_statement SEMI      { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | br_function_call SEMI			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

statement_list:
    statement_list_1 { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | statement_list_2 { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | statement_list_3 { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | statement_list_4 { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

statement_list_1:
    class_1_statement { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; } 
  | statement_list_1 class_1_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_2 class_1_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_3 class_1_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_4 class_1_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

statement_list_2:
    class_2_statement { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | statement_list_3 class_2_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_4 class_2_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

statement_list_3:
    class_3_statement { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | statement_list_1 class_3_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_2 class_3_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_3 class_3_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_4 class_3_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

statement_list_4:
    class_4_statement { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;}
  | statement_list_3 class_4_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | statement_list_4 class_4_statement	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

// A non-function-call statement that doesn't start with a bracket.

nobr_statement:
    nobr_variable_list ASSIGN expression_list	{$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  | DO opt_block END				{$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  | WHILE expression DO opt_block END		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $4->next = $5; }
  | REPEAT opt_block UNTIL expression		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4; }
  | IF expression THEN opt_block opt_elseif_block_list
	opt_else_block END			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $6->next = $7; }
  | FOR IDENTIFIER ASSIGN expression COMMA expression
	DO opt_block END			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $8->next = $9; }
  | FOR IDENTIFIER ASSIGN expression COMMA expression COMMA expression
	DO opt_block END			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $10->next = $11; }
  | FOR identifier_list IN expression_list
	DO opt_block END			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $6->next = $7; }
  | FUNCTION func_name_list function_body	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  | FUNCTION func_name_list COLON IDENTIFIER
	function_body				{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $4->next = $5; }
  | LOCAL FUNCTION IDENTIFIER function_body	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4;	}
  | LOCAL identifier_list			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | LOCAL identifier_list ASSIGN expression_list	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4; }
  | IDENTIFIER STRING				{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

// A non-function-call statement that starts with a bracket.

br_statement:
    br_variable_list ASSIGN expression_list	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  ;

// Rules that make up parts 'if-then-elseif-else' statements.

opt_elseif_block_list:	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL; }
  | elseif_block_list { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

elseif_block_list:
    elseif_block { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | elseif_block_list elseif_block		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

elseif_block:
    ELSEIF expression THEN opt_block		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4; }
  ;

opt_else_block: { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL; }
  | ELSE opt_block	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

// The last statement in a block.

last_statement:
    RETURN opt_semicolon			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | RETURN expression_list opt_semicolon	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | BREAK opt_semicolon				{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;
 
// Variable lists used in statements.

nobr_variable_list:
    nobr_variable { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | nobr_variable_list COMMA nobr_variable { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | nobr_variable_list COMMA br_variable { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  ;

br_variable_list:
    br_variable { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | br_variable_list COMMA nobr_variable{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | br_variable_list COMMA br_variable	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  ;

// Function names.

func_name_list:
    IDENTIFIER { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | func_name_list PERIOD IDENTIFIER	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  ;

// Expressions.

expression:
    NIL						{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | FALSE					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | TRUE					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | NUMBER                                      { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | STRING                                      { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | ELLIPSES					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | FUNCTION function_body			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | nobr_prefix_expression                      { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;}
  | LROUND expression RROUND			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | table_constructor                           { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | expression CONCAT expression		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression PLUS expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression MINUS expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression TIMES expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression DIV expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression CARET expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression MOD expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression LESS expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression LE expression			{$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression GTR expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3;}
  | expression GE expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression EQ expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression NE expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression AND expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | expression OR expression			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  | NOT expression %prec UNARY_OPERATOR		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | MINUS expression %prec UNARY_OPERATOR		{$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | SHARP expression %prec UNARY_OPERATOR		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  ;

expression_list:
    expression  { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | expression_list COMMA expression		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; 
                $2->next = $3; }
  ;

// "Prefix expressions" are R-values, i.e. expression values.
// The only prefix expression that starts with LROUND is '(expression)'.

nobr_prefix_expression:
    nobr_variable { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | nobr_function_call { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

// "Variables" are L-values, i.e. anything that can appear on the left hand
// side of an equals sign and be assigned to.

nobr_variable:
    IDENTIFIER { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | nobr_prefix_expression LSQUARE expression RSQUARE	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4; }
  | nobr_prefix_expression PERIOD IDENTIFIER	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  ;

br_variable:
    LROUND expression RROUND LSQUARE expression RSQUARE	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $5->next = $6; }
  | LROUND expression RROUND PERIOD IDENTIFIER		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $4->next = $5; }
  ;

// Functions.

nobr_function_call:
    nobr_prefix_expression arguments		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | nobr_prefix_expression COLON IDENTIFIER arguments	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  ;

br_function_call:
    LROUND expression RROUND arguments		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$4->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4; }
  | LROUND expression RROUND COLON IDENTIFIER arguments	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $5->next = $6;}
  ;

arguments:
    LROUND RROUND					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | LROUND expression_list RROUND			{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  | table_constructor LROUND RROUND					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  | STRING 					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

function_body:
    LROUND opt_parameter_list RROUND opt_block END	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $4->next = $5;}
  ;

opt_parameter_list:
						{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL; }
  | ELLIPSES					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | identifier_list { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | identifier_list COMMA ELLIPSES		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  ;

// Tables.

table_constructor:
    LCURLY RCURLY					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2; }
  | LCURLY  field_list opt_field_separator RCURLY { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
                $4->parent = $$;
                $$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3;
                $3->next = $4; }
  ;

field_list:
    field					{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | field_list field_separator field		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  ;

field:
    LSQUARE expression RSQUARE ASSIGN expression	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
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
                $4->next = $5;}
  | IDENTIFIER ASSIGN expression		{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  | expression	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

// Trivial stuff

opt_semicolon: { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL; } 
		| SEMI { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; };

field_separator: COMMA { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
		| SEMI { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; };

opt_field_separator: { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL; } 
		| field_separator { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; };

identifier_list:
    IDENTIFIER { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  | identifier_list COMMA IDENTIFIER	{ $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$3->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
                $2->next = $3; }
  ;

opt_special: { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$$->next = NULL;
		$$->child = NULL; }
  | SPECIAL { $$ = (token_node*) malloc(sizeof(token_node));
		$$->token = NONTERM;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1; }
  ;

%%

int main(int argc, char* argv[]){
        
        struct timespec timer_s, timer_e;
	double time_nanoseconds;

	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
		fprintf(stdout, "ERROR> could not open input file. Aborting.\n");
		return 1;
	}
	portable_clock_gettime(&timer_s);
	yyparse();
	portable_clock_gettime(&timer_e);
	fclose(yyin);
	time_nanoseconds=compute_time_interval(&timer_s, &timer_e);
	fprintf(stdout, "\ntime: %lf\n",time_nanoseconds);
	return 0;
}
