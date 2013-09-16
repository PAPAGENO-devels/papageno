%option noyywrap
%option noinput
%option reentrant
%{

#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "./../include/flex_token.h"
#include "grammar_tokens.h"
#include "./../include/flex_return_codes_bracketed_strings.h"
#include "./../include/flex_token_formatting_bracketed_strings.h"
#include "./../include/delimiter_bracketed_strings.h"


#define YY_USER_ACTION flex_token->num_chars += yyleng;


/*TODO: 
-ottimizzazione da aggiungere: 
Crea una tabella hash che memorizza le classi di simboli di commenti chiusi (identificati dal numero di '=') gia' incontrati dall'inizio del chunk.
Tiene traccia di una stack dei simboli di commento multilinea aperti pendenti nel chunk gia' scandito e, se incontra un simbolo di commento chiuso con un numero di '=' 
per cui non ci sono commenti aperti pendenti e il cui numero di = era gia' nella tabella hash dei simboli di commento chiusi incontrati dall'inizio del chunk,
allora interrompe la scansione andando nello stato commentOrError. (hashtable per confrontare il numero di = del simbolo di commento pendente con quelli gia' letti).
Il vantaggio di usare l'ottimizzazione e' che, alla lettura del commento chiuso che soddisfa queste condizioni, si puo' evitare di andare nello stato INITIAL e invece
andare direttamente in commentOrError.
*/
/*
ENDSTATTOKEN			(NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|RPAREN|RBRACK|NAME|END|BREAK)
BEGINSTATTOKEN 			(LPAREN|NAME|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|FUNCTION|LOCAL)
ENDSTATTOKEN1			(NIL|FALSE|TRUE|NUMBER|DOT3|RBRACE|END|BREAK)
BEGINSTATTOKEN1 		(LPAREN|COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|LOCAL)
BEGINSTATTOKEN2 		(COLON2|BREAK|GOTO|DO|WHILE|REPEAT|IF|FOR|LOCAL)
 */

%}
%option extra-type="struct lex_token *"
AND			"and"
BREAK		"break"
DO 			"do"
ELSE 		"else"
ELSEIF 		"elseif"
END 		"end"
FALSE 		"false"
FOR 		"for"
FUNCTION 	"function"
GOTO 		"goto"
IF 			"if"
IN 			"in"
LOCAL 		"local"
NIL 		"nil"
NOT 		"not"
OR 			"or"
REPEAT 		"repeat"
RETURN 		"return"
THEN 		"then"
TRUE 		"true"
UNTIL 		"until"
WHILE 		"while"
NAME 		[a-zA-Z_][a-zA-Z0-9_]*
SEMI 		(;)
COLON		(:)
COLON2		(::)
DOT			(\.)
DOT3		(\.\.\.)
COMMA		(,)
LBRACK		(\[)
RBRACK		(\])
LBRACE		(\{)
RBRACE		(\})
LPAREN		(\()
RPAREN		(\))
EQ 			(=)
UMINUS		(-)
PLUS 		(\+)
MINUS		(-)
ASTERISK	(\*)
DIVIDE		(\/)
CARET		(\^)
PERCENT		(%)
DOT2 		(\.\.)
LT			(<)
GT			(>)
LTEQ		(<=)
GTEQ		(>=)
EQ2			(==)
NEQ			(~=)
SHARP		(#)
LPARENFUNC	(\()
RPARENFUNC	(\))
SEMIFIELD	(;)
XEQ			(=)
ESCAPE		[\\\"\'abfnrtv]
DECEXPONENT	([eE][+-]?[0-9]+)
BINEXPONENT	([pP][+-]?[0-9]+)
DECNUMBER	(([0-9]*\.[0-9]+|[0-9]+\.|[0-9]+){DECEXPONENT}?)
HEXNUMBER	(0[xX]([0-9a-fA-F]*\.[0-9a-fA-F]+|[0-9a-fA-F]+\.|[0-9a-fA-F]+){BINEXPONENT}?)
NUMBER 		({DECNUMBER}|{HEXNUMBER})
SPACE		" "|\a|\b|\f|\t|\v
NEWLINE		\n|\r|\r\n|\n\r

%x onelist_INITIAL
%x onelist_endStat1
%x onelist_endStat2
%x onelist_singleComment
%x onelist_multiComment
%x onelist_doubleString
%x onelist_singleString
%x onelist_bracketedString
%x onelist_bracketedStringOrError
%x onelist_commentOrError
%x onelist_function1
%x onelist_function2
%x twolists_INITIAL
%x twolists_endStat1
%x twolists_endStat2
%x twolists_singleComment
%x twolists_multiComment
%x twolists_singleString
%x twolists_bracketedString
%x twolists_commentOrError
%x twolists_function1
%x twolists_function2
%x second_lexing_bracketedString
%%


%{
struct lex_token * flex_token = yyextra;  
%}

<INITIAL>.|\n|\r	{
		if (flex_token->lexing_phase == 0)
			BEGIN(onelist_INITIAL);
		else
			BEGIN(second_lexing_bracketedString);
		unput(yytext[yyleng - 1]);
		(flex_token->num_chars)--;
}
<onelist_INITIAL>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "and");
				 flex_token->semantic_value[0] = ch;	
				 //flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "and", 3);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "do");
				 flex_token->semantic_value[0] = ch;	
				 //// flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "do", 2);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "else");
				 flex_token->semantic_value[0] = ch;	
				 //// flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "else", 4);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "elseif");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;	
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "elseif", 6);	
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "for");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "for", 3);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{FUNCTION}		{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*9);
        		 strcpy(ch, "function");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "function", 8);
				 BEGIN(onelist_function1);
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "goto");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "goto", 4);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "if");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "if", 2);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "in");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "in", 2);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "local");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "local", 5);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "not");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "not", 3);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "or");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "or", 2);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "repeat");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "repeat", 6);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "return");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "return", 6);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "then");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "then", 4);
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "until");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "until", 5);
				 return LEX_CORRECT;
                                }                                                                                                                                                                                                                                                                                                 
<onelist_INITIAL>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "while");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "while", 5);
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "nil", 3);
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "false", 5);
				 BEGIN(onelist_endStat1);						
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "true", 4);
				 BEGIN(onelist_endStat1);					
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "...", 3);
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '}');	
				 BEGIN(onelist_endStat1);
				 return INSERT_DELIMITER;
                                }
<onelist_INITIAL>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "end", 3);
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "break", 5);
				 BEGIN(onelist_endStat1);		
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 BEGIN(onelist_endStat2);		
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 BEGIN(onelist_endStat2);			
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ')');
				 flex_token->read_new_line = 0;	
				 BEGIN(onelist_endStat2);			
				 return LEX_CORRECT;
                                }    
<onelist_INITIAL>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ";");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ';');
				 return INSERT_DELIMITER;
                                }                                   
<onelist_INITIAL>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ':');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "::");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "::", 2);
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '.');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ',');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "[");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '[');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "{");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '{');
				 return INSERT_DELIMITER;
                                }                                   
<onelist_INITIAL>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '(');
				 return LEX_CORRECT;
                                } 
<onelist_INITIAL>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 return INSERT_DELIMITER;
                                }                                  
<onelist_INITIAL>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "+");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '+');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{UMINUS}		{flex_token->token = UMINUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "-");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '-');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "*");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '*');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "/");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '/');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "^");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '^');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "%");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '%');
				 return LEX_CORRECT;
                                }  
<onelist_INITIAL>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "..");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "..", 2);
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "<");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '<');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ">");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '>');
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "<=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "<=", 2);
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, ">=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ">=", 2);
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "==");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "==", 2);
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "~=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "~=", 2);
				 return LEX_CORRECT;
                                }                                   
<onelist_INITIAL>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "#");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '#');
				 return LEX_CORRECT;
                                }
<onelist_INITIAL>\[\[	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "[[", 2);
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_bracketedString);
                                }                                
<onelist_INITIAL>\]\]	{flex_token->semantic_value[0] = NULL;
				flex_token->bracket_delimiter = CLOSED_BRACKETS;
				 if (flex_token->first_closing_bracket == 1) {
				 	flex_token->first_closing_bracket = 0;
				 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 flex_token->read_new_line = 0;
				 BEGIN(onelist_endStat2);
				 return INSERT_DELIMITER_BRACKETED_STRING;
                                }                                    
<onelist_INITIAL>\]=+\]{SPACE}*{NEWLINE}	{int32_t i = 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 if(flex_token->num_chars >= flex_token->chunk_length)
				 	flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                              
<onelist_INITIAL>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->comment_type = -1;
				 flex_token->semantic_value[0] = NULL;
				 flex_token->error[0] = 0;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }	
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                
<onelist_INITIAL>\]=+\]			{
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 BEGIN(onelist_bracketedStringOrError);						 
						}
<onelist_INITIAL>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->state_before_comment = onelist_INITIAL;
				 BEGIN(onelist_multiComment);							 
				 return INSERT_COMMENT;
                                }
<onelist_INITIAL>--		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "--", 2);
				 flex_token->state_before_comment = onelist_INITIAL;
				 BEGIN(onelist_singleComment);
                                }
<onelist_INITIAL>\"		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_doubleString);
                                }
<onelist_INITIAL>\'		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_singleString);
                                }
<onelist_INITIAL>{SPACE}+		{
				if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);					
				}
<onelist_INITIAL>{NEWLINE}		{flex_token->semantic_value[0] = NULL;
				if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;
					return END_CHUNK;
				}
						}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\x[0-9a-fA-F]{2}		{
				if (flex_token->pending_bracketed_string_list != NULL){
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
					BEGIN(onelist_bracketedStringOrError);
				}
				else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
									}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\[0-9]{1,3}		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX){
						 	BEGIN(onelist_commentOrError);
					 		/* Free all the strings, since all of them are not valid.*/
						 	bracketed_string_node * temp = flex_token->pending_bracketed_string_list;
						 	do{
						 		free(temp);
						 		temp = temp->next; 
						 	}while (temp != NULL);
						 	flex_token->pending_bracketed_string_list = NULL;
						 	flex_token->top_pending_bracketed_string_list = NULL;
						 	flex_token->bracket_delimiter = ERROR_STRING_CHAR_MAX;
						 	return INSERT_DELIMITER_BRACKETED_STRING;
					} else{/*Append (char)result to string buffer*/
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], (char) result, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
						BEGIN(onelist_bracketedStringOrError);
					}
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
			}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
					BEGIN(onelist_bracketedStringOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\{NEWLINE}		{
				if (flex_token->pending_bracketed_string_list != NULL){		
					/*Append escaped character*/	
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
				}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\\\		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/	
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\\');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\\"		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\\'		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\a		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\a');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\b		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\b');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\f		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\f');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\n		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\r		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\r');
					BEGIN(onelist_bracketedStringOrError);
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\t		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\t');
					BEGIN(onelist_bracketedStringOrError);					
			} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
				}
<onelist_INITIAL,onelist_endStat1,onelist_endStat2,onelist_function1,onelist_function2>\\v		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\v');
					BEGIN(onelist_bracketedStringOrError);					
				} else if (flex_token->first_closing_bracket == 1)
					BEGIN(onelist_bracketedStringOrError);
				else
					BEGIN(onelist_commentOrError);
								}
<onelist_INITIAL>.				{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
				 BEGIN(onelist_bracketedStringOrError);		
						}              						
<onelist_endStat1>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ')');
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "::");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "::", 2);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "break", 5);
				 if(flex_token->read_new_line == 1)	{	
				 	flex_token->read_new_line = 0;	
					return ADD_SEMI;
				 }
				 else {
				 	flex_token->read_new_line = 0;
					return LEX_CORRECT;
				 }
                                }
<onelist_endStat1>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "goto");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "goto", 4);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "do");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "do", 2);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "while");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "while", 5);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "repeat");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "repeat", 6);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "if");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "if", 2);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "for");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "for", 3);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "local");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "local", 5);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{FUNCTION}	{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*9);
        		 strcpy(ch, "function");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "function", 8);
				 BEGIN(onelist_function1);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat1>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "and");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "and", 3);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "else");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "else", 4);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "elseif");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "elseif", 6);	
				 BEGIN(onelist_INITIAL);	
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "in");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "in", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "not");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "not", 3);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "or");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "or", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "return");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "return", 6);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "then");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "then", 4);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat1>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "until");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "until", 5);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "nil", 3);
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "false", 5);
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "true", 4);
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->read_new_line = 0;
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "...", 3);
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '}');
				 flex_token->read_new_line = 0;	
				 return INSERT_DELIMITER;
                                }
<onelist_endStat1>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "end", 3);
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 flex_token->read_new_line = 0;	
				 BEGIN(onelist_endStat2);			
				 return LEX_CORRECT;
                                }
<onelist_endStat1>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ')');
				 flex_token->read_new_line = 0;	
				 BEGIN(onelist_endStat2);			
				 return LEX_CORRECT;
                                }    
<onelist_endStat1>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ";");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ';');
				 BEGIN(onelist_INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<onelist_endStat1>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ':');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                                                   
<onelist_endStat1>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '.');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ',');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "[");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '[');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "{");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '{');
				 BEGIN(onelist_INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<onelist_endStat1>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 BEGIN(onelist_INITIAL);
				 return INSERT_DELIMITER;
                                }                                  
