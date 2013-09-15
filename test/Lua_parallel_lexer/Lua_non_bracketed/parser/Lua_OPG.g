%nonterminal chunk
%nonterminal block
%nonterminal statList
%nonterminal stat
%nonterminal elseIfBlock
%nonterminal exprThenElseIfB
%nonterminal exprThen
%nonterminal name
%nonterminal eCe
%nonterminal eCeCe
%nonterminal dot3
%nonterminal retStat
%nonterminal label
%nonterminal funcName
%nonterminal nameDotList
%nonterminal varList
%nonterminal var
%nonterminal nameList
%nonterminal exprList
%nonterminal expr
%nonterminal logicalOrExp
%nonterminal logicalAndExp
%nonterminal relationalExp
%nonterminal concatExp
%nonterminal additiveExp
%nonterminal multiplicativeExp
%nonterminal unaryExp
%nonterminal caretExp
%nonterminal baseExp
%nonterminal prefixExp
%nonterminal functionCall
%nonterminal functionDef
%nonterminal parList
%nonterminal tableConstructor
%nonterminal fieldList
%nonterminal fieldListBody
%nonterminal field
%nonterminal bracketedExp

%axiom chunk

%terminal ENDFILE
%terminal RETURN
%terminal SEMI
%terminal COLON
%terminal COLON2
%terminal DOT
%terminal DOT3
%terminal COMMA
%terminal LBRACK
%terminal RBRACK
%terminal LBRACE
%terminal RBRACE
%terminal LPAREN
%terminal RPAREN
%terminal EQ
%terminal BREAK
%terminal GOTO
%terminal DO
%terminal END
%terminal WHILE
%terminal REPEAT
%terminal UNTIL
%terminal IF
%terminal THEN
%terminal ELSEIF
%terminal ELSE
%terminal FOR
%terminal IN
%terminal FUNCTION
%terminal LOCAL
%terminal NIL
%terminal FALSE
%terminal TRUE
%terminal NUMBER
%terminal STRING
%terminal NAME
%terminal PLUS
%terminal MINUS
%terminal ASTERISK
%terminal DIVIDE
%terminal CARET
%terminal PERCENT
%terminal DOT2
%terminal LT	
%terminal GT	
%terminal LTEQ
%terminal GTEQ
%terminal EQ2
%terminal NEQ
%terminal AND
%terminal OR
%terminal NOT
%terminal UMINUS
%terminal SHARP
%terminal LPARENFUNC
%terminal RPARENFUNC
%terminal SEMIFIELD
%terminal XEQ

%%


chunk : block
	| ENDFILE
	;	

block : statList
	| retStat
	| statList RETURN SEMI
	| statList RETURN exprList SEMI
	| statList RETURN 
	| statList RETURN exprList
	;
	
statList : stat
	| SEMI
	| stat SEMI 
	| statList SEMI stat
	| statList SEMI
	;


stat :  varList XEQ exprList
	| functionCall
	| label
	| BREAK
	| GOTO NAME
	| DO block END
	| DO END
	| WHILE expr DO block END
	| WHILE expr DO END	
	| REPEAT block UNTIL expr
	| REPEAT UNTIL expr
	| IF exprThen END
	| IF exprThen ELSE block END
	| IF exprThen ELSE END
	| IF exprThenElseIfB END
	| IF exprThenElseIfB ELSE block END
	| IF exprThenElseIfB ELSE END		
	| FOR name XEQ eCe DO block END
	| FOR name XEQ eCeCe DO block END
	| FOR nameList IN exprList DO block END
	| FUNCTION funcName LPARENFUNC parList RPARENFUNC block END
	| FUNCTION funcName LPARENFUNC RPARENFUNC block END
	| FOR name XEQ eCe DO END
	| FOR name XEQ eCeCe DO END
	| FOR nameList IN exprList DO END
	| FUNCTION funcName LPARENFUNC parList RPARENFUNC END
	| FUNCTION funcName LPARENFUNC RPARENFUNC END
	| LOCAL FUNCTION name LPARENFUNC parList RPARENFUNC block END
	| LOCAL FUNCTION name LPARENFUNC RPARENFUNC block END
	| LOCAL FUNCTION name LPARENFUNC parList RPARENFUNC END
	| LOCAL FUNCTION name LPARENFUNC RPARENFUNC END	
	| LOCAL nameList
	| LOCAL nameList XEQ exprList
	;

