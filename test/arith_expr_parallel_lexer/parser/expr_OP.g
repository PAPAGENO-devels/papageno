%nonterminal S
%nonterminal E
%nonterminal T
%nonterminal F

%axiom S

%terminal PLUS
%terminal TIMES
%terminal LPAR
%terminal RPAR
%terminal NUMBER

%%

S : E PLUS T { }
  | T { }
;

T : T TIMES F { }
  | F { }
;

F : LPAR E RPAR { }
  | NUMBER { }
;