<onelist_endStat1>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "+");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '+');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                                                   
<onelist_endStat1>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "*");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '*');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "/");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '/');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "^");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '^');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "%");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '%');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }  
<onelist_endStat1>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "..");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "..", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "<");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '<');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ">");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '>');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "<=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "<=", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, ">=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ">=", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "==");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "==", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "~=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "~=", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat1>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "#");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '#');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                
<onelist_endStat1>{NAME}		{flex_token->token = NAME;
				/* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		strcpy(ch, yytext);
				flex_token->semantic_value[0] = ch;	
				////flex_token->semantic_value[0] = NULL;
				if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				if(flex_token->read_new_line == 1)	{
				 	flex_token->read_new_line = 0;
				 	BEGIN(onelist_endStat2);
					return ADD_SEMI;				 	
				}		
				else {//flex_token->read_new_line is 0
				 	BEGIN(onelist_endStat2);
					return LEX_CORRECT;				 	
				 }	
                                }                                
<onelist_endStat1>{MINUS}		{flex_token->token = MINUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "-");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '-');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }
<onelist_endStat1>\[\[	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "[[", 2);
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_bracketedString);
                                }                                
<onelist_endStat1>\]\]	{flex_token->semantic_value[0] = NULL;
				 flex_token->bracket_delimiter = CLOSED_BRACKETS;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 flex_token->read_new_line = 0;
				 BEGIN(onelist_endStat2);
				 return INSERT_DELIMITER_BRACKETED_STRING;
                                }                                    
<onelist_endStat1>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->comment_type = -1;
				 flex_token->semantic_value[0] = NULL;
				 flex_token->error[0] = 0;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 	}
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                
<onelist_endStat1>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                
<onelist_endStat1>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->state_before_comment = onelist_endStat1; 
				 BEGIN(onelist_multiComment);
				 return INSERT_COMMENT;
                                }
<onelist_endStat1>--		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "--", 2);
				 flex_token->state_before_comment = onelist_endStat1;
				 BEGIN(onelist_singleComment);
                    }                                                                
<onelist_endStat1>{SPACE}+		{
				if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
			}
<onelist_endStat1>{NEWLINE}	{flex_token->read_new_line = 1;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;
					return END_CHUNK;
				 }
			}
<onelist_endStat1>\"		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_doubleString);
                                }
<onelist_endStat1>\'		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_singleString);
                                }						
<onelist_endStat1>.				{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
						 BEGIN(onelist_bracketedStringOrError);						 
						 }
<onelist_endStat2>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "::");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "::", 2);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "break", 5);
				 if(flex_token->read_new_line == 1){	
				 	flex_token->read_new_line = 0;
				 	BEGIN(onelist_endStat1);		
					return ADD_SEMI;
				 }
				else {
					flex_token->read_new_line = 0;
					BEGIN(onelist_endStat1);
					return LEX_CORRECT;
				 }
                                }
<onelist_endStat2>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "goto");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "goto", 4);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "do");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "do", 2);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "while");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "while", 5);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "repeat");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "repeat", 6);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "if");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "if", 2);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "for");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "for", 3);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "local");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "local", 5);
				 BEGIN(onelist_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{FUNCTION}		{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*9);
        		 strcpy(ch, "function");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "function", 8);
				 BEGIN(onelist_function1);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<onelist_endStat2>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "and");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "and", 3);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "else");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "else", 4);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "elseif");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "elseif", 6);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "in");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "in", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "not");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "not", 3);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "or");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "or", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "return");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "return", 6);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "then");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "then", 4);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "until");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "until", 5);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "nil", 3);
				 flex_token->read_new_line = 0;
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "false", 5);
				 flex_token->read_new_line = 0;
				 BEGIN(onelist_endStat1);						
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "true", 4);
				 flex_token->read_new_line = 0;
				 BEGIN(onelist_endStat1);					
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->read_new_line = 0;
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "...", 3);
				 flex_token->read_new_line = 0;	
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '}');
				 flex_token->read_new_line = 0;	
				 BEGIN(onelist_endStat1);
				 return INSERT_DELIMITER;
                                }
<onelist_endStat2>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "end", 3);
				 flex_token->read_new_line = 0;	
				 BEGIN(onelist_endStat1);			
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<onelist_endStat2>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ')');
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }    
<onelist_endStat2>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ";");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ';');
				 BEGIN(onelist_INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<onelist_endStat2>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ':');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                                                    
<onelist_endStat2>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '.');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ',');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "[");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '[');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "{");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '{');
				 BEGIN(onelist_INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<onelist_endStat2>{LPAREN}		{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '(');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                } 
<onelist_endStat2>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 BEGIN(onelist_INITIAL);
				 return INSERT_DELIMITER;
                                }                                  
<onelist_endStat2>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "+");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '+');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                                                     
<onelist_endStat2>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "*");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '*');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "/");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '/');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "^");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '^');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "%");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '%');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }  
<onelist_endStat2>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "..");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "..", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "<");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '<');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ">");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '>');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "<=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "<=", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, ">=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ">=", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "==");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "==", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "~=");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "~=", 2);
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<onelist_endStat2>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "#");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '#');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                
<onelist_endStat2>{NAME}		{flex_token->token = NAME;
				/* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		strcpy(ch, yytext);
				flex_token->semantic_value[0] = ch;	
				////flex_token->semantic_value[0] = NULL;
				if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				if(flex_token->read_new_line == 1)	{
				 	flex_token->read_new_line = 0;		
					return ADD_SEMI;
				}
				else{//flex_token->read_new_line is 0
					return LEX_CORRECT;
				}
        }                                
<onelist_endStat2>{MINUS}		{flex_token->token = MINUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "-");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '-');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }
<onelist_endStat2>\[\[	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "[[", 2);
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_bracketedString);
                                }                                
<onelist_endStat2>\]\]	{flex_token->semantic_value[0] = NULL;
				 flex_token->bracket_delimiter = CLOSED_BRACKETS;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 flex_token->read_new_line = 0;
				 return INSERT_DELIMITER_BRACKETED_STRING;
                                }                                    
<onelist_endStat2>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->comment_type = -1;
				 flex_token->semantic_value[0] = NULL;
				 flex_token->error[0] = 0;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 	}
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                
<onelist_endStat2>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                
<onelist_endStat2>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->state_before_comment = onelist_endStat2;
				 BEGIN(onelist_multiComment);
				 return INSERT_COMMENT;
                                }
<onelist_endStat2>--		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "--", 2);
				 flex_token->state_before_comment = onelist_endStat2;
				 BEGIN(onelist_singleComment);
                                }                                                                
<onelist_endStat2>{SPACE}+		{
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
}
<onelist_endStat2>{NEWLINE}	{flex_token->read_new_line = 1;
						 flex_token->semantic_value[0] = NULL;
						 if (flex_token->pending_bracketed_string_list != NULL)
				 			append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
						 if(flex_token->num_chars >= flex_token->chunk_length) {
							flex_token->chunk_ended = 1;
							return END_CHUNK;
						 }
						}
<onelist_endStat2>\"		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_doubleString);
                                }
<onelist_endStat2>\'		{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
				 flex_token->current_buffer_length[0] = 0;
				 BEGIN(onelist_singleString);
                                }						
<onelist_endStat2>.				{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
						 BEGIN(onelist_bracketedStringOrError);						 
						 }
<onelist_singleComment>\]\]	{
				/*Identify previous state*/
				if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 	flex_token->insert_function = 1;
				/*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
				 	if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
					 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;	
				 	}
				 	if (flex_token->pending_bracketed_string_list != NULL) {
				 		/*If there are pending bracketed strings, terminate all of them.*/
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
					}
				 	flex_token->read_new_line = 0;
				 	/*Enter state with a double list of delimiters*/
				 	switch(flex_token->state_before_comment){
				 		case onelist_INITIAL:
				 			flex_token->before_comment[0] = initial_state;
				 			break;
				 		case onelist_endStat1:
				 			flex_token->before_comment[0] = endStat1_state;
				 			break;
				 		case onelist_endStat2:
				 			flex_token->before_comment[0] = endStat2_state;
				 			break;
				 		case onelist_function1:
				 			flex_token->before_comment[0] = function1_state;
				 			break;
				 		case onelist_function2:
				 			flex_token->before_comment[0] = function2_state;
				 			break;				
				 	}
				 	flex_token->state = SINGLE_COMMENT;
				 	BEGIN(twolists_endStat1);
				 	flex_token->bracket_delimiter = CLOSED_BRACKETS_IN_SINGLECOMMENT;
					return INSERT_DELIMITER_BRACKETED_STRING;
				}   
				/*otherwise it remains in state singleComment.*/
                           }						 
<onelist_singleComment>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->error[0] = 1;
				 flex_token->comment_type = -1;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 	}
				 /*Terminate all pending bracketed strings.*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }				 	
				 /*Identify previous state*/
				 if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 	flex_token->insert_function = 1;
				 /*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_SINGLEMULTICOMMENT;
                                }						 
<onelist_singleComment>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 /*Identify previous state*/
				 if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 	flex_token->insert_function = 1;
				 /*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_SINGLEMULTICOMMENT;
                                }
<onelist_singleComment>{NEWLINE}	{
				 flex_token->read_new_line = 1;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 BEGIN(flex_token->state_before_comment);
				 if(flex_token->num_chars >= flex_token->chunk_length) {
				 	if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
					 	flex_token->insert_function = 1;
					flex_token->chunk_ended = 1;
					return END_CHUNK;
				}
                                }
<onelist_singleComment,onelist_multiComment>\\x[0-9a-fA-F]{2}		{
				if (flex_token->pending_bracketed_string_list != NULL){
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
				}
						}
<onelist_singleComment,onelist_multiComment>\\[0-9]{1,3}		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX){
					 		/* Free all the strings, since all of them are not valid.*/
						 	bracketed_string_node * temp = flex_token->pending_bracketed_string_list;
						 	do{
						 		free(temp);
						 		temp = temp->next; 
						 	}while (temp != NULL);
						 	flex_token->pending_bracketed_string_list = NULL;
						 	flex_token->top_pending_bracketed_string_list = NULL;
						 	flex_token->bracket_delimiter = ERROR_STRING_CHAR_MAX;
						 	return INSERT_DELIMITER_BRACKETED_STRING;
					} else{/*Append (char)result*/
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
					}
				}
			}
<onelist_singleComment,onelist_multiComment>\\z{SPACE}*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<onelist_singleComment>\\z{SPACE}*{NEWLINE}({SPACE}|{NEWLINE})*	{/*Skips the following span of white-space characters, including line breaks.*/
				 if(flex_token->state_before_comment == onelist_endStat1 || flex_token->state_before_comment == onelist_endStat2)
				 	flex_token->read_new_line = 1;
				 BEGIN(flex_token->state_before_comment);
				 /*The chunk cannot end at this newline character, since the procedure that finds the cut points of the file skips 
				 newline and spaces precede by \z*/
                                }								
<onelist_multiComment>\\z{SPACE}*{NEWLINE}({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<onelist_singleComment>\\{NEWLINE}		{
				if (flex_token->pending_bracketed_string_list != NULL){		
					/*Append escaped character*/	
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				}
				if(flex_token->state_before_comment == onelist_endStat1 || flex_token->state_before_comment == onelist_endStat2)
				 	flex_token->read_new_line = 1;
				BEGIN(flex_token->state_before_comment);
								}
<onelist_multiComment>\\{NEWLINE}		{
				if (flex_token->pending_bracketed_string_list != NULL){		
					/*Append escaped character*/	
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				}
						}								
<onelist_singleComment,onelist_multiComment>\\\\		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/	
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\\');
				} 
								}
<onelist_singleComment,onelist_multiComment>\\\"		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
				}
								}
<onelist_singleComment,onelist_multiComment>\\\'		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
				}
								}
<onelist_singleComment,onelist_multiComment>\\a		{
				if (flex_token->pending_bracketed_string_list != NULL){	
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\a');
				}
								}
<onelist_singleComment,onelist_multiComment>\\b		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\b');
				} 
								}
<onelist_singleComment,onelist_multiComment>\\f		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\f');
				}
								}
<onelist_singleComment,onelist_multiComment>\\n		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				}
								}
<onelist_singleComment,onelist_multiComment>\\r		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\r');
				}
								}
<onelist_singleComment,onelist_multiComment>\\t		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\t');					
								}
							}
<onelist_singleComment,onelist_multiComment>\\v		{
			if (flex_token->pending_bracketed_string_list != NULL){
					/*Append escaped character*/
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\v');
				} 
								}
<onelist_singleComment>.			{
			if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
}
<onelist_multiComment>\]\]	{
				 /*Identify previous state*/
				 if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 	flex_token->insert_function = 1;
				 /*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL){
				 	if (flex_token->first_closing_bracket == 1){
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 	}
				 	if (flex_token->pending_bracketed_string_list != NULL) {
				 		/*If there are pending bracketed strings, terminate all of them.*/
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
				 	}
				 	flex_token->bracket_delimiter = CLOSED_BRACKETS_NOT_RBRACK_RBRACK;
				 	BEGIN(onelist_endStat1);
				 	return INSERT_DELIMITER_BRACKETED_STRING;
				 }
				 /*otherwise it remains in state multiComment.*/
                           } 
<onelist_multiComment>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->error[0] = 1;
				 flex_token->comment_type = -1;
				 /*Identify previous state.*/
				 if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 	flex_token->insert_function = 1;
				 	/*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 if (flex_token->first_closing_bracket == 1) {
				 	flex_token->first_closing_bracket = 0;
				 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                             
<onelist_multiComment>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 /*Identify previous state.*/
				 if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 	flex_token->insert_function = 1;
				 	/*!!da usare con l'ottimizzazione
				    if(flex_token->state_before_comment == endStat1 || flex_token->state_before_comment == endStat2)
				    	flex_token->read_new_line = 1;
				    BEGIN(flex_token->state_before_comment);*/
				 BEGIN(onelist_INITIAL);
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }
<onelist_multiComment>{NEWLINE}	{
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 if(flex_token->num_chars >= flex_token->chunk_length){
				 	if(flex_token->state_before_comment == onelist_function1 || flex_token->state_before_comment == onelist_function2)
				 		flex_token->insert_function = 1;
				 	flex_token->chunk_ended = 1;		
					return END_CHUNK_ERROR;				 	
				 }
                                }
