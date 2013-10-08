%%

%axiom S

%%

S : E {
		$$ = (char *) malloc(sizeof(char)*32);
		char *semantic_ch = $1;
		while (*semantic_ch != '=') {
			++semantic_ch;
		}
		++semantic_ch;
		sprintf($$, "S:E = %d", atoi(semantic_ch));}
  ;

E : E PLUS T {
		$$ = (char *) malloc(sizeof(char)*32);
		char *semantic_ch_1 = $1;
		while (*semantic_ch_1 != '=') {
			++semantic_ch_1;
		}
		++semantic_ch_1;
		char *semantic_ch_3 = $3;
		while (*semantic_ch_3 != '=') {
			++semantic_ch_3;
		}
		++semantic_ch_3;
		sprintf($$, "E:E+T = %d", atoi(semantic_ch_1) + atoi(semantic_ch_3));}
  | T {
		$$ = (char *) malloc(sizeof(char)*32);
		char *semantic_ch = $1;
		while (*semantic_ch != '=') {
			++semantic_ch;
		}
		++semantic_ch;
		sprintf($$, "E:T = %d", atoi(semantic_ch));}
  ;

T : T TIMES F {
		$$ = (char *) malloc(sizeof(char)*32);
		char *semantic_ch_1 = $1;
		while (*semantic_ch_1 != '=') {
			++semantic_ch_1;
		}
		++semantic_ch_1;
		char *semantic_ch_3 = $3;
		while (*semantic_ch_3 != '=') {
			++semantic_ch_3;
		}
		++semantic_ch_3;
		sprintf($$, "T:TxF = %d", atoi(semantic_ch_1)*atoi(semantic_ch_3));}
  | F {
		$$ = (char *) malloc(sizeof(char)*32);
		char *semantic_ch = $1;
		while (*semantic_ch != '=') {
			++semantic_ch;
		}
		++semantic_ch;
		sprintf($$, "T:F = %d", atoi(semantic_ch));}
  ;

F : LPAR E RPAR {
		$$ = (char *) malloc(sizeof(char)*32);
		char *semantic_ch = $2;
		while (*semantic_ch != '=') {
			++semantic_ch;
		}
		++semantic_ch;
		sprintf($$, "F:(E) = %d", atoi(semantic_ch));}
  | NUMBER {
		$$ = (char *) malloc(sizeof(char)*32);
		sprintf($$, "F:NUMBER = %d", atoi($1));}
  ;
