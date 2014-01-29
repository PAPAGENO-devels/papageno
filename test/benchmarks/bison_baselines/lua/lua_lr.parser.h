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

#ifndef YY_YY_LUA_LR_PARSER_H_INCLUDED
# define YY_YY_LUA_LR_PARSER_H_INCLUDED
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
     DO = 259,
     ELSE = 260,
     ELSEIF = 261,
     END = 262,
     FALSE = 263,
     FOR = 264,
     FUNCTION = 265,
     IF = 266,
     IN = 267,
     LOCAL = 268,
     NIL = 269,
     NOT = 270,
     REPEAT = 271,
     RETURN = 272,
     THEN = 273,
     TRUE = 274,
     UNTIL = 275,
     WHILE = 276,
     ELLIPSES = 277,
     SEMI = 278,
     LCURLY = 279,
     LROUND = 280,
     LSQUARE = 281,
     RCURLY = 282,
     RROUND = 283,
     RSQUARE = 284,
     SHARP = 285,
     SPECIAL = 286,
     COLON = 287,
     COMMA = 288,
     NUMBER = 289,
     STRING = 290,
     IDENTIFIER = 291,
     NONTERM = 292,
     ASSIGN = 293,
     OR = 294,
     AND = 295,
     GE = 296,
     LE = 297,
     GTR = 298,
     LESS = 299,
     NE = 300,
     EQ = 301,
     CONCAT = 302,
     MINUS = 303,
     PLUS = 304,
     MOD = 305,
     DIV = 306,
     TIMES = 307,
     UNARY_OPERATOR = 308,
     CARET = 309,
     PERIOD = 310
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2053 of yacc.c  */
#line 24 "lua_lr.y"

	struct token_node *node;


/* Line 2053 of yacc.c  */
#line 117 "lua_lr.parser.h"
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

#endif /* !YY_YY_LUA_LR_PARSER_H_INCLUDED  */