<onelist_multiComment>.				{
			if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
}                                
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\x[0-9a-fA-F]{2}		{
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					/*Append (char)result to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], (char) result, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
									}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX){
						 BEGIN(onelist_commentOrError);	
						 if (flex_token->pending_bracketed_string_list != NULL){
						 	/* Free all the strings, since all of them are not valid.*/
						 	bracketed_string_node * temp = flex_token->pending_bracketed_string_list;
						 	do{
						 		free(temp);
						 		temp = temp->next; 
						 	}while (temp != NULL);
						 	flex_token->pending_bracketed_string_list = NULL;
						 	flex_token->top_pending_bracketed_string_list = NULL;
						 	flex_token->bracket_delimiter = ERROR_STRING_CHAR_MAX;
						 	return INSERT_DELIMITER_BRACKETED_STRING;
						 }
					}
					else{/*Append (char)result to string buffer*/
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], (char) result, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
						if (flex_token->pending_bracketed_string_list != NULL)
				 			append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
					}
								}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\{NEWLINE}		{
					/*Append character newline to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));		
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
								}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\\\		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\\', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\\');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\\"		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\"', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\\'		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\'', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));	
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');		
								}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\a		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\a', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\a');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\b		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\b', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\b');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\f		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\f', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\f');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\n		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\r		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\r', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\r');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\t		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\t', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\t');									
				 	}
<onelist_doubleString,onelist_singleString,onelist_bracketedString>\\v		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\v', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\v');									
				 	}
<onelist_doubleString,onelist_singleString>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->error[0] = 1;
				 flex_token->comment_type = -1;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->first_closing_bracket == 1) {
			 		flex_token->first_closing_bracket = 0;
			 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }									
<onelist_doubleString,onelist_singleString>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }
<onelist_doubleString>\"		{flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[0];
				 flex_token->string_buffer[0][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[0] + 1));
        		 strcpy(ch, flex_token->string_buffer[0]);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
				 flex_token->read_new_line = 0;				 
				 BEGIN(onelist_endStat1);
				 return LEX_CORRECT;
                        }
<onelist_doubleString,onelist_singleString>{NEWLINE}	{
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 BEGIN(onelist_bracketedStringOrError);						 
				 if(flex_token->num_chars >= flex_token->chunk_length) {
				 		flex_token->chunk_ended = 1;	
						return END_CHUNK_ERROR;
					}
			}
<onelist_doubleString>\]\]	{
				/*Append chars to string buffer*/
				flex_token->string_buffer[0] = concat_to_buffer(flex_token->string_buffer[0], "]]", 2, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));				 
				if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
			 		if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
					 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;	
				 	}
				 	if (flex_token->pending_bracketed_string_list != NULL) {
				 		/*If there are pending bracketed strings, terminate all of them.*/
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
				 	}
			 		flex_token->bracket_delimiter = CLOSED_BRACKETS_IN_STRING;
			 		flex_token->state = DOUBLE_STRING;
			 		BEGIN(twolists_endStat1);
			 		return INSERT_DELIMITER_BRACKETED_STRING;
				}
				/*otherwise it remains in state onelist_doubleString.*/
             }
<onelist_doubleString>[^\\\]\"\n\r]+			{
						 /*Append char to string buffer*/
						flex_token->string_buffer[0] = concat_to_buffer(flex_token->string_buffer[0], yytext, yyleng, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
						if (flex_token->pending_bracketed_string_list != NULL)
					 		concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);				
						} 
<onelist_doubleString><<EOF>>		{
				flex_token->chunk_ended = 1;	
				return END_CHUNK_ERROR;
			}								                               								                        
<onelist_doubleString>.			{
						 /*Append char to string buffer*/
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], yytext[0],&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
						if (flex_token->pending_bracketed_string_list != NULL)
					 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);				
						}
<onelist_singleString>\'		{flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[0];
				 flex_token->string_buffer[0][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[0] + 1));
        		 strcpy(ch, flex_token->string_buffer[0]);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
					 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
				 flex_token->read_new_line = 0;				 
				 BEGIN(onelist_endStat1);
				 return LEX_CORRECT;
                        }
<onelist_singleString>\]\]	{
				/*Append chars to string buffer*/
				flex_token->string_buffer[0] = concat_to_buffer(flex_token->string_buffer[0], "]]", 2, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));
				if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
			 		if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
					 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;	
				 	}
				 	if (flex_token->pending_bracketed_string_list != NULL) {
				 		/*If there are pending bracketed strings, terminate all of them.*/
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
				 	}
			 		flex_token->bracket_delimiter = CLOSED_BRACKETS_IN_STRING;
			 		flex_token->state = SINGLE_STRING;
			 		BEGIN(twolists_endStat1);
			 		return INSERT_DELIMITER_BRACKETED_STRING;
				}
				/*otherwise it remains in state onelist_singleString.*/
            }	
<onelist_singleString>[^\\\]\'\n\r]+			{
						 /*Append char to string buffer*/
						flex_token->string_buffer[0] = concat_to_buffer(flex_token->string_buffer[0], yytext, yyleng, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
						if (flex_token->pending_bracketed_string_list != NULL)
					 		concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);				
						} 
<onelist_singleString><<EOF>>		{
				flex_token->chunk_ended = 1;	
				return END_CHUNK_ERROR;
			}						                               					                       
<onelist_singleString>.			{/*Append char to string buffer*/
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], yytext[0], &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));
						if (flex_token->pending_bracketed_string_list != NULL)
					 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);	
						}
<onelist_bracketedString>\]\]	{flex_token->token = STRING;
				int32_t length = flex_token->current_buffer_length[0];
				flex_token->string_buffer[0][length] = '\0';
				/* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[0] + 1));
        		strcpy(ch, flex_token->string_buffer[0]);
				flex_token->semantic_value[0] = ch;	
				////flex_token->semantic_value[0] = NULL;
				flex_token->read_new_line = 0;
				BEGIN(onelist_endStat1);
				if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
					if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
					}
					if (flex_token->pending_bracketed_string_list != NULL) {
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
					}
					return INSERT_STRING_WITH_BRACKETS;
				}
				return LEX_CORRECT;
            }									
<onelist_bracketedString>\]\]{SPACE}*{NEWLINE}	{flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[0];
				 flex_token->string_buffer[0][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[0] + 1));
        		 strcpy(ch, flex_token->string_buffer[0]);
				 flex_token->semantic_value[0] = ch;	
				 // flex_token->semantic_value[0] = NULL;
				 flex_token->comment_type = -1;
				 flex_token->error[0] = 1;
				 if (flex_token->first_closing_bracket == 1) {
			 		flex_token->first_closing_bracket = 0;
			 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 flex_token->insert_single_comment_in_list = 2;
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_STRING_MULTICOMMENT;
                                }									
<onelist_bracketedString>\]=+\]{SPACE}*{NEWLINE}	{
				 /*It cannot determine whether the brackets denote the end of a comment or they still belong to the text of the token STRING.*/
				 int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 int32_t j = i - 1;
			 	 flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], ']', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
			 	 while (j > 0) {
			 		flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '=', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
			 		j--;
			 	 }
			 	 flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], ']', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
				 flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]),  &(flex_token->allocated_buffer_size[0]));
				 flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[0];
				 flex_token->string_buffer[0][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[0] + 1));
        		 strcpy(ch, flex_token->string_buffer[0]);
				 flex_token->semantic_value[0] = ch;	
				 // flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 flex_token->insert_single_comment_in_list = 2;
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 else
				 	flex_token->append_pending_bracketed_string = 1;
				 return INSERT_STRING_MULTICOMMENT;
                                }
<onelist_bracketedString>{NEWLINE}	{
				flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));
				if (flex_token->pending_bracketed_string_list != NULL)
			 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				if (flex_token->num_chars >= flex_token->chunk_length) {
				 	flex_token->token = STRING; 	
					int32_t length = flex_token->current_buffer_length[0];
					flex_token->string_buffer[0][length] = '\0';
					/* Semantic value stub. */
					char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[0] + 1));
	        		strcpy(ch, flex_token->string_buffer[0]);
					flex_token->semantic_value[0] = ch;	
					// flex_token->semantic_value[0] = NULL;	
					flex_token->chunk_ended = 1;						
					return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
				}
}                               
<onelist_bracketedString>[^\\\]\n\r]+			{
						 /*Append char to string buffer*/
						flex_token->string_buffer[0] = concat_to_buffer(flex_token->string_buffer[0], yytext, yyleng, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
						if (flex_token->pending_bracketed_string_list != NULL)
					 		concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);				
						} 
<onelist_bracketedString><<EOF>>		{
				flex_token->chunk_ended = 1;	
				return END_CHUNK_ERROR;
			}						                               					                        
<onelist_bracketedString>.			{ /*Append char to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], yytext[0],&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));						
					if (flex_token->pending_bracketed_string_list != NULL)
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
						}
<onelist_bracketedStringOrError>\\x[0-9a-fA-F]{2}		{
					/*State onelist_bracketedStringOrError is reached by the other states onelist reading characters as \t, \x[0-9a-fA-F]{2}, et cetera. 
					If the input text read in state onelist_bracketedStringOrError cannot belong to a string, then it goes to state onelist_commentOrError*/
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					if (flex_token->pending_bracketed_string_list != NULL)
					 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
									}
<onelist_bracketedStringOrError>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX){
						 BEGIN(onelist_commentOrError);
						 if (flex_token->pending_bracketed_string_list != NULL){
					 		/* Free all the strings, since all of them are not valid.*/
						 	bracketed_string_node * temp = flex_token->pending_bracketed_string_list;
						 	do{
						 		free(temp);
						 		temp = temp->next; 
						 	}while (temp != NULL);
						 	flex_token->pending_bracketed_string_list = NULL;
					 		flex_token->top_pending_bracketed_string_list = NULL;
					 		flex_token->bracket_delimiter = ERROR_STRING_CHAR_MAX;
						 	return INSERT_DELIMITER_BRACKETED_STRING;
					 	}
					}						 
					else{					 
						/*Append (char)result to strings*/
						if (flex_token->pending_bracketed_string_list != NULL)
							append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, (char) result);
					}
				}
<onelist_bracketedStringOrError>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<onelist_bracketedStringOrError>\\{NEWLINE}		{
					/*Append escaped character*/	
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
								}
<onelist_bracketedStringOrError>\\\\		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)	
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\\');
								}
<onelist_bracketedStringOrError>\\\"		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\"');
								}
<onelist_bracketedStringOrError>\\\'		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\'');
								}
<onelist_bracketedStringOrError>\\a		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\a');
								}
<onelist_bracketedStringOrError>\\b		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\b');
								}
<onelist_bracketedStringOrError>\\f		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\f');
								}
<onelist_bracketedStringOrError>\\n		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
								}
<onelist_bracketedStringOrError>\\r		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\r');
								}
<onelist_bracketedStringOrError>\\t		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\t');					
								}
<onelist_bracketedStringOrError>\\v		{
					/*Append escaped character*/
					if (flex_token->pending_bracketed_string_list != NULL)
						append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\v');
								}
<onelist_bracketedStringOrError>\]\]	{
				 flex_token->read_new_line = 0;
		 		 flex_token->bracket_delimiter = CLOSED_BRACKETS_NOT_RBRACK_RBRACK;
		 		 //flex_token->string_or_error = 1; /*States that the two brackets cannot be interpreted as RBRACK RBRACK.*/
		 		 if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
					 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
					 }
					 if (flex_token->pending_bracketed_string_list != NULL) {
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
					 }
					 BEGIN(onelist_endStat1);
			 		 return INSERT_DELIMITER_BRACKETED_STRING;
				 }
				 else {
				 	BEGIN(onelist_commentOrError);
				 }
                                }									
<onelist_bracketedStringOrError>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 flex_token->error[0] = 1;
				 if (flex_token->first_closing_bracket == 1) {
			 		flex_token->first_closing_bracket = 0;
			 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }									
<onelist_bracketedStringOrError>\]=+\]{SPACE}*{NEWLINE}	{
				 int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }
<onelist_bracketedStringOrError>[^\\\]\n\r]+			{
						if (flex_token->pending_bracketed_string_list != NULL)
					 		concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);				
						} 
<onelist_bracketedStringOrError>{NEWLINE}	{
				/*Append char to string buffer*/
				if (flex_token->pending_bracketed_string_list != NULL)
					append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
				if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;	
					return END_CHUNK_ERROR;
				}
			} 						 
<onelist_bracketedStringOrError><<EOF>>		{
				flex_token->chunk_ended = 1;	
				return END_CHUNK_ERROR;
			}						                              					                        
<onelist_bracketedStringOrError>.			{
						/*Append char to string buffer*/
						if (flex_token->pending_bracketed_string_list != NULL)
							append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
						}	                       					
<onelist_commentOrError>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 /*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->semantic_value[0] = NULL;
				 flex_token->error[0] = 1; /*The two brackets cannot be interpreted as the end of a bracketed string, since the string is not valid
				 							and the the two brackets cannot be interpreted as RBRACK RBRACK.*/
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }						
<onelist_commentOrError>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }
<onelist_commentOrError>{NEWLINE}	{
				flex_token->semantic_value[0] = NULL;
				if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;	
					return END_CHUNK_ERROR;
				}
			}                        
<onelist_commentOrError><<EOF>>		{
				flex_token->semantic_value[0] = NULL;
				flex_token->chunk_ended = 1;	
				return END_CHUNK_ERROR;
			}						
<onelist_commentOrError>.			{}
<onelist_function1>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 return LEX_CORRECT;
                        }
<onelist_function1>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '.');
				 return LEX_CORRECT;
                                } 
<onelist_function1>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ':');
				 return LEX_CORRECT;
                                }                                                         
<onelist_function1>{LPAREN}		{flex_token->token = LPARENFUNC;
				 /*Return LPARENFUNC instead of LPAREN*/
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '(');
				 BEGIN(onelist_function2);
				 return LEX_CORRECT;
                                }                                                                     
<onelist_function1>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->state_before_comment = onelist_function1;
				 BEGIN(onelist_multiComment);							 
				 return INSERT_COMMENT;
                                }
<onelist_function1>--	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "--", 2);
				 flex_token->state_before_comment = onelist_function1;
				 BEGIN(onelist_singleComment);
                                }
<onelist_function1>\]\]	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
			 		if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
					 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;	
				 	}
				 	if (flex_token->pending_bracketed_string_list != NULL) {
				 		/*If there are pending bracketed strings, terminate all of them.*/
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
					}
			 		flex_token->read_new_line = 0;
			 		flex_token->bracket_delimiter = CLOSED_BRACKETS;
					BEGIN(onelist_endStat2);
					return INSERT_DELIMITER_BRACKETED_STRING;
				 }
				 BEGIN(onelist_commentOrError);	 
                        }                                    
<onelist_function1>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->comment_type = -1;
				 flex_token->error[0] = 1;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
				 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                          
