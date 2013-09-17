%nonterminal OBJECT
%nonterminal MEMBERS
%nonterminal PAIR
%nonterminal VALUE
%nonterminal STRING
%nonterminal CHARS
%nonterminal ARRAY
%nonterminal ELEMENTS

%axiom OBJECT

%terminal LBRACE
%terminal RBRACE
%terminal LSQUARE
%terminal RSQUARE
%terminal COMMA
%terminal COLON
%terminal BOOL
%terminal QUOTES
%terminal CHAR
%terminal NUMBER

%%

OBJECT : LBRACE RBRACE { }
       | LBRACE MEMBERS RBRACE { }
       ;

MEMBERS : PAIR { }
        | PAIR COMMA MEMBERS { }
        ;

PAIR : STRING COLON VALUE { }
     ;

VALUE : STRING { }
      | NUMBER { }
      | OBJECT { }
      | ARRAY { }
      | BOOL { }
      ;

STRING : QUOTES QUOTES { }
       | QUOTES CHARS QUOTES { }
       ;

CHARS : CHAR { }
      | CHAR CHARS { }
      ;

ARRAY : LSQUARE RSQUARE { }
      | LSQUARE ELEMENTS RSQUARE { }
      ;

ELEMENTS : VALUE { }
         | VALUE COMMA ELEMENTS { }
         ;
