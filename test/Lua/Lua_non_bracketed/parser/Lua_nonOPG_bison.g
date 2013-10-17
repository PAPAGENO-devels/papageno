%nonterminal chunk
%nonterminal block
%nonterminal statList
%nonterminal stat
%nonterminal elseIfBlock
%nonterminal retStat
%nonterminal label
%nonterminal funcName
%nonterminal nameDotList
%nonterminal varList
%nonterminal var
%nonterminal nameList
%nonterminal exprList
%nonterminal expr
%nonterminal prefixExp
%nonterminal functionCall
%nonterminal args
%nonterminal functionDef
%nonterminal funcBody
%nonterminal parList
%nonterminal tableConstructor
%nonterminal fieldList
%nonterminal fieldListBody
%nonterminal field

%axiom chunk

%terminal AND
%terminal ASTERISK
%terminal BREAK
%terminal CARET
%terminal COLON
%terminal COLON2
%terminal COMMA
%terminal DIVIDE
%terminal DO
%terminal DOT
%terminal DOT2
%terminal DOT3
%terminal ELSE
%terminal ELSEIF
%terminal END
%terminal ENDFILE
%terminal EQ
%terminal EQ2
%terminal FALSE
%terminal FOR
%terminal FUNCTION
%terminal GOTO
%terminal GT	
%terminal GTEQ
%terminal IF
%terminal IN
%terminal LBRACE
%terminal LBRACK
%terminal LOCAL
%terminal LPAREN
%terminal LT	
%terminal LTEQ
%terminal MINUS
%terminal NAME
%terminal NEQ
%terminal NIL
%terminal NOT
%terminal NUMBER
%terminal OR
%terminal PERCENT
%terminal PLUS
%terminal RBRACE
%terminal RBRACK
%terminal REPEAT
%terminal RETURN
%terminal RPAREN
%terminal SEMI
%terminal SHARP
%terminal STRING
%terminal THEN
%terminal TRUE
%terminal UNTIL
%terminal WHILE

%left OR
%left AND
%left LT GT LTEQ GTEQ NEQ EQ2
%right DOT2
%left PLUS MINUS
%left ASTERISK DIVIDE PERCENT
%left NOT SHARP UMINUS
%right CARET

%%


chunk : block
	;	

block : /*empty*/
	| statList
	| statList retStat
	| retStat
	;
	
statList : stat
	| statList stat
	;


stat :  SEMI
	| varList EQ exprList
	| functionCall
	| label
	| BREAK
	| GOTO NAME
	| DO block END
	| WHILE expr DO block END
	| REPEAT block UNTIL expr
	| IF expr THEN block elseIfBlock ELSE block END
	| IF expr THEN block elseIfBlock END
	| IF expr THEN block ELSE block END
	| IF expr THEN block END		
	| FOR NAME EQ expr COMMA expr COMMA expr DO block END
	| FOR NAME EQ expr COMMA expr DO block END
	| FOR nameList IN exprList DO block END	
	| FUNCTION funcName funcBody
	| LOCAL FUNCTION NAME funcBody
	| LOCAL nameList EQ exprList
	| LOCAL nameList
	;

elseIfBlock :  ELSEIF expr THEN block
	| elseIfBlock ELSEIF expr THEN block	
	;	

retStat : RETURN
	| RETURN exprList
	| RETURN SEMI
	| RETURN exprList SEMI
	;

label : COLON2 NAME COLON2
	;
	
funcName : nameDotList
	| nameDotList COLON NAME
	;

nameDotList : NAME
	| nameDotList DOT NAME 
	;

varList : var
	| varList COMMA var
	;
	
var : NAME
	| prefixExp LBRACK expr RBRACK 
	| prefixExp DOT NAME
	;
	
nameList : NAME
	| nameList COMMA NAME
	;

exprList : expr
	| exprList COMMA expr
	;
	
expr : NIL
	| FALSE
	| TRUE
	| NUMBER
	| STRING
	| DOT3
	| functionDef
	| prefixExp
	| tableConstructor
	| expr OR expr
	| expr AND expr
	| expr LT expr
	| expr GT expr
	| expr LTEQ expr
	| expr GTEQ expr
	| expr NEQ expr
	| expr EQ2 expr
	| expr DOT2 expr
	| expr PLUS expr
	| expr MINUS expr
	| expr ASTERISK expr
	| expr DIVIDE expr
	| expr PERCENT expr
	| expr CARET expr
	| NOT expr
	| SHARP expr
	| MINUS expr %prec UMINUS
	;
	
prefixExp : var
	| functionCall
	| LPAREN expr RPAREN
	;
	
functionCall : prefixExp args
	| prefixExp COLON NAME args
	;

args : LPAREN exprList RPAREN 
	| LPAREN RPAREN
	| tableConstructor
	| STRING 
	;

functionDef : FUNCTION funcBody
	;
	
funcBody : LPAREN parList RPAREN block END
	| LPAREN RPAREN block END
	;
	
parList: nameList
	| nameList COMMA dot3
	| DOT3
	;		

tableConstructor : LBRACE fieldList RBRACE
	| LBRACE RBRACE
	;

fieldList : fieldListBody
	| fieldListBody COMMA
	| fieldListBody SEMI
	;

fieldListBody : field
	| fieldListBody COMMA field
	| fieldListBody SEMI field
	;	
	
field : LBRACK expr RBRACK EQ expr
	| NAME EQ expr
	| expr
	;
