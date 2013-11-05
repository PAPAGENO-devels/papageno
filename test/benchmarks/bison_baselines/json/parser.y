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
void yyerror(char* msg) {}
%}

%union {
	token_node *node;
}

%token <node> LBR; 
%token <node> RBR; 
%token <node> LSQ;
%token <node> RSQ;
%left  <node> COM;  
%left  <node> COL;  
%token <node> BOO;   
%token <node> QUO;
%token <node> CHA;   
%token <node> NUM;

%type <node> s
%type <node> obj
%type <node> mem
%type <node> pair
%type <node> val
%type <node> str
%type <node> chars
%type <node> array
%type <node> elem

%%

s: obj {
		fprintf(stderr, "BISON> finished parsing.\n");
		bison_tree = $1;}	
	;

obj: LBR RBR {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = OBJECT;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
                $1->next = $2;
		}
   | LBR mem RBR {
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

mem: pair {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = MEMBERS;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | mem COM pair {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = MEMBERS;
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

pair: str COL val {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = PAIR;
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

val: str {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | NUM {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | array {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | obj {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   | BOO {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = VALUE;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
   ;

str: QUO QUO {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = STRING;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
   | QUO chars QUO {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = STRING;
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

chars: CHA {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = CHARS;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
     | chars CHA {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = CHARS;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
	 ;

array: LSQ RSQ {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ARRAY;
		$$->value = NULL;
		$1->parent = $$;
		$2->parent = $$;
		$$->next = NULL;
		$$->child = $1;
        $1->next = $2;
		}
     | LSQ elem RSQ {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ARRAY;
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

elem: val {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ELEMENTS;
		$$->value = NULL;
		$1->parent = $$;
		$$->next = NULL;
		$$->child = $1;
		}
    | elem COM val {
		$$ = (token_node*) malloc(sizeof(token_node));
		$$->token = ELEMENTS;
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

%%
int main(int argc, char **argv)
{
	char *file_name, ch;
	struct timespec timer_s, timer_e;
	double time_nanoseconds;

	/* Get input parameters. */
	file_name = NULL;
	file_name = argv[1];

	portable_clock_gettime(&timer_s);

	yyin = fopen(file_name, "r");
	if (yyin == NULL) {
		fprintf(stdout, "ERROR> could not open input file. Aborting.\n");
		return 1;
	}
	yyparse();
	fclose(yyin);
	portable_clock_gettime(&timer_e);
	time_nanoseconds=compute_time_interval(&timer_s, &timer_e);
	fprintf(stdout, "time: %lf\n",time_nanoseconds);

	dump_tree(bison_tree, 0);
	return 0;
}