elseIfBlock : block ELSEIF expr THEN block 
	| block ELSEIF expr THEN elseIfBlock
	| ELSEIF expr THEN block
	| block ELSEIF expr THEN
	| ELSEIF expr THEN
	| ELSEIF expr THEN elseIfBlock	
	;	

exprThenElseIfB : expr THEN elseIfBlock
 	;
 	
exprThen : expr THEN block
	| expr THEN
	;
	
name : NAME
	;
	
eCe : expr COMMA expr
	;
	
eCeCe  : eCe COMMA expr
	;
	
dot3 : DOT3
	;	

retStat : RETURN SEMI
	| RETURN exprList SEMI
	| RETURN
	| RETURN exprList
	;

label : COLON2 NAME COLON2
	;
	
funcName : nameDotList
	| nameDotList COLON name
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
	| nameList COMMA name
	;

exprList	: expr
	| exprList COMMA expr
	;
	
expr : logicalOrExp
	;
	
logicalOrExp : logicalAndExp
	| logicalOrExp OR logicalAndExp
	;

logicalAndExp : relationalExp
	| logicalAndExp AND relationalExp
	;

relationalExp : concatExp
	| relationalExp LT concatExp
	| relationalExp GT concatExp
	| relationalExp LTEQ concatExp
	| relationalExp GTEQ concatExp
	| relationalExp NEQ concatExp
	| relationalExp EQ2 concatExp
	;

concatExp : additiveExp
	| additiveExp DOT2 concatExp
	;

additiveExp : multiplicativeExp
	| additiveExp PLUS multiplicativeExp
	| additiveExp MINUS multiplicativeExp
	;

multiplicativeExp : unaryExp
	| multiplicativeExp ASTERISK unaryExp
	| multiplicativeExp DIVIDE unaryExp
	| multiplicativeExp PERCENT unaryExp
	;

unaryExp : caretExp
	| NOT unaryExp
	| SHARP unaryExp
	| UMINUS unaryExp
	;

caretExp : baseExp
	| baseExp CARET caretExp
	;

baseExp : NIL
	| FALSE
	| TRUE
	| NUMBER
	| STRING
	| DOT3
	| functionDef
	| prefixExp
	| tableConstructor
	;
	
prefixExp : var
	| functionCall
	| LPAREN expr RPAREN
	;
	
functionCall : prefixExp LPAREN exprList RPAREN
	| prefixExp LPAREN RPAREN
	| prefixExp LBRACE fieldList RBRACE
	| prefixExp LBRACE RBRACE
	| prefixExp STRING
	| prefixExp COLON name LPAREN exprList RPAREN
	| prefixExp COLON name LPAREN RPAREN
	| prefixExp COLON name LBRACE fieldList RBRACE
	| prefixExp COLON name LBRACE RBRACE
	| prefixExp COLON name STRING
	;


functionDef :FUNCTION LPARENFUNC parList RPARENFUNC block END
	| FUNCTION LPARENFUNC RPARENFUNC block END
	| FUNCTION LPARENFUNC parList RPARENFUNC END
	| FUNCTION LPARENFUNC RPARENFUNC END
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
	| fieldListBody SEMIFIELD
	;

fieldListBody : field
	| fieldListBody COMMA field
	| fieldListBody SEMIFIELD field
	;	
	
field : bracketedExp EQ expr
	| name EQ expr
	| expr
	;
	
bracketedExp : LBRACK expr RBRACK
	;