<onelist_function1>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                     
<onelist_function1>{SPACE}+		{
			if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
}
<onelist_function1>{NEWLINE}	{
				if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;
					flex_token->insert_function = 1;
					return END_CHUNK;
				}
						}
<onelist_function1>.	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
				 BEGIN(onelist_bracketedStringOrError);
				}                                                                                                                
<onelist_function2>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 return LEX_CORRECT;
                        }
<onelist_function2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "...", 3);
				 return LEX_CORRECT;
                                }
<onelist_function2>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ',');
				 return LEX_CORRECT;
                                }                                                                                         
<onelist_function2>{RPAREN}		{flex_token->token = RPARENFUNC;
				 /*Return RPARENFUNC instead of RPAREN*/
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[0] = ch;	
				 ////flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ')');
				 BEGIN(onelist_INITIAL);
				 return LEX_CORRECT;
                                }                                            
<onelist_function2>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
				 flex_token->state_before_comment = onelist_function2;
				 BEGIN(onelist_multiComment);							 
				 return INSERT_COMMENT;
                                }
<onelist_function2>--	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, "--", 2);
				 flex_token->state_before_comment = onelist_function2;
				 BEGIN(onelist_singleComment);
                                }
<onelist_function2>\]\]	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->first_closing_bracket == 1 || flex_token->pending_bracketed_string_list != NULL) {
			 		if (flex_token->first_closing_bracket == 1) {
				 		flex_token->first_closing_bracket = 0;
					 	flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;	
				 	}
				 	if (flex_token->pending_bracketed_string_list != NULL) {
				 		/*If there are pending bracketed strings, terminate all of them.*/
					 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
					 	flex_token->pending_bracketed_string_list = NULL;
					 	flex_token->top_pending_bracketed_string_list = NULL;
				 	}
			 		flex_token->read_new_line = 0;
			 		flex_token->bracket_delimiter = CLOSED_BRACKETS;
					BEGIN(onelist_endStat2);
					return INSERT_DELIMITER_BRACKETED_STRING;
				 }
				 BEGIN(onelist_commentOrError);	 
                        }                                    
<onelist_function2>\]\]{SPACE}*{NEWLINE}	{/*Type of ending multiline comment is negative and starts from -1*/
				 flex_token->comment_type = -1;
				 flex_token->error[0] = 1;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->first_closing_bracket == 1) {
			 		flex_token->first_closing_bracket = 0;
			 		flex_token->first_closing_bracket_pos = flex_token->num_chars - yyleng;
				 }
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	terminate_all_pending_string(flex_token->pending_bracketed_string_list);
				 	flex_token->pending_bracketed_string_list = NULL;
				 	flex_token->top_pending_bracketed_string_list = NULL;
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                   
<onelist_function2>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL) {
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	i--;
				 	while (i > 0) {
				 		append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '=');
				 		i--;
				 	}
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, ']');
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				 }
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_COMMENT;
                                }                                 
<onelist_function2>{SPACE}+		{
			if (flex_token->pending_bracketed_string_list != NULL)
				concat_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext, yyleng);
}
<onelist_function2>{NEWLINE}	{
				if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, '\n');
				if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;
					flex_token->insert_function = 1;
					return END_CHUNK;
				}
						}
<onelist_function2>.	{flex_token->semantic_value[0] = NULL;
				 if (flex_token->pending_bracketed_string_list != NULL)
				 	append_to_all_pending_bracketed_string(flex_token->pending_bracketed_string_list, yytext[0]);
				 BEGIN(onelist_bracketedStringOrError);
				}		
<twolists_INITIAL>{LPAREN}	{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '(', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "::");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
				 	flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "::", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 flex_token->semantic_value[flex_token->second_state] = ch;
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;	
				 if (flex_token->state != SINGLE_COMMENT)
				 	flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "break", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;	
				 flex_token->read_new_line = 0;	
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "goto");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "goto", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "do");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "do", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "while");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "while", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "repeat");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "repeat", 6, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "if");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "if", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "for");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "for", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "local");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "local", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{FUNCTION}	{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*9);
        		 strcpy(ch, "function");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "function", 8, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_function1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "and");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "and", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "else");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "else", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "elseif");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "elseif", 6, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "in");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "in", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "not");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "not", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "or");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "or", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "return");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "return", 6, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "then");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "then", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_INITIAL>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "until");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "until", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "nil", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "false", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "true", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "...", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '}', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return INSERT_DELIMITER;
                                }
<twolists_INITIAL>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "end", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat2);
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ')', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat2);
				 return LEX_CORRECT;
                                }    
<twolists_INITIAL>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ";");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ';', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return INSERT_DELIMITER;
                                }                                   
<twolists_INITIAL>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ':', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                                                   
<twolists_INITIAL>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '.', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ',', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "[");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '[', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "{");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '{', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return INSERT_DELIMITER;
                                }                                   
<twolists_INITIAL>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return INSERT_DELIMITER;
                                }                                  
<twolists_INITIAL>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "+");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '+', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_INITIAL>{UMINUS}		{flex_token->token = UMINUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "-");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '-', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                                                                                   
<twolists_INITIAL>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "*");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '*', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "/");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '/', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "^");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '^', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "%");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '%', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }  
<twolists_INITIAL>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "..");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "..", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "<");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '<', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ">");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '>', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "<=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "<=", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, ">=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], ">=", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "==");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "==", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "~=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "~=", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                   
<twolists_INITIAL>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "#");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '#', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }                                
<twolists_INITIAL>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat2);
				 return LEX_CORRECT;				 		
                                }                                
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\[\[	{flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT){
					flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "[[", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 	flex_token->current_buffer_length[flex_token->second_state] = 0;
				 	BEGIN(twolists_bracketedString);
				 }
				 else{//state is SINGLE_COMMENT
				 	flex_token->current_buffer_length[flex_token->second_state] = 0;
				 	int8_t swap = flex_token->first_state;
				 	flex_token->first_state = flex_token->second_state;
				 	flex_token->second_state = swap;
				 	flex_token->state = BRACKETED_STRING;
				 	BEGIN(twolists_singleComment);
				 }
                                } 
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\]\]		{
				 flex_token->read_new_line = 0;	
				 if (flex_token->state == BRACKETED_STRING){
				 	flex_token->token = STRING;
				 	int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					flex_token->string_buffer[flex_token->first_state][length] = '\0';
				    /* Semantic value stub. */
				 	char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
        		 	strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
				 	flex_token->semantic_value[flex_token->first_state] = ch;	
				 	////flex_token->semantic_value[flex_token->first_state] = NULL;
				 	flex_token->error[flex_token->first_state] = 0;
				 	flex_token->error[flex_token->second_state] = 0;
				 	flex_token->insert_token_in_list = flex_token->first_state;	
				 	BEGIN(onelist_endStat2);
				 	flex_token->double_list_ended = 1;
				 	return END_DOUBLE_LIST_STRING_RBRACK_RBRACK;
				 }
				 else if (flex_token->state != SINGLE_COMMENT){//state is doubleString or singleString
				 	flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "]]", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				}
				flex_token->insert_token_in_list = flex_token->second_state;	
				BEGIN(twolists_endStat2);
				return LEX_CORRECT_INSERT_RBRACK_RBRACK;
                        }                                
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 flex_token->double_list_ended = 1;	
				 flex_token->error[flex_token->second_state] = 0;
				 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
				 if (flex_token->state == BRACKETED_STRING){
				 	 flex_token->token = STRING;
				 	 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
 					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->insert_single_comment_in_list = 2;
					 flex_token->error[flex_token->first_state] = 1;
					 BEGIN(onelist_INITIAL);
					 return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state == SINGLE_COMMENT){
				 	flex_token->semantic_value[flex_token->first_state] = NULL;
				 	flex_token->insert_single_comment_in_list = flex_token->first_state;
				 	flex_token->insert_token_in_list = 2;
				 	flex_token->error[flex_token->first_state] = 1;
				 	BEGIN(onelist_INITIAL);
					return INSERT_SINGLEMULTICOMMENT;
				 }
				 else{//state is doubleString or singleString
					 flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 flex_token->error[flex_token->first_state] = 1;
					 BEGIN(onelist_INITIAL);
					 return INSERT_COMMENT;
				 }
                            }                                                                                                                                                                            
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->double_list_ended = 1;
				 if(flex_token->state == BRACKETED_STRING){
				 	flex_token->insert_single_comment_in_list = 2;
					flex_token->token = STRING;
					i--;
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 	while (i > 0) {
				 		flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 		i--;
				 	}
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state])); 
					int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					/* Semantic value stub. */
					char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					flex_token->semantic_value[flex_token->first_state] = ch;	
					// flex_token->semantic_value[flex_token->first_state] = NULL;							
					flex_token->insert_token_in_list = flex_token->first_state;
					if(flex_token->num_chars >= flex_token->chunk_length) {
						flex_token->chunk_ended = 1;
						return INSERT_STRING_MULTICOMMENT;
					}
					else
				 		flex_token->append_pending_bracketed_string = 1;
					BEGIN(onelist_INITIAL);
					return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//doubleString or singleString are the value of state
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_COMMENT;
					}
				else{//state is SINGLE_COMMENT
					flex_token->semantic_value[flex_token->first_state] = NULL;
				 	flex_token->insert_single_comment_in_list = flex_token->first_state;
				 	flex_token->insert_token_in_list = 2;
				 	BEGIN(onelist_INITIAL);
					if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					return INSERT_SINGLEMULTICOMMENT;
				}	
                                }                                                                    
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 // flex_token->semantic_value[flex_token->first_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state; /*Insert the symbol of beginning comment in this delimiter list.*/
				 BEGIN(twolists_multiComment);
				 return INSERT_COMMENT;
                                }
<twolists_INITIAL>--		{//flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "--", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->before_comment[flex_token->second_state] = initial_state;
				 BEGIN(twolists_singleComment);
                    }
<twolists_endStat1>--		{//flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "--", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->before_comment[flex_token->second_state] = endStat1_state;
				 BEGIN(twolists_singleComment);
                    }
<twolists_endStat2>--		{//flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "--", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->before_comment[flex_token->second_state] = endStat2_state;
				 BEGIN(twolists_singleComment);
                    }                                                                                                        
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>{SPACE}+		{
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
}
<twolists_INITIAL>{NEWLINE}	{flex_token->read_new_line = 1;
				 if (flex_token->state == BRACKETED_STRING){
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					if(flex_token->num_chars >= flex_token->chunk_length) {
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 0;
					 	flex_token->token = STRING;
						int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
						/* Semantic value stub. */
						char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
		        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
						flex_token->semantic_value[flex_token->first_state] = ch;	
						////flex_token->semantic_value[flex_token->first_state] = NULL;							
						flex_token->insert_token_in_list = flex_token->first_state;
						flex_token->double_list_ended = 1;
						flex_token->chunk_ended = 1;
						return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
				 	}
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
				 	flex_token->error[flex_token->first_state] = 1;
					flex_token->error[flex_token->second_state] = 0;
					// flex_token->semantic_value[flex_token->first_state] = NULL;
					flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
					if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					BEGIN(onelist_INITIAL);
					flex_token->double_list_ended = 1;
					flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
					return INSERT_DELIMITER_BRACKETED_STRING;
				 }
				 else{//state is SINGLE_COMMENT
				 	flex_token->error[flex_token->first_state] = 0;
				 	flex_token->error[flex_token->second_state] = 0;
				 	//flex_token->semantic_value[flex_token->first_state] = NULL;
					flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
					if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					BEGIN(onelist_INITIAL);
					flex_token->double_list_ended = 1;
					flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
					return INSERT_DELIMITER_BRACKETED_STRING;
				 }
						}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\x[0-9a-fA-F]{2}		{
					if (flex_token->state != SINGLE_COMMENT){
						/*Compute the decimal value of the hexadecimal number*/
						int32_t result = hex2dec(yytext[2]);
						result = (result << 4) + hex2dec(yytext[3]);
						/*Append (char)result to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					}
					BEGIN(twolists_commentOrError);
									}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\[0-9]{1,3}		{
					if (flex_token->state != SINGLE_COMMENT){
						/*Compute the decimal value of the number*/
						int32_t result = 0, i = 1;
						while(i < yyleng)
						{
							result = 10*result + yytext[i] - '0';
							i++;
						}
						/*Maximal system value of unsigned char (e.g. 255)*/
						if(result > UCHAR_MAX) {
							 BEGIN(onelist_commentOrError);
							 flex_token->error[flex_token->first_state] = 1;
							 flex_token->error[flex_token->second_state] = 1;
							 flex_token->double_list_ended = 1;
							 flex_token->insert_token_in_list = 2;
							 // flex_token->semantic_value[flex_token->first_state] = NULL;
							 flex_token->bracket_delimiter = END_DOUBLE_LIST;							 
							 return INSERT_DELIMITER_BRACKETED_STRING;
						}
						else{					 
							/*Append (char)result to string buffer*/
							flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));	
							BEGIN(twolists_commentOrError);
						}	 						 
					}
					else
						BEGIN(twolists_commentOrError);			
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\z{SPACE}*	{
					/*Skips the following span of white-space characters, including line breaks.*/
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\\z{SPACE}*{NEWLINE}({SPACE}|{NEWLINE})*	{
					if (flex_token->state == SINGLE_COMMENT){
						flex_token->read_new_line = 1;
						// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 1;
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
					/*Skips the following span of white-space characters, including line breaks.*/
					BEGIN(twolists_commentOrError);
								}
<twolists_function1,twolists_function2>\\z{SPACE}*{NEWLINE}({SPACE}|{NEWLINE})*	{
					if (flex_token->state == SINGLE_COMMENT){
						flex_token->read_new_line = 1;
						// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 1;
						flex_token->insert_token_in_list = 2;
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
					/*Skips the following span of white-space characters, including line breaks.*/
					BEGIN(twolists_commentOrError);
								}																															
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\\{NEWLINE}		{
					if (flex_token->state == SINGLE_COMMENT){
						flex_token->read_new_line = 1;
						// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 1;
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
					/*Append character newline to string buffer*/
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);			
								}
<twolists_function1,twolists_function2>\\{NEWLINE}		{
					if (flex_token->state == SINGLE_COMMENT){
						flex_token->read_new_line = 1;
						// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 1;
						flex_token->insert_token_in_list = 2;
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
					/*Append character newline to string buffer*/
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);			
								}								
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\\\		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\\', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);			
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\\"		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\"', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);			
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\\'		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\'', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\a		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\a', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\b		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\b',&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\f		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\f',&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\n		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n',&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\r		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\r',&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\t		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\t',&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2,twolists_function1,twolists_function2>\\v		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\v',&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					BEGIN(twolists_commentOrError);
								}
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\"		{
				if (flex_token->state == DOUBLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->current_buffer_length[flex_token->first_state] = 0;	 
					 BEGIN(twolists_endStat1);
					 return LEX_CORRECT;
				}
				else{/*Append char to buffer*/
				 	 if (flex_token->state != SINGLE_COMMENT)
					 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 flex_token->current_buffer_length[flex_token->second_state] = 0;
					 int8_t swap = flex_token->first_state; //go to the state doubleString_state
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;
					 if (flex_token->state == SINGLE_STRING)
					 	BEGIN(twolists_singleString);
					 else if (flex_token->state == BRACKETED_STRING)
					 	BEGIN(twolists_bracketedString);
					 else{ //state is SINGLE_COMMENT
					 	BEGIN(twolists_singleComment);
					 }
					 flex_token->state = DOUBLE_STRING;	 
				}
            }
<twolists_INITIAL,twolists_endStat1,twolists_endStat2>\'		{
				if (flex_token->state == SINGLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->current_buffer_length[flex_token->first_state] = 0;	 
					 BEGIN(twolists_endStat1);
					 return LEX_CORRECT;
				}
				else if (flex_token->state == DOUBLE_STRING){/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 flex_token->current_buffer_length[flex_token->second_state] = 0;
					 BEGIN(twolists_singleString);
				}
				else if (flex_token->state == BRACKETED_STRING){/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 flex_token->current_buffer_length[flex_token->second_state] = 0;
				 	 int8_t swap = flex_token->first_state; //go to the state singleString_state
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;
					 flex_token->state = SINGLE_STRING;
				 	 BEGIN(twolists_bracketedString);
				 	}
				else{//state is SINGLE_COMMENT
					 flex_token->current_buffer_length[flex_token->second_state] = 0;
				 	 int8_t swap = flex_token->first_state; //go to the state singleString_state
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;
					 flex_token->state = SINGLE_STRING;
				 	 BEGIN(twolists_singleComment);
				} 	
                        }  
