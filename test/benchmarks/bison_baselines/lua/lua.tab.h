/* A Bison parser, made by GNU Bison 2.7.12-4996.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_LUA_TAB_H_INCLUDED
# define YY_YY_LUA_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     BREAK = 258,
     COLON = 259,
     COLON2 = 260,
     COMMA = 261,
     DO = 262,
     DOT = 263,
     DOT3 = 264,
     ELSE = 265,
     ELSEIF = 266,
     END = 267,
     EQ = 268,
     FALSE = 269,
     FOR = 270,
     FUNCTION = 271,
     GOTO = 272,
     IF = 273,
     IN = 274,
     LBRACE = 275,
     LBRACK = 276,
     LOCAL = 277,
     LPAREN = 278,
     NAME = 279,
     NIL = 280,
     NUMBER = 281,
     OR = 282,
     RBRACE = 283,
     RBRACK = 284,
     REPEAT = 285,
     RETURN = 286,
     RPAREN = 287,
     SEMI = 288,
     STRING = 289,
     THEN = 290,
     TRUE = 291,
     UNTIL = 292,
     WHILE = 293,
     AND = 294,
     EQ2 = 295,
     NEQ = 296,
     GTEQ = 297,
     LTEQ = 298,
     GT = 299,
     LT = 300,
     DOT2 = 301,
     MINUS = 302,
     PLUS = 303,
     PERCENT = 304,
     DIVIDE = 305,
     ASTERISK = 306,
     UMINUS = 307,
     SHARP = 308,
     NOT = 309,
     CARET = 310
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2053 of yacc.c  */
#line 40 "lua.y"

	token_node *node;


/* Line 2053 of yacc.c  */
#line 117 "lua.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_LUA_TAB_H_INCLUDED  */