<twolists_INITIAL><<EOF>>		{
				 flex_token->error[flex_token->second_state] = 0;
				 if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString or bracketedString
				 	flex_token->error[flex_token->first_state] = 1;
				 }
				 else
				 	flex_token->error[flex_token->first_state] = 0; //state is SINGLE_COMMENT
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}
<twolists_INITIAL>.				{/*Append char to buffer*/
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0],&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 BEGIN(twolists_commentOrError);
				}
<twolists_endStat1>{LPAREN}	{flex_token->token = LPAREN;//only endStat1
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '(', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{COLON2}		{flex_token->token = COLON2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "::");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "::", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 flex_token->semantic_value[flex_token->second_state] = ch;
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "break", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 if(flex_token->read_new_line == 1)	{	
				 	flex_token->read_new_line = 0;	
					return ADD_SEMI;
				 }
				 else {
				 	flex_token->read_new_line = 0;
					return LEX_CORRECT;
				 }
                                }
<twolists_endStat1,twolists_endStat2>{GOTO}		{flex_token->token = GOTO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "goto");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "goto", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{DO}		{flex_token->token = DO;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "do");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "do", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{WHILE}		{flex_token->token = WHILE;
				 /* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "while");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "while", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{REPEAT}		{flex_token->token = REPEAT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "repeat");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "repeat", 6, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{IF}		{flex_token->token = IF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "if");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "if", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{FOR}		{flex_token->token = FOR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "for");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "for", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{LOCAL}		{flex_token->token = LOCAL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "local");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "local", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{FUNCTION}	{flex_token->token = FUNCTION;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*9);
        		 strcpy(ch, "function");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "function", 8, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_function1);
				 if(flex_token->read_new_line == 1)			
					return ADD_SEMI;
				else
					return LEX_CORRECT;
                                }
<twolists_endStat1,twolists_endStat2>{AND}		{flex_token->token = AND;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "and");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "and", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{ELSE}		{flex_token->token = ELSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "else");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "else", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{ELSEIF}		{flex_token->token = ELSEIF;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "elseif");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "elseif", 6, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);	
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{IN}		{flex_token->token = IN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "in");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "in", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{NOT}		{flex_token->token = NOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "not");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "not", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{OR}		{flex_token->token = OR;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "or");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "or", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{RETURN}		{flex_token->token = RETURN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*7);
        		 strcpy(ch, "return");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "return", 6, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{THEN}		{flex_token->token = THEN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "then");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "then", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat1,twolists_endStat2>{UNTIL}		{flex_token->token = UNTIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "until");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "until", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "nil", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "false", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "true", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "...", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '}', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return INSERT_DELIMITER;
                                }
<twolists_endStat1>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "end", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat2);
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ')', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat2);
				 return LEX_CORRECT;
                                }    
<twolists_endStat1,twolists_endStat2>{SEMI}		{flex_token->token = SEMI;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ";");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ';', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<twolists_endStat1,twolists_endStat2>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ':', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                                                   
<twolists_endStat1,twolists_endStat2>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '.', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ',', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{LBRACK}		{flex_token->token = LBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "[");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '[', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{LBRACE}		{flex_token->token = LBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "{");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '{', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return INSERT_DELIMITER;
                                }                                   
<twolists_endStat1,twolists_endStat2>{XEQ}		{flex_token->token = XEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return INSERT_DELIMITER;
                                }                                  
<twolists_endStat1,twolists_endStat2>{PLUS}		{flex_token->token = PLUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "+");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '+', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                                                   
<twolists_endStat1,twolists_endStat2>{ASTERISK}		{flex_token->token = ASTERISK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "*");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '*', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{DIVIDE}		{flex_token->token = DIVIDE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "/");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '/', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{CARET}		{flex_token->token = CARET;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "^");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '^', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{PERCENT}		{flex_token->token = PERCENT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "%");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '%', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }  
<twolists_endStat1,twolists_endStat2>{DOT2}		{flex_token->token = DOT2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "..");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "..", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{LT}		{flex_token->token = LT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "<");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '<', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{GT}		{flex_token->token = GT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ">");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '>', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{LTEQ}		{flex_token->token = LTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "<=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "<=", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{GTEQ}		{flex_token->token = GTEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, ">=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], ">=", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{EQ2}		{flex_token->token = EQ2;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "==");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "==", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{NEQ}		{flex_token->token = NEQ;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*3);
        		 strcpy(ch, "~=");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "~=", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                   
<twolists_endStat1,twolists_endStat2>{SHARP}		{flex_token->token = SHARP;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "#");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '#', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }                                
<twolists_endStat1>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->insert_token_in_list = flex_token->second_state;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 BEGIN(twolists_endStat2);
				 if(flex_token->read_new_line == 1)	{
				 	flex_token->read_new_line = 0;
					return ADD_SEMI;				 	
				 }		
				 else
					return LEX_CORRECT;				 	
                                }                                
<twolists_endStat1,twolists_endStat2>{MINUS}		{flex_token->token = MINUS;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "-");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '-', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }
<twolists_endStat1>{NEWLINE}	{flex_token->read_new_line = 1;
						 if (flex_token->state == BRACKETED_STRING){
						 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
							if(flex_token->num_chars >= flex_token->chunk_length) {
								flex_token->error[flex_token->first_state] = 0;
								flex_token->error[flex_token->second_state] = 0;
							 	flex_token->token = STRING;
								int32_t length = flex_token->current_buffer_length[flex_token->first_state];
								flex_token->string_buffer[flex_token->first_state][length] = '\0';
								/* Semantic value stub. */
								char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
				        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
								flex_token->semantic_value[flex_token->first_state] = ch;	
								////flex_token->semantic_value[flex_token->first_state] = NULL;							
								flex_token->insert_token_in_list = flex_token->first_state;
								flex_token->double_list_ended = 1;
								flex_token->chunk_ended = 1;
								return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
						 	}
						 }
						 else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
						 	flex_token->error[flex_token->first_state] = 1;
							flex_token->error[flex_token->second_state] = 0;
							// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_endStat1);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;
						 }
						 else{//state is SINGLE_COMMENT
						 	flex_token->error[flex_token->first_state] = 0;
						 	flex_token->error[flex_token->second_state] = 0;
						 	// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_endStat1);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;
						 }
						}
<twolists_endStat1><<EOF>>		{
				 flex_token->error[flex_token->second_state] = 0;
				 if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString or bracketedString
				 	flex_token->error[flex_token->first_state] = 1;
				 }
				 else
				 	flex_token->error[flex_token->first_state] = 0; //state is SINGLE_COMMENT
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}													                                
<twolists_endStat1>.				{/*Append char to buffer*/
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0],&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 BEGIN(twolists_commentOrError);
				}						
<twolists_endStat2>{NEWLINE}	{flex_token->read_new_line = 1;
						 if (flex_token->state == BRACKETED_STRING){
						 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
							if(flex_token->num_chars >= flex_token->chunk_length) {
								flex_token->error[flex_token->first_state] = 0;
								flex_token->error[flex_token->second_state] = 0;
							 	flex_token->token = STRING;
								int32_t length = flex_token->current_buffer_length[flex_token->first_state];
								flex_token->string_buffer[flex_token->first_state][length] = '\0';
								/* Semantic value stub. */
								char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
				        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
								flex_token->semantic_value[flex_token->first_state] = ch;	
								////flex_token->semantic_value[flex_token->first_state] = NULL;							
								flex_token->insert_token_in_list = flex_token->first_state;
								flex_token->double_list_ended = 1;
								flex_token->chunk_ended = 1;
								return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
						 	}
						 }
						 else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
						 	flex_token->error[flex_token->first_state] = 1;
							flex_token->error[flex_token->second_state] = 0;
							// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_endStat2);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;
						 }
						 else{//state is SINGLE_COMMENT
						 	flex_token->error[flex_token->first_state] = 0;
						 	flex_token->error[flex_token->second_state] = 0;
						 	// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_endStat2);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;

						 }
						}						                                							
<twolists_endStat2>{BREAK}		{flex_token->token = BREAK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "break");
				 flex_token->semantic_value[flex_token->second_state] = ch;
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "break", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 if(flex_token->read_new_line == 1)	{	
				 	flex_token->read_new_line = 0;	
				 	BEGIN(twolists_endStat1);
					return ADD_SEMI;
				 }
				 else {
				 	flex_token->read_new_line = 0;
				 	BEGIN(twolists_endStat1);
					return LEX_CORRECT;
				 }
                                }
<twolists_endStat2>{NIL}		{flex_token->token = NIL;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "nil");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "nil", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{FALSE}		{flex_token->token = FALSE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*6);
        		 strcpy(ch, "false");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "false", 5, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{TRUE}		{flex_token->token = TRUE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*5);
        		 strcpy(ch, "true");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "true", 4, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{NUMBER}		{flex_token->token = NUMBER;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "...", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{RBRACE}		{flex_token->token = RBRACE;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "}");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '}', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return INSERT_DELIMITER;
                                }
<twolists_endStat2>{END}		{flex_token->token = END;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "end");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "end", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_endStat1);
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{RBRACK}		{flex_token->token = RBRACK;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "]");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_endStat2>{RPAREN}		{flex_token->token = RPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ')', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                } 
<twolists_endStat2>{LPAREN}	{flex_token->token = LPAREN;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '(', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                } 
<twolists_endStat2>{NAME}		{flex_token->token = NAME;
				/* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		strcpy(ch, yytext);
				flex_token->semantic_value[flex_token->second_state] = ch;	
				////flex_token->semantic_value[flex_token->second_state] = NULL;
				flex_token->insert_token_in_list = flex_token->second_state;
				if (flex_token->state != SINGLE_COMMENT)
					 	flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				if(flex_token->read_new_line == 1)	{
				 	flex_token->read_new_line = 0;
					return ADD_SEMI;				 	
				}		
				else 
					return LEX_CORRECT;				 	
            }
<twolists_endStat2><<EOF>>		{
				 flex_token->error[flex_token->second_state] = 0;
				 if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString or bracketedString
				 	flex_token->error[flex_token->first_state] = 1;
				 }
				 else
				 	flex_token->error[flex_token->first_state] = 0; //state is SINGLE_COMMENT
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}              
<twolists_endStat2>.		{/*Append char to buffer*/
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0], &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 BEGIN(twolists_commentOrError);
				}	                                                                                                  
<twolists_singleComment>\\[0-9]{1,3}		{
					if (flex_token->state != SINGLE_COMMENT){
						/*Compute the decimal value of the number*/
						int32_t result = 0, i = 1;
						while(i < yyleng)
						{
							result = 10*result + yytext[i] - '0';
							i++;
						}
						/*Maximal system value of unsigned char (e.g. 255)*/
						if(result > UCHAR_MAX){
							 flex_token->insert_token_in_list = flex_token->first_state;
							 int8_t swap = flex_token->first_state;
							 flex_token->first_state = flex_token->second_state;
							 flex_token->second_state = swap;
							 flex_token->state = SINGLE_COMMENT;
							 flex_token->bracket_delimiter = ERROR_STRING_CHAR_MAX;
							 BEGIN(twolists_commentOrError);	
						 	 return INSERT_DELIMITER_BRACKETED_STRING;
							 }
						else{	 					 
							/*Append (char)result to string buffer*/
							flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						}
					}
								}
<twolists_singleComment>\"	  {
				if (flex_token->state == DOUBLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->state = SINGLE_COMMENT;	 
					 BEGIN(twolists_endStat1);
					 return LEX_CORRECT;
				}
				else if (flex_token->state == SINGLE_STRING || flex_token->state == BRACKETED_STRING) {/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				}
                        }    
<twolists_singleComment>\'	  {
				if (flex_token->state == SINGLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->state = SINGLE_COMMENT;	 
					 BEGIN(twolists_endStat1);
					 return LEX_CORRECT;
				}
				else if (flex_token->state == DOUBLE_STRING || flex_token->state == BRACKETED_STRING){/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				}
                        }                   
<twolists_singleComment>\]\]	  {
				if (flex_token->state == BRACKETED_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->state = SINGLE_COMMENT;	 
					 BEGIN(twolists_endStat1);
					 return LEX_CORRECT;
				}
				else if (flex_token->state == DOUBLE_STRING || flex_token->state == SINGLE_STRING) {/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "]]", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				}
                        } 
<twolists_singleComment>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 flex_token->double_list_ended = 1;
				 flex_token->error[flex_token->second_state] = 1;
				 if (flex_token->state == BRACKETED_STRING){
				 	 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->insert_single_comment_in_list = flex_token->second_state;
					 flex_token->error[flex_token->first_state] = 1;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = flex_token->second_state;
					 flex_token->error[flex_token->first_state] = 1;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;
				}
				else{//state is SINGLE_COMMENT
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = 3; //insert singlecomment in both delimiters'lists
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;

				}
                            }                                                                                                                                                
<twolists_singleComment>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->double_list_ended = 1;
				 if(flex_token->state == BRACKETED_STRING){
					 flex_token->token = STRING;
					 i--;
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 	 while (i > 0) {
				 		flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 		i--;
				 	 }
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state])); 
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 // flex_token->semantic_value[flex_token->first_state] = NULL;							
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->insert_single_comment_in_list = flex_token->second_state;
					 if(flex_token->num_chars >= flex_token->chunk_length) {
						flex_token->chunk_ended = 1;
						return INSERT_STRING_MULTICOMMENT;
					 }
					 else
				 		flex_token->append_pending_bracketed_string = 1;
					BEGIN(onelist_INITIAL);
					return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//doubleString or singleString are the value of state
				 	 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 BEGIN(onelist_INITIAL);
					 flex_token->insert_single_comment_in_list = flex_token->second_state;
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;
				}
				else{//state is SINGLE_COMMENT
					// flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = 3; //insert singlecommentin both delimiters'lists
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;

				}
                                }
<twolists_singleComment>{SPACE}+		{
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
}						
<twolists_singleComment>{NEWLINE}	{flex_token->read_new_line = 1;
						 if (flex_token->state == BRACKETED_STRING){
						 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
							switch(flex_token->before_comment[flex_token->second_state])
							{
								case initial_state:
								case function1_state:
								case function2_state:
									BEGIN(twolists_INITIAL);
									break;
								case endStat1_state:
									BEGIN(twolists_endStat1);
									break;
								case endStat2_state:
									BEGIN(twolists_endStat2);
									break;	
							}
							if(flex_token->num_chars >= flex_token->chunk_length) {
								flex_token->error[flex_token->first_state] = 0;
								flex_token->error[flex_token->second_state] = 0;
							 	flex_token->token = STRING;
							 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								int32_t length = flex_token->current_buffer_length[flex_token->first_state];
								flex_token->string_buffer[flex_token->first_state][length] = '\0';
								/* Semantic value stub. */
								char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
				        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
								flex_token->semantic_value[flex_token->first_state] = ch;	
								////flex_token->semantic_value[flex_token->first_state] = NULL;							
								flex_token->insert_token_in_list = flex_token->first_state;
								flex_token->double_list_ended = 1;
								flex_token->chunk_ended = 1;
								return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
						 	}
						 }
						 else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
						 	flex_token->error[flex_token->first_state] = 1;
							flex_token->error[flex_token->second_state] = 0;
							// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_INITIAL);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;
						 }
						 else{//state is SINGLE_COMMENT
						 	flex_token->error[flex_token->first_state] = 0;
						 	flex_token->error[flex_token->second_state] = 0;
						 	// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_INITIAL);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;

						 }
						}											
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\x[0-9a-fA-F]{2}		{
					if (flex_token->state != SINGLE_COMMENT){
						/*Compute the decimal value of the hexadecimal number*/
						int32_t result = hex2dec(yytext[2]);
						result = (result << 4) + hex2dec(yytext[3]);
						/*Append (char)result to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					}
						}
<twolists_multiComment,twolists_commentOrError>\\[0-9]{1,3}		{
					if (flex_token->state != SINGLE_COMMENT){
						/*Compute the decimal value of the number*/
						int32_t result = 0, i = 1;
						while(i < yyleng)
						{
							result = 10*result + yytext[i] - '0';
							i++;
						}
						/*Maximal system value of unsigned char (e.g. 255)*/
						if(result > UCHAR_MAX){
							 BEGIN(onelist_commentOrError);	
							 flex_token->error[flex_token->first_state] = 1;
							 flex_token->error[flex_token->second_state] = 1;
							 flex_token->double_list_ended = 1;
							 flex_token->insert_token_in_list = 2;
							 flex_token->bracket_delimiter = END_DOUBLE_LIST;							 
							 return INSERT_DELIMITER_BRACKETED_STRING;
							 /*Note that it does not insert ERROR_PENDING_BRACKET: it suffices to insert END_DOUBLE_LIST with error == 1*/
						}
						else{					 
						/*Append (char)result to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));	
						}
					}
								}
<twolists_singleComment>\\z{SPACE}*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}
<twolists_singleComment>\\z{SPACE}*{NEWLINE}({SPACE}|{NEWLINE})*	{
					if (flex_token->state != SINGLE_COMMENT){
						/*Skips the following span of white-space characters, including line breaks.*/
						/*Singleline comment ends here.*/
						switch(flex_token->before_comment[flex_token->second_state]){
										case initial_state:
										case function1_state:
										case function2_state:
											BEGIN(twolists_INITIAL);
											break;
										case endStat1_state:
											BEGIN(twolists_endStat1);
											break;
										case endStat2_state:
											BEGIN(twolists_endStat2);
											break;	
						}
					}
					else{//state is SINGLE_COMMENT
						flex_token->read_new_line = 1;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 0;
					 	// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
				}
<twolists_multiComment,twolists_commentOrError>\\z{SPACE}*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}								
<twolists_multiComment,twolists_commentOrError>\\z{SPACE}*{NEWLINE}({SPACE}|{NEWLINE})*	{
					if (flex_token->state == SINGLE_COMMENT){
						flex_token->read_new_line = 1;
						// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 1;
						flex_token->insert_token_in_list = 2;
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
					/*otherwise skips the following span of white-space characters, including line breaks.*/
								}												
<twolists_singleComment>\\{NEWLINE}		{
					if (flex_token->state != SINGLE_COMMENT){
						/*Append character newline to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						/*Singleline comment ends here.*/
						switch(flex_token->before_comment[flex_token->second_state]){
										case initial_state:
										case function1_state:
										case function2_state:
											BEGIN(twolists_INITIAL);
											break;
										case endStat1_state:
											BEGIN(twolists_endStat1);
											break;
										case endStat2_state:
											BEGIN(twolists_endStat2);
											break;	
						}
					}
					else{//state is SINGLE_COMMENT
						flex_token->read_new_line = 1;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 0;
					 	// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
								}																								
<twolists_multiComment,twolists_commentOrError>\\{NEWLINE}		{
					if (flex_token->state != SINGLE_COMMENT) {
					/*Append character newline to string buffer*/
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					}
					else{//state is SINGLE_COMMENT
						flex_token->read_new_line = 1;
						flex_token->error[flex_token->first_state] = 0;
						flex_token->error[flex_token->second_state] = 1;
					 	// flex_token->semantic_value[flex_token->first_state] = NULL;
						flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
						BEGIN(onelist_INITIAL);
						flex_token->double_list_ended = 1;
						flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
					}
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\\\		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\\', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\\"		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\\'		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\a		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\a', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\b		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\b',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\f		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\f',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\n		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\r		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\r',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\t		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\t',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>\\v		{
					/*Append escaped character to string buffer*/
					if (flex_token->state != SINGLE_COMMENT)
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\v',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								}								
<twolists_multiComment,twolists_commentOrError>\"		{
				if (flex_token->state == DOUBLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->error[flex_token->first_state] = 0;
					 flex_token->error[flex_token->second_state] = 1;	
					 BEGIN(onelist_endStat1);
					 flex_token->double_list_ended = 1;
					 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;
				}
				else if (flex_token->state != SINGLE_COMMENT) {/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				}	
                        }
<twolists_multiComment,twolists_commentOrError>\'		{
				if (flex_token->state == SINGLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->error[flex_token->first_state] = 0;
					 flex_token->error[flex_token->second_state] = 1;	
					 BEGIN(onelist_endStat1);
					 flex_token->double_list_ended = 1;
					 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;
				}
				else if (flex_token->state != SINGLE_COMMENT) {/*Append char to buffer*/
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				}	 
                        } 
<twolists_multiComment,twolists_commentOrError>\]\]		{
				if (flex_token->state == BRACKETED_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->error[flex_token->first_state] = 0;
					 flex_token->error[flex_token->second_state] = 1;	
					 BEGIN(onelist_endStat1);
					 flex_token->double_list_ended = 1;
					 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;
				}
				else if (flex_token->state != SINGLE_COMMENT) {
					flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
                     }
                        }
<twolists_multiComment,twolists_commentOrError>{NEWLINE}	{
						flex_token->read_new_line = 1;
						if (flex_token->state == BRACKETED_STRING){
						 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
							if(flex_token->num_chars >= flex_token->chunk_length) {
								flex_token->error[flex_token->first_state] = 0;
								flex_token->error[flex_token->second_state] = 1;
							 	flex_token->token = STRING;
								int32_t length = flex_token->current_buffer_length[flex_token->first_state];
								flex_token->string_buffer[flex_token->first_state][length] = '\0';
								/* Semantic value stub. */
								char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
				        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
								flex_token->semantic_value[flex_token->first_state] = ch;	
								////flex_token->semantic_value[flex_token->first_state] = NULL;							
								flex_token->insert_token_in_list = flex_token->first_state;
								flex_token->double_list_ended = 1;
								flex_token->chunk_ended = 1;
								return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
						 	}
						}
						else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
							 flex_token->error[flex_token->first_state] = 1;
							 flex_token->error[flex_token->second_state] = 1;
							 // flex_token->semantic_value[flex_token->first_state] = NULL;
							 flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							 if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							 BEGIN(onelist_commentOrError);
							 flex_token->double_list_ended = 1;
							 flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							 return INSERT_DELIMITER_BRACKETED_STRING;
						}
						else{//state is SINGLE_COMMENT
						 	flex_token->error[flex_token->first_state] = 0;
						 	flex_token->error[flex_token->second_state] = 1;
						 	// flex_token->semantic_value[flex_token->first_state] = NULL;
							flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_INITIAL);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
					 		return INSERT_DELIMITER_BRACKETED_STRING;
						 }
							}
<twolists_multiComment>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 flex_token->double_list_ended = 1;
				 flex_token->error[flex_token->second_state] = 1;
				 if (flex_token->state == BRACKETED_STRING){
				 	 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->insert_single_comment_in_list = 2;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 2;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_COMMENT;
				}
				else{//state is SINGLE_COMMENT
					// flex_token->semantic_value[flex_token->first_state] = NULL;
					flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = flex_token->first_state; //insert singlecommentin the delimiters'list of flex_token->first_state
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;
				}
                            }
<twolists_commentOrError>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 flex_token->double_list_ended = 1;
				 flex_token->error[flex_token->second_state] = 1;
				 if (flex_token->state == BRACKETED_STRING){
				 	 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->insert_single_comment_in_list = 2;					 
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT){//state is doubleString or singleString
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 2;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_COMMENT;
				}
				else{//state is SINGLE_COMMENT
					// flex_token->semantic_value[flex_token->first_state] = NULL;
					flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = flex_token->first_state; //insert singlecomment in the delimiters'list of flex_token->first_state
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;
				}
                            }                                                                                                                                                                                  
<twolists_multiComment>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->double_list_ended = 1;
				 if(flex_token->state == BRACKETED_STRING){
					flex_token->token = STRING;
					i--;
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 	while (i > 0) {
				 		flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 		i--;
				 	}
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state])); 
					int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					flex_token->string_buffer[flex_token->first_state][length] = '\0';
					/* Semantic value stub. */
					char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					flex_token->semantic_value[flex_token->first_state] = ch;	
					// flex_token->semantic_value[flex_token->first_state] = NULL;							
					flex_token->insert_token_in_list = flex_token->first_state;
					flex_token->insert_single_comment_in_list = 2;
					if(flex_token->num_chars >= flex_token->chunk_length) {
							flex_token->chunk_ended = 1;
							return INSERT_STRING_MULTICOMMENT;
					}
					else
				 		flex_token->append_pending_bracketed_string = 1;
					BEGIN(onelist_INITIAL);
					return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//doubleString or singleString are the value of state
				 	 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_COMMENT;
					}
				 else{//state is SINGLE_COMMENT
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = flex_token->first_state; //insert singlecomment in the delimiters'list of flex_token->first_state
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;
				 }
                                }
<twolists_commentOrError>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 flex_token->double_list_ended = 1;
				 if(flex_token->state == BRACKETED_STRING){
					flex_token->token = STRING;
					i--;
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 	while (i > 0) {
				 		flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 		i--;
				 	}
				 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state])); 
					
					int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					flex_token->string_buffer[flex_token->first_state][length] = '\0';
					/* Semantic value stub. */
					char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					flex_token->semantic_value[flex_token->first_state] = ch;	
					// flex_token->semantic_value[flex_token->first_state] = NULL;							
					flex_token->insert_token_in_list = flex_token->first_state;
					flex_token->insert_single_comment_in_list = 2;
					if(flex_token->num_chars >= flex_token->chunk_length) {
								flex_token->chunk_ended = 1;
								return INSERT_STRING_MULTICOMMENT;
					}
					else
				 		flex_token->append_pending_bracketed_string = 1;
					BEGIN(onelist_INITIAL);
					return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state != SINGLE_COMMENT) {//doubleString or singleString are the value of state
				 	 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_COMMENT;
					}
				 else{//state is SINGLE_COMMENT
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 flex_token->insert_single_comment_in_list = flex_token->first_state; //insert singlecomment in the delimiters'list of flex_token->first_state
					 BEGIN(onelist_INITIAL);
					 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
					 return INSERT_SINGLEMULTICOMMENT;
				 }	
                                }                                
<twolists_multiComment,twolists_commentOrError>{SPACE}+		{
				if (flex_token->state != SINGLE_COMMENT)
					flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
			}
<twolists_singleComment><<EOF>>		{
				 flex_token->error[flex_token->second_state] = 0;
				 if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString or bracketedString
				 	flex_token->error[flex_token->first_state] = 1;
				 }
				 else
				 	flex_token->error[flex_token->first_state] = 0; //state is SINGLE_COMMENT
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}						
<twolists_multiComment,twolists_commentOrError><<EOF>>		{
				 flex_token->error[flex_token->second_state] = 1;
				 if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString or bracketedString
				 	flex_token->error[flex_token->first_state] = 1;
				 }
				 else
				 	flex_token->error[flex_token->first_state] = 0; //state is SINGLE_COMMENT
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}									                                    
<twolists_singleComment,twolists_multiComment,twolists_commentOrError>. {/*Append character to string buffer*/
				if (flex_token->state != SINGLE_COMMENT)
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0], &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
			} 
<twolists_singleString,twolists_bracketedString>\\x[0-9a-fA-F]{2}		{
						/*Compute the decimal value of the hexadecimal number*/
						int32_t result = hex2dec(yytext[2]);
						result = (result << 4) + hex2dec(yytext[3]);
						/*Append (char)result to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], (char) result, &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
									}
<twolists_singleString,twolists_bracketedString>\\[0-9]{1,3}		{
						/*Compute the decimal value of the number*/
						int32_t result = 0, i = 1;
						while(i < yyleng)
						{
							result = 10*result + yytext[i] - '0';
							i++;
						}
						/*Maximal system value of unsigned char (e.g. 255)*/
						if(result > UCHAR_MAX) {
							 BEGIN(onelist_commentOrError);	
							 flex_token->error[flex_token->first_state] = 1;
							 flex_token->error[flex_token->second_state] = 1;
							 flex_token->double_list_ended = 1;
							 flex_token->insert_token_in_list = 2;
							 flex_token->bracket_delimiter = END_DOUBLE_LIST;							 
							 return INSERT_DELIMITER_BRACKETED_STRING;
						}
						else{	 					 
							/*Append (char)result to string buffer*/
							flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], (char) result, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
							flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], (char) result, &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
						}					
								}
<twolists_singleString,twolists_bracketedString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
								}																												
<twolists_singleString,twolists_bracketedString>\\{NEWLINE}		{
					/*Append character newline to string buffer*/
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\n', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));			
								}												
<twolists_singleString,twolists_bracketedString>\\\\		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\\', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\\', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));			
								}
<twolists_singleString,twolists_bracketedString>\\\"		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\"', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));			
								}
<twolists_singleString,twolists_bracketedString>\\\'		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\'', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
								}
<twolists_singleString,twolists_bracketedString>\\a		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\a', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\a', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
							}
<twolists_singleString,twolists_bracketedString>\\b		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\b',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\b', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
							}
<twolists_singleString,twolists_bracketedString>\\f		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\f',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\f', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
								}
<twolists_singleString,twolists_bracketedString>\\n		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\n', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
								}
<twolists_singleString,twolists_bracketedString>\\r		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\r',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\r', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
								}
<twolists_singleString,twolists_bracketedString>\\t		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\t',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\t', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
								}
<twolists_singleString,twolists_bracketedString>\\v		{
						/*Append escaped character to string buffer*/
						flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\v',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\v', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
								}
<twolists_singleString>\"		{/*state is necessarily DOUBLE_STRING*/
				 flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
				 flex_token->string_buffer[flex_token->first_state][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
				 flex_token->semantic_value[flex_token->first_state] = ch;	
				 ////flex_token->semantic_value[flex_token->first_state] = NULL;
				 flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\"', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				 flex_token->read_new_line = 0;	
				 flex_token->insert_token_in_list = flex_token->first_state;
				 int8_t swap = flex_token->first_state;
				 flex_token->first_state = flex_token->second_state;
				 flex_token->second_state = swap;	
				 flex_token->current_buffer_length[flex_token->first_state] = 0;	
				 flex_token->state = SINGLE_STRING; 
				 BEGIN(twolists_endStat1);// go to state twolists_singleString_endStat1
				 return LEX_CORRECT;
                        }
<twolists_singleString>\'		{/*state is necessarily DOUBLE_STRING*/
				 flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[flex_token->second_state];
				 flex_token->string_buffer[flex_token->second_state][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->second_state] + 1));
        		 strcpy(ch, flex_token->string_buffer[flex_token->second_state]);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->read_new_line = 0;	
				 flex_token->insert_token_in_list = flex_token->second_state;	
				 flex_token->current_buffer_length[flex_token->second_state] = 0;	
				 BEGIN(twolists_endStat1);// go to state twolists_doubleString_endStat1 
				 return LEX_CORRECT;
                        }                         
<twolists_singleString>\]=*\]{SPACE}*{NEWLINE}	{/*state is necessarily DOUBLE_STRING*/
				 int32_t i= 1;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)--;
				 	i++;
				 }
				 /*Type of ending multiline comment is negative and starts from -1*/
				 (flex_token->comment_type)--;
				 // flex_token->semantic_value[flex_token->first_state] = NULL;
				 flex_token->insert_token_in_list = 2;
				 BEGIN(onelist_INITIAL);
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 flex_token->double_list_ended = 1;	
				 return INSERT_COMMENT;
                                }                                
<twolists_singleString>{NEWLINE}	{/*state is necessarily DOUBLE_STRING*/
						 flex_token->read_new_line = 1;
						 flex_token->error[flex_token->first_state] = 1;
						 flex_token->error[flex_token->second_state] = 1;
						 // flex_token->semantic_value[flex_token->first_state] = NULL;
						 flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
						 if(flex_token->num_chars >= flex_token->chunk_length)
							flex_token->chunk_ended = 1;
						 BEGIN(onelist_commentOrError);
						 flex_token->double_list_ended = 1;
						 flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
						return INSERT_DELIMITER_BRACKETED_STRING;
						}		
<twolists_singleString>[^\\\]\"\'\n\r]+				{/*state is necessarily DOUBLE_STRING*/
				 /*Concatenate chars to buffer*/
				 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->string_buffer[flex_token->second_state] = concat_to_buffer(flex_token->string_buffer[flex_token->second_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				}
<twolists_singleString><<EOF>>		{//state is necessarily doubleString
				 flex_token->error[flex_token->second_state] = 1;
			 	 flex_token->error[flex_token->first_state] = 1;
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}											                                               						
<twolists_singleString>.				{/*state is necessarily DOUBLE_STRING*/
				 /*Append char to buffer*/
				 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0], &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], yytext[0], &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				}
<twolists_bracketedString>\"		{/*state is necessarily DOUBLE_STRING or SINGLE_STRING or BRACKETED_STRING*/
				if (flex_token->state == DOUBLE_STRING){
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\"', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->current_buffer_length[flex_token->first_state] = 0;
					 flex_token->state = BRACKETED_STRING;
					 BEGIN(twolists_endStat1);// go to state twolists_bracketedString_endStat1
					 return LEX_CORRECT;
				}
				else{//state is necessarily singleString or bracketedString
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\"', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				}
			}
<twolists_bracketedString>\'		{/*state is necessarily DOUBLE_STRING or SINGLE_STRING or BRACKETED_STRING*/
				if (flex_token->state == SINGLE_STRING){
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
		   			 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\'', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
					 flex_token->read_new_line = 0;	
					 flex_token->insert_token_in_list = flex_token->first_state;
					 int8_t swap = flex_token->first_state;
					 flex_token->first_state = flex_token->second_state;
					 flex_token->second_state = swap;	
					 flex_token->current_buffer_length[flex_token->first_state] = 0;
					 flex_token->state = BRACKETED_STRING;	 
					 BEGIN(twolists_endStat1);
					 return LEX_CORRECT;
				}
				else{//state is necessarily doubleString or bracketedString
					flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\'', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				}                       
			}				
<twolists_bracketedString>\]\]		{/*state is necessarily DOUBLE_STRING or SINGLE_STRING or BRACKETED_STRING*/
				 flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[flex_token->second_state];
				 flex_token->string_buffer[flex_token->second_state][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->second_state] + 1));
        		 strcpy(ch, flex_token->string_buffer[flex_token->second_state]);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 flex_token->read_new_line = 0;	
				 if (flex_token->state != BRACKETED_STRING){/*state is necessarily DOUBLE_STRING or SINGLE_STRING*/
				 	 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 flex_token->insert_token_in_list = flex_token->second_state;	
					 BEGIN(twolists_endStat1); 
					 return LEX_CORRECT;				 	
				 }
				 else{/*state is BRACKETED_STRING*/
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch1 = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch1, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch1;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 0;
					 flex_token->error[flex_token->second_state] = 0;
					 flex_token->insert_token_in_list = 3;
					 BEGIN(onelist_endStat1);	
					 flex_token->double_list_ended = 1;
					 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;
				 }
                        }                        
<twolists_bracketedString>\]\]{SPACE}*{NEWLINE}	{/*state is necessarily DOUBLE_STRING or SINGLE_STRING or BRACKETED_STRING*/
				 flex_token->token = STRING;
				 int32_t length = flex_token->current_buffer_length[flex_token->second_state];
				 flex_token->string_buffer[flex_token->second_state][length] = '\0';
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->second_state] + 1));
        		 strcpy(ch, flex_token->string_buffer[flex_token->second_state]);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 flex_token->semantic_value[flex_token->second_state] = NULL;	
				 flex_token->error[flex_token->second_state] = 1;
				 if (flex_token->state != BRACKETED_STRING){
					 flex_token->error[flex_token->first_state] = 1; //flex_token->first_state is doubleString or singleString
				 	 flex_token->insert_token_in_list = flex_token->second_state;
				 }
				 else{
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch1 = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch1, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch1;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->error[flex_token->first_state] = 1;
					 flex_token->insert_token_in_list = 3;
				 }
				 BEGIN(onelist_INITIAL);
				 flex_token->double_list_ended = 1;	
				 flex_token->insert_single_comment_in_list = 2;			 	
				 if(flex_token->num_chars >= flex_token->chunk_length)
					flex_token->chunk_ended = 1;
				 return INSERT_STRING_MULTICOMMENT;
                                } 
<twolists_bracketedString>\]=+\]{SPACE}*{NEWLINE}	{int32_t i= 1;
				flex_token->comment_type = 0;
				while(yytext[i] == '=')
				{
				 	(flex_token->comment_type)--;
				 	i++;
				}
				/*Type of ending multiline comment is negative and starts from -1*/
				(flex_token->comment_type)--;
				// flex_token->error[flex_token->first_state] = 1;
				// flex_token->error[flex_token->second_state] = 1;
				flex_token->token = STRING;
				i--;
				int32_t j = i;
			 	flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], ']', &(flex_token->current_buffer_length[flex_token->second_state]),  &(flex_token->allocated_buffer_size[flex_token->second_state]));
			 	while (i > 0) {
			 		flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '=', &(flex_token->current_buffer_length[flex_token->second_state]),  &(flex_token->allocated_buffer_size[flex_token->second_state]));
			 		i--;
			 	}
			 	flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], ']', &(flex_token->current_buffer_length[flex_token->second_state]),  &(flex_token->allocated_buffer_size[flex_token->second_state]));
				flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\n', &(flex_token->current_buffer_length[flex_token->second_state]),  &(flex_token->allocated_buffer_size[flex_token->second_state])); 	
				int32_t length = flex_token->current_buffer_length[flex_token->second_state];
				flex_token->string_buffer[flex_token->second_state][length] = '\0';
				/* Semantic value stub. */
				char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->second_state] + 1));
        		strcpy(ch, flex_token->string_buffer[flex_token->second_state]);
				flex_token->semantic_value[flex_token->second_state] = ch;	
				// flex_token->semantic_value[flex_token->second_state] = NULL;							
				if (flex_token->state != BRACKETED_STRING){
				 	 flex_token->insert_token_in_list = flex_token->second_state;
				}
				else{
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 	 while (j > 0) {
				 		flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '=', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 		j--;
				 	 }
				 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ']', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]),  &(flex_token->allocated_buffer_size[flex_token->first_state])); 		
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch1 = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch1, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch1;	
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 3;
				}
				flex_token->double_list_ended = 1;
				flex_token->insert_single_comment_in_list = 2;
				if(flex_token->num_chars >= flex_token->chunk_length) {
					flex_token->chunk_ended = 1;
					return INSERT_STRING_MULTICOMMENT;
				}
				else
				 	flex_token->append_pending_bracketed_string = 1;
				BEGIN(onelist_INITIAL);
				return INSERT_STRING_MULTICOMMENT;
                                }                                
<twolists_bracketedString>{NEWLINE}	{//state is DOUBLE_STRING or SINGLE_STRING or BRACKETED_STRING
						 flex_token->error[flex_token->second_state] = 0;
						 if(flex_token->num_chars >= flex_token->chunk_length) {
						 	flex_token->token = STRING;
						 	flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\n', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
							int32_t length = flex_token->current_buffer_length[flex_token->second_state];
							flex_token->string_buffer[flex_token->second_state][length] = '\0';
							/* Semantic value stub. */
							char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->second_state] + 1));
			        		strcpy(ch, flex_token->string_buffer[flex_token->second_state]);
							flex_token->semantic_value[flex_token->second_state] = ch;	
							////flex_token->semantic_value[flex_token->second_state] = NULL;							
							if (flex_token->state != BRACKETED_STRING){
								 flex_token->error[flex_token->first_state] = 1;
							 	 flex_token->insert_token_in_list = flex_token->second_state;
							}
							else{
								 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
								 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
								 flex_token->string_buffer[flex_token->first_state][length] = '\0';
								 /* Semantic value stub. */
								 char * ch1 = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
				         		 strcpy(ch1, flex_token->string_buffer[flex_token->first_state]);
								 flex_token->semantic_value[flex_token->first_state] = ch1;	
								 ////flex_token->semantic_value[flex_token->first_state] = NULL;
								 flex_token->error[flex_token->first_state] = 0;
								 flex_token->insert_token_in_list = 3;
							}
							flex_token->double_list_ended = 1;
							flex_token->chunk_ended = 1;
							return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
						 }
						 //flex_token->semantic_value[flex_token->second_state] = NULL; /*If the chunk did not end, there is no token to return.*/
						 //flex_token->insert_token_in_list = 2; /*Do not insert any token in the token lists.*/
						 flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], '\n', &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
						 if (flex_token->state != BRACKETED_STRING){
							 int8_t swap = flex_token->first_state;
							 flex_token->first_state = flex_token->second_state;
							 flex_token->second_state = swap;
							 flex_token->state = BRACKETED_STRING;
							 BEGIN(twolists_commentOrError); //go to state twolists_bracketedString_commentOrError
						}
						else{//Keep being in state bracketedString_bracketed_string
							flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
						}
					} 
<twolists_bracketedString>[^\\\]\"\'\n\r]+	{
				 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->string_buffer[flex_token->second_state] = concat_to_buffer(flex_token->string_buffer[flex_token->second_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				}	
<twolists_bracketedString><<EOF>>		{//state is doubleString or singleString or bracketedString
				 flex_token->error[flex_token->second_state] = 1;
			 	 flex_token->error[flex_token->first_state] = 1;
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}									                                              						
<twolists_bracketedString>.				{/*Append char to buffer*/
				 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0], &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->string_buffer[flex_token->second_state] = append_to_buffer(flex_token->string_buffer[flex_token->second_state], yytext[0], &(flex_token->current_buffer_length[flex_token->second_state]), &(flex_token->allocated_buffer_size[flex_token->second_state]));
				}
<twolists_function1,twolists_function2>{NAME}		{flex_token->token = NAME;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
        		 strcpy(ch, yytext);
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;				 		
                                }                                                                 
<twolists_function1>{DOT}		{flex_token->token = DOT;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ".");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '.', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_function1>{COLON}		{flex_token->token = COLON;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ":");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ':', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_function1>{LPAREN}		{flex_token->token = LPARENFUNC;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, "(");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '(', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_function2);
				 return LEX_CORRECT;
                                }
<twolists_function1,twolists_function2>--\[=*\[		{int32_t i= 3;
				 flex_token->comment_type = 0;
				 while(yytext[i] == '=')
				 {
				 	(flex_token->comment_type)++;
				 	i++;
				 }
				 /*Type of beginning multiline comment is positive and starts from 1*/
				 (flex_token->comment_type)++;
				 flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state; /*Insert the symbol of beginning comment in this delimiter list.*/
				 flex_token->insert_function = 1; 
				 BEGIN(twolists_multiComment);
				 return INSERT_COMMENT;
                                }
<twolists_function1>--		{flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "--", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 flex_token->token = FUNCTION;
				 flex_token->before_comment[flex_token->second_state] = function1_state;
				 BEGIN(twolists_singleComment);
				 return INSERT_DELIMITER;
                    } 
<twolists_function2>--		{flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "--", 2, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 flex_token->token = FUNCTION;
				 flex_token->before_comment[flex_token->second_state] = function2_state;
				 BEGIN(twolists_singleComment);
				 return INSERT_DELIMITER;
                    } 
<twolists_function1,twolists_function2>\]\]{SPACE}*{NEWLINE}	{
				 flex_token->comment_type = -1;
				 flex_token->double_list_ended = 1;	
				 flex_token->error[flex_token->second_state] = 1;
				 if(flex_token->num_chars >= flex_token->chunk_length)
						flex_token->chunk_ended = 1;
				 if (flex_token->state == BRACKETED_STRING){
				 	 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
 					 flex_token->insert_token_in_list = flex_token->first_state;
					 flex_token->insert_single_comment_in_list = 2;
					 flex_token->error[flex_token->first_state] = 1;
					 BEGIN(onelist_INITIAL);
					 return INSERT_STRING_MULTICOMMENT;
				 }
				 else if (flex_token->state == SINGLE_COMMENT){
				 	// flex_token->semantic_value[flex_token->first_state] = NULL;
				 	flex_token->insert_single_comment_in_list = flex_token->first_state;
				 	flex_token->insert_token_in_list = 2;
				 	flex_token->error[flex_token->first_state] = 1;
				 	BEGIN(onelist_INITIAL);
					return INSERT_SINGLEMULTICOMMENT;
				 }
				 else{//state is doubleString or singleString
					 // flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->insert_token_in_list = 2;
					 flex_token->error[flex_token->first_state] = 1;
					 BEGIN(onelist_INITIAL);
					 return INSERT_COMMENT;
				 }
                            }                        
<twolists_function1,twolists_function2>{NEWLINE}	{flex_token->read_new_line = 1;
						 if (flex_token->state == BRACKETED_STRING){
						 	flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\n', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
							if(flex_token->num_chars >= flex_token->chunk_length) {
								flex_token->error[flex_token->first_state] = 0;
								flex_token->error[flex_token->second_state] = 0;
							 	flex_token->token = STRING;
								int32_t length = flex_token->current_buffer_length[flex_token->first_state];
								flex_token->string_buffer[flex_token->first_state][length] = '\0';
								/* Semantic value stub. */
								char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
				        		strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
								flex_token->semantic_value[flex_token->first_state] = ch;	
								////flex_token->semantic_value[flex_token->first_state] = NULL;							
								flex_token->insert_token_in_list = flex_token->first_state;
								flex_token->insert_function = 1; //insert delimiter FUNCTION in the flex_token->second_state delimiter list
								flex_token->double_list_ended = 1;
								flex_token->chunk_ended = 1;
								return END_CHUNK_INTERRUPTED_BRACKETED_STRING;
						 	}
						 }
						 else if (flex_token->state != SINGLE_COMMENT){//state is doubleString or singleString
						 	flex_token->error[flex_token->first_state] = 1;
						 	flex_token->error[flex_token->second_state] = 0;
							flex_token->semantic_value[flex_token->second_state] = NULL;
							flex_token->insert_token_in_list = flex_token->second_state; /*Insert delimiter FUNCTION in the flex_token->second_state*/
							flex_token->insert_function = 1;
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_INITIAL);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;
						 }
						 else{//state is SINGLE_COMMENT
						 	flex_token->error[flex_token->first_state] = 0;
						 	flex_token->error[flex_token->second_state] = 0;
						 	flex_token->semantic_value[flex_token->second_state] = NULL;
							flex_token->insert_token_in_list = flex_token->second_state; /*Insert delimiter FUNCTION in the flex_token->second_state*/
							flex_token->insert_function = 1;
							if(flex_token->num_chars >= flex_token->chunk_length)
								flex_token->chunk_ended = 1;
							BEGIN(onelist_INITIAL);
							flex_token->double_list_ended = 1;
							flex_token->bracket_delimiter = END_DOUBLE_LIST_NEWLINE;
							return INSERT_DELIMITER_BRACKETED_STRING;
						 }
						}						
<twolists_function1,twolists_function2>\"		{
				//Reading a string in state function1 and function2 is an error.
				if (flex_token->state == DOUBLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
				  	 flex_token->insert_token_in_list = flex_token->first_state;
				     flex_token->error[flex_token->first_state] = 0;
				 	 flex_token->error[flex_token->second_state] = 1;	
				 	 BEGIN(onelist_endStat1);
				 	 flex_token->double_list_ended = 1;
				 	 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;	
				}
				else{/*Append char to buffer*/
				 	 if (flex_token->state != SINGLE_COMMENT)
					 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\"',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 BEGIN(twolists_commentOrError); 
				}
                        }
<twolists_function1,twolists_function2>\'		{
				//Reading a string in state function1 and function2 is an error.
				if (flex_token->state == SINGLE_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
				  	 flex_token->insert_token_in_list = flex_token->first_state;
				     flex_token->error[flex_token->first_state] = 0;
				 	 flex_token->error[flex_token->second_state] = 1;	
				 	 BEGIN(onelist_endStat1);
				 	 flex_token->double_list_ended = 1;
				 	 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;	
				}
				else{/*Append char to buffer*/
				 	 if (flex_token->state != SINGLE_COMMENT)
					 	 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], '\'',&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 BEGIN(twolists_commentOrError); 
				}
                        } 
<twolists_function1,twolists_function2>\]\]		{
				//Reading a string or RBRACK RBRACK in state function1 and function2 is an error.
				if (flex_token->state == BRACKETED_STRING) {
					 flex_token->token = STRING;
					 int32_t length = flex_token->current_buffer_length[flex_token->first_state];
					 flex_token->string_buffer[flex_token->first_state][length] = '\0';
					 /* Semantic value stub. */
					 char * ch = (char*) malloc(sizeof(char)*(flex_token->current_buffer_length[flex_token->first_state] + 1));
	        		 strcpy(ch, flex_token->string_buffer[flex_token->first_state]);
					 flex_token->semantic_value[flex_token->first_state] = ch;	
					 ////flex_token->semantic_value[flex_token->first_state] = NULL;
					 flex_token->read_new_line = 0;	
				  	 flex_token->insert_token_in_list = flex_token->first_state;
				     flex_token->error[flex_token->first_state] = 0;
				 	 flex_token->error[flex_token->second_state] = 1;	
				 	 BEGIN(onelist_endStat1);
				 	 flex_token->double_list_ended = 1;
				 	 // return END_DOUBLE_LIST_CLOSING_BRACKET;
				 	 flex_token->bracket_delimiter = END_DOUBLE_LIST;
					 return INSERT_DELIMITER_BRACKETED_STRING;
				}
				else{/*Append char to buffer*/
				 	 if (flex_token->state != SINGLE_COMMENT)
					 	 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state],  yytext, yyleng, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
					 BEGIN(twolists_commentOrError); 
				}
                        }                                                                                            															                                                                                                                                                      
<twolists_function2>{DOT3}		{flex_token->token = DOT3;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*4);
        		 strcpy(ch, "...");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = concat_to_buffer(flex_token->string_buffer[flex_token->first_state], "...", 3, &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_function2>{COMMA}		{flex_token->token = COMMA;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ",");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ',', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 return LEX_CORRECT;
                                }
<twolists_function2>{RPAREN}		{flex_token->token = RPARENFUNC;
				 /* Semantic value stub. */
				 char * ch = (char*) malloc(sizeof(char)*2);
        		 strcpy(ch, ")");
				 flex_token->semantic_value[flex_token->second_state] = ch;	
				 ////flex_token->semantic_value[flex_token->second_state] = NULL;
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], ')', &(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 flex_token->insert_token_in_list = flex_token->second_state;
				 BEGIN(twolists_INITIAL);
				 return LEX_CORRECT;
                                }
<twolists_function1,twolists_function2><<EOF>>		{
				 flex_token->error[flex_token->second_state] = 0;
				 if (flex_token->state != SINGLE_COMMENT) {//state is doubleString or singleString or bracketedString
				 	flex_token->error[flex_token->first_state] = 1;
				 }
				 else
				 	flex_token->error[flex_token->first_state] = 0; //state is SINGLE_COMMENT
				 flex_token->insert_token_in_list = 2;	
				 flex_token->double_list_ended = 1;
				 flex_token->chunk_ended = 1;
				 flex_token->bracket_delimiter = END_DOUBLE_LIST;
				 return INSERT_DELIMITER_BRACKETED_STRING;
						}                                
<twolists_function1,twolists_function2>.	 {/*Append char to buffer*/
				 if (flex_token->state != SINGLE_COMMENT)
					 flex_token->string_buffer[flex_token->first_state] = append_to_buffer(flex_token->string_buffer[flex_token->first_state], yytext[0],&(flex_token->current_buffer_length[flex_token->first_state]), &(flex_token->allocated_buffer_size[flex_token->first_state]));
				 BEGIN(twolists_commentOrError);
				} 
<second_lexing_bracketedString>\\x[0-9a-fA-F]{2}		{
					/*Compute the decimal value of the hexadecimal number*/
					int32_t result = hex2dec(yytext[2]);
					result = (result << 4) + hex2dec(yytext[3]);
					/*Append (char)result to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], (char) result, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\[0-9]{1,3}		{
					/*Compute the decimal value of the number*/
					int32_t result = 0, i = 1;
					while(i < yyleng)
					{
						result = 10*result + yytext[i] - '0';
						i++;
					}
					/*Maximal system value of unsigned char (e.g. 255)*/
					if(result > UCHAR_MAX)
						return END_CHUNK_ERROR;
					else{/*Append (char)result to string buffer*/
						flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], (char) result, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
					}
				}
<second_lexing_bracketedString>\\z({SPACE}|{NEWLINE})*	{
					/*Skips the following span of white-space characters, including line breaks.*/
				}
<second_lexing_bracketedString>\\{NEWLINE}		{
					/*Append character newline to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));
				}
<second_lexing_bracketedString>\\\\		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\\', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));
				}
<second_lexing_bracketedString>\\\"		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\"', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));								
				}
<second_lexing_bracketedString>\\\'		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\'', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\a		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\a', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\b		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\b', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\f		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\f', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\n		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\r		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\r', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\t		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\t', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}
<second_lexing_bracketedString>\\v		{
					/*Append escaped character to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\v', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));	
				}					                        
<second_lexing_bracketedString>[^\\\]\n\r]+			{ /*Append char to string buffer*/
					flex_token->string_buffer[0] = concat_to_buffer(flex_token->string_buffer[0], yytext, yyleng, &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));						
				}
<second_lexing_bracketedString>\]\]	{
					int32_t length = flex_token->current_buffer_length[0];
					flex_token->string_buffer[0][length] = '\0';
					return LEX_CORRECT;
				}
<second_lexing_bracketedString>{NEWLINE}			{ /*Append char to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], '\n', &(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));						
					if(flex_token->num_chars >= flex_token->chunk_length) {
						int32_t length = flex_token->current_buffer_length[0];
						flex_token->string_buffer[0][length] = '\0';
						return END_CHUNK;
					}
				}									
<second_lexing_bracketedString>.			{ /*Append char to string buffer*/
					flex_token->string_buffer[0] = append_to_buffer(flex_token->string_buffer[0], yytext[0],&(flex_token->current_buffer_length[0]), &(flex_token->allocated_buffer_size[0]));						
				}										 				
%%