/* A Bison parser, made by GNU Bison 2.7.12-4996.  */

/* Bison implementation for Yacc-like parsers in C
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.7.12-4996"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
/* Line 371 of yacc.c  */
#line 5 "lua_lr.y"

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

/* Line 371 of yacc.c  */
#line 87 "lua_lr.parser.c"

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "lua_lr.parser.h".  */
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
/* Line 387 of yacc.c  */
#line 24 "lua_lr.y"

	struct token_node *node;


/* Line 387 of yacc.c  */
#line 190 "lua_lr.parser.c"
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

/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 218 "lua_lr.parser.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef __attribute__
/* This feature is available in gcc versions 2.5 and later.  */
# if (! defined __GNUC__ || __GNUC__ < 2 \
      || (__GNUC__ == 2 && __GNUC_MINOR__ < 5))
#  define __attribute__(Spec) /* empty */
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif


/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(N) (N)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (YYID (0))
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  69
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   717

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  56
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  41
/* YYNRULES -- Number of rules.  */
#define YYNRULES  135
/* YYNRULES -- Number of states.  */
#define YYNSTATES  245

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   310

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     7,     8,    10,    12,    15,    17,
      19,    22,    26,    29,    31,    34,    37,    39,    41,    43,
      45,    47,    50,    53,    56,    59,    61,    64,    67,    69,
      72,    75,    78,    81,    83,    86,    89,    93,    97,   103,
     108,   116,   126,   138,   146,   150,   156,   161,   164,   169,
     172,   176,   177,   179,   181,   184,   189,   190,   193,   196,
     200,   203,   205,   209,   213,   215,   219,   223,   225,   229,
     231,   233,   235,   237,   239,   241,   244,   246,   250,   252,
     256,   260,   264,   268,   272,   276,   280,   284,   288,   292,
     296,   300,   304,   308,   312,   315,   318,   321,   323,   327,
     329,   331,   333,   338,   342,   349,   355,   358,   363,   368,
     375,   378,   382,   386,   388,   394,   395,   397,   399,   403,
     406,   411,   413,   417,   423,   427,   429,   430,   432,   434,
     436,   437,   439,   441,   445,   446
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      57,     0,    -1,    58,    -1,    59,    -1,    -1,    75,    -1,
      64,    -1,    64,    75,    -1,    84,    -1,    85,    -1,    69,
      96,    -1,    69,    23,    96,    -1,    84,    23,    -1,    70,
      -1,    70,    23,    -1,    85,    23,    -1,    65,    -1,    66,
      -1,    67,    -1,    68,    -1,    60,    -1,    65,    60,    -1,
      66,    60,    -1,    67,    60,    -1,    68,    60,    -1,    61,
      -1,    67,    61,    -1,    68,    61,    -1,    62,    -1,    65,
      62,    -1,    66,    62,    -1,    67,    62,    -1,    68,    62,
      -1,    63,    -1,    67,    63,    -1,    68,    63,    -1,    76,
      38,    80,    -1,     4,    58,     7,    -1,    21,    79,     4,
      58,     7,    -1,    16,    58,    20,    79,    -1,    11,    79,
      18,    58,    71,    74,     7,    -1,     9,    36,    38,    79,
      33,    79,     4,    58,     7,    -1,     9,    36,    38,    79,
      33,    79,    33,    79,     4,    58,     7,    -1,     9,    95,
      12,    80,     4,    58,     7,    -1,    10,    78,    87,    -1,
      10,    78,    32,    36,    87,    -1,    13,    10,    36,    87,
      -1,    13,    95,    -1,    13,    95,    38,    80,    -1,    36,
      35,    -1,    77,    38,    80,    -1,    -1,    72,    -1,    73,
      -1,    72,    73,    -1,     6,    79,    18,    58,    -1,    -1,
       5,    58,    -1,    17,    92,    -1,    17,    80,    92,    -1,
       3,    92,    -1,    82,    -1,    76,    33,    82,    -1,    76,
      33,    83,    -1,    83,    -1,    77,    33,    82,    -1,    77,
      33,    83,    -1,    36,    -1,    78,    55,    36,    -1,    14,
      -1,     8,    -1,    19,    -1,    34,    -1,    35,    -1,    22,
      -1,    10,    87,    -1,    81,    -1,    25,    79,    28,    -1,
      89,    -1,    79,    47,    79,    -1,    79,    49,    79,    -1,
      79,    48,    79,    -1,    79,    52,    79,    -1,    79,    51,
      79,    -1,    79,    54,    79,    -1,    79,    50,    79,    -1,
      79,    44,    79,    -1,    79,    42,    79,    -1,    79,    43,
      79,    -1,    79,    41,    79,    -1,    79,    46,    79,    -1,
      79,    45,    79,    -1,    79,    40,    79,    -1,    79,    39,
      79,    -1,    15,    79,    -1,    48,    79,    -1,    30,    79,
      -1,    79,    -1,    80,    33,    79,    -1,    82,    -1,    84,
      -1,    36,    -1,    81,    26,    79,    29,    -1,    81,    55,
      36,    -1,    25,    79,    28,    26,    79,    29,    -1,    25,
      79,    28,    55,    36,    -1,    81,    86,    -1,    81,    32,
      36,    86,    -1,    25,    79,    28,    86,    -1,    25,    79,
      28,    32,    36,    86,    -1,    25,    28,    -1,    25,    80,
      28,    -1,    89,    25,    28,    -1,    35,    -1,    25,    88,
      28,    58,     7,    -1,    -1,    22,    -1,    95,    -1,    95,
      33,    22,    -1,    24,    27,    -1,    24,    90,    94,    27,
      -1,    91,    -1,    90,    93,    91,    -1,    26,    79,    29,
      38,    79,    -1,    36,    38,    79,    -1,    79,    -1,    -1,
      23,    -1,    33,    -1,    23,    -1,    -1,    93,    -1,    36,
      -1,    95,    33,    36,    -1,    -1,    31,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    54,    54,    56,    65,    71,    79,    87,   132,   141,
     151,   159,   169,   180,   186,   194,   205,   211,   217,   223,
     232,   238,   246,   254,   262,   273,   279,   287,   298,   304,
     312,   320,   328,   339,   345,   353,   366,   376,   386,   400,
     412,   431,   454,   481,   500,   510,   525,   537,   545,   557,
     570,   584,   589,   598,   604,   615,   629,   634,   645,   653,
     663,   676,   682,   692,   705,   711,   721,   736,   742,   757,
     763,   769,   775,   781,   787,   793,   801,   807,   817,   823,
     833,   843,   853,   863,   873,   883,   893,   903,   913,   923,
     933,   943,   953,   963,   973,   981,   989,  1000,  1006,  1022,
    1028,  1040,  1046,  1058,  1071,  1087,  1106,  1114,  1127,  1139,
    1158,  1166,  1176,  1186,  1195,  1212,  1217,  1223,  1229,  1244,
    1252,  1267,  1273,  1286,  1300,  1310,  1320,  1325,  1332,  1338,
    1345,  1350,  1358,  1364,  1376,  1381
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "BREAK", "DO", "ELSE", "ELSEIF", "END",
  "FALSE", "FOR", "FUNCTION", "IF", "IN", "LOCAL", "NIL", "NOT", "REPEAT",
  "RETURN", "THEN", "TRUE", "UNTIL", "WHILE", "ELLIPSES", "SEMI", "LCURLY",
  "LROUND", "LSQUARE", "RCURLY", "RROUND", "RSQUARE", "SHARP", "SPECIAL",
  "COLON", "COMMA", "NUMBER", "STRING", "IDENTIFIER", "NONTERM", "ASSIGN",
  "OR", "AND", "GE", "LE", "GTR", "LESS", "NE", "EQ", "CONCAT", "MINUS",
  "PLUS", "MOD", "DIV", "TIMES", "UNARY_OPERATOR", "CARET", "PERIOD",
  "$accept", "file", "opt_block", "opt_block_statements",
  "class_1_statement", "class_2_statement", "class_3_statement",
  "class_4_statement", "statement_list", "statement_list_1",
  "statement_list_2", "statement_list_3", "statement_list_4",
  "nobr_statement", "br_statement", "opt_elseif_block_list",
  "elseif_block_list", "elseif_block", "opt_else_block", "last_statement",
  "nobr_variable_list", "br_variable_list", "func_name_list", "expression",
  "expression_list", "nobr_prefix_expression", "nobr_variable",
  "br_variable", "nobr_function_call", "br_function_call", "arguments",
  "function_body", "opt_parameter_list", "table_constructor", "field_list",
  "field", "opt_semicolon", "field_separator", "opt_field_separator",
  "identifier_list", "opt_special", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    56,    57,    58,    59,    59,    59,    59,    60,    61,
      62,    62,    62,    63,    63,    63,    64,    64,    64,    64,
      65,    65,    65,    65,    65,    66,    66,    66,    67,    67,
      67,    67,    67,    68,    68,    68,    69,    69,    69,    69,
      69,    69,    69,    69,    69,    69,    69,    69,    69,    69,
      70,    71,    71,    72,    72,    73,    74,    74,    75,    75,
      75,    76,    76,    76,    77,    77,    77,    78,    78,    79,
      79,    79,    79,    79,    79,    79,    79,    79,    79,    79,
      79,    79,    79,    79,    79,    79,    79,    79,    79,    79,
      79,    79,    79,    79,    79,    79,    79,    80,    80,    81,
      81,    82,    82,    82,    83,    83,    84,    84,    85,    85,
      86,    86,    86,    86,    87,    88,    88,    88,    88,    89,
      89,    90,    90,    91,    91,    91,    92,    92,    93,    93,
      94,    94,    95,    95,    96,    96
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     0,     1,     1,     2,     1,     1,
       2,     3,     2,     1,     2,     2,     1,     1,     1,     1,
       1,     2,     2,     2,     2,     1,     2,     2,     1,     2,
       2,     2,     2,     1,     2,     2,     3,     3,     5,     4,
       7,     9,    11,     7,     3,     5,     4,     2,     4,     2,
       3,     0,     1,     1,     2,     4,     0,     2,     2,     3,
       2,     1,     3,     3,     1,     3,     3,     1,     3,     1,
       1,     1,     1,     1,     1,     2,     1,     3,     1,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     2,     2,     2,     1,     3,     1,
       1,     1,     4,     3,     6,     5,     2,     4,     4,     6,
       2,     3,     3,     1,     5,     0,     1,     1,     3,     2,
       4,     1,     3,     5,     3,     1,     0,     1,     1,     1,
       0,     1,     1,     3,     0,     1
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       4,   126,     4,     0,     0,     0,     0,     4,   126,     0,
       0,   101,     0,     2,     3,    20,    25,    28,    33,     6,
      16,    17,    18,    19,   134,    13,     5,     0,     0,     0,
      99,    64,     8,     9,   127,    60,     0,   132,     0,    67,
       0,    70,     0,    69,     0,    71,    74,     0,     0,     0,
      72,    73,   101,     0,     0,    76,    99,   100,    78,     0,
     132,    47,     0,    97,   126,    58,     0,     0,    49,     1,
       7,    21,    29,    22,    30,    23,    26,    31,    34,    24,
      27,    32,    35,   134,   135,    10,    14,     0,     0,     0,
       0,     0,     0,     0,   113,     0,   106,     0,    12,    15,
      37,     0,     0,     0,   115,     0,     0,    44,    75,    94,
       0,   119,   101,   125,   130,   121,     0,    96,    95,     4,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    59,
       4,     0,    11,     0,    99,    63,    36,    99,    66,    50,
     110,     0,     0,     0,   103,     0,     0,     0,   133,   116,
       0,   117,     0,    68,     0,     0,   129,   128,   131,     0,
      77,    51,    93,    92,    89,    87,    88,    86,    91,    90,
      79,    81,    80,    85,    83,    82,    84,    46,    48,    39,
      98,     0,     0,     0,     0,   108,     0,   111,   102,   107,
     112,     0,     4,     4,     0,    45,     0,   124,   122,   120,
       0,    56,    52,    53,    38,     0,     0,   105,     0,     0,
       0,     0,   118,     0,     0,     4,     0,    54,   104,   109,
       4,     0,    43,   114,   123,     4,    57,    40,     0,     0,
      55,    41,     4,     0,    42
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    12,    13,    14,    15,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    25,   211,   212,   213,   226,    26,
      27,    28,    40,    63,    64,    55,    56,    31,    57,    33,
      96,   107,   160,    58,   114,   115,    35,   168,   169,    38,
      85
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -141
static const yytype_int16 yypact[] =
{
     125,    -5,   125,     7,    48,   415,    22,   125,   325,   415,
     415,    53,    94,  -141,  -141,  -141,  -141,  -141,  -141,    35,
     205,   205,   101,   101,    93,    77,  -141,    30,    80,   332,
      82,  -141,    24,    83,  -141,  -141,   102,   105,    21,  -141,
     -13,  -141,   106,  -141,   415,  -141,  -141,    47,   415,   415,
    -141,  -141,  -141,   415,   425,   332,  -141,  -141,  -141,   103,
    -141,   116,   139,   624,    11,  -141,   264,   466,  -141,  -141,
    -141,  -141,  -141,  -141,  -141,  -141,  -141,  -141,  -141,  -141,
    -141,  -141,  -141,   114,  -141,  -141,  -141,    50,   415,    50,
     415,   355,   415,   128,  -141,   136,  -141,   169,  -141,  -141,
    -141,   415,   415,   159,    31,   161,   163,  -141,  -141,   146,
     415,  -141,   166,   624,    57,  -141,   491,   146,   146,   125,
     415,   415,   415,   415,   415,   415,   415,   415,   415,   415,
     415,   415,   415,   415,   415,   106,   415,   415,   415,  -141,
     125,   392,  -141,   415,   122,  -141,   172,   124,  -141,   172,
    -141,   130,   540,    72,  -141,   173,   608,    12,  -141,  -141,
     180,   179,   106,  -141,   564,   415,  -141,  -141,   385,   186,
    -141,   211,   639,   653,   663,   663,   663,   663,   119,   119,
     119,   203,   203,   146,   146,   146,   146,  -141,   172,   624,
     624,   212,   415,   188,   191,  -141,   516,  -141,  -141,  -141,
    -141,   415,   125,   125,    56,  -141,   184,   624,  -141,  -141,
     415,   223,   211,  -141,  -141,   588,    72,  -141,    -9,   248,
     224,   225,  -141,   415,   441,   125,   233,  -141,  -141,  -141,
     125,   415,  -141,  -141,   624,   125,  -141,  -141,   237,   280,
    -141,  -141,   125,   238,  -141
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -141,  -141,    34,  -141,   240,   129,   250,   168,  -141,  -141,
    -141,  -141,  -141,  -141,  -141,  -141,  -141,    36,  -141,   230,
    -141,  -141,  -141,    55,   -51,     0,     4,    43,     8,  -141,
    -140,   -37,  -141,   -20,  -141,    90,     6,  -141,  -141,    -3,
     183
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -101
static const yytype_int16 yytable[] =
{
      29,   195,    29,    61,    30,   108,    30,    29,    32,    97,
      32,    30,   104,   199,    65,    32,   202,   192,    34,   105,
      29,    29,    29,    29,    30,    30,    30,    30,    32,    32,
      32,    32,    59,   102,    34,    97,    36,   146,     1,   149,
     151,    62,   106,    37,   138,   138,   194,    98,  -100,  -100,
    -100,   157,     8,   159,   103,    41,  -100,    42,    60,  -100,
      54,    43,    44,    87,    66,    67,    45,    60,    88,    46,
     139,    47,    48,   110,   111,   143,   229,    49,   222,  -100,
     166,    50,    51,   112,    39,   188,    52,    29,    68,    29,
     167,   144,   158,   147,    69,    53,    47,    91,   187,   109,
      86,   161,   113,   116,   117,     2,    99,    94,   118,   100,
       3,     4,     5,    89,     6,   -61,    83,     7,    90,    29,
     -61,    97,     9,    30,    84,   205,    10,    32,     1,     2,
     145,   104,   148,    97,     3,     4,     5,    11,     6,   135,
      29,     7,     8,   101,    30,    84,     9,   152,    32,   103,
      10,    76,    80,   171,   136,   -62,   156,   -65,   197,   137,
     -62,    11,   -65,   138,   153,   164,   128,   129,   130,   131,
     132,   133,   154,   134,   191,   172,   173,   174,   175,   176,
     177,   178,   179,   180,   181,   182,   183,   184,   185,   186,
      78,    82,   189,   190,   155,   158,    97,   162,   196,   163,
     134,   200,    29,    29,   165,   138,    30,    30,   203,     2,
      32,    32,   204,   209,     3,     4,     5,   210,     6,   214,
     207,     7,   223,   113,   216,    29,     9,   217,   225,    30,
      29,   232,   233,    32,    30,    29,   220,   221,    32,    30,
     237,    11,    29,    32,   241,   244,    30,   215,   227,    70,
      32,     0,   230,   131,   132,   133,   219,   134,   208,   236,
      71,    73,    75,    79,   238,   224,   142,     0,   140,   240,
      72,    74,    77,    81,     0,     0,   243,     0,   234,     0,
       0,   231,     0,     0,   242,     0,   239,   120,   121,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,     0,   134,   120,   121,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,     0,   134,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   133,    41,   134,    42,     0,     0,     0,    43,
      44,     0,     0,     0,    45,     0,     0,    46,    34,    47,
      48,     0,     0,     0,     0,    49,    47,    91,    92,    50,
      51,    52,     0,    41,    93,    42,     0,    94,     0,    43,
      44,     0,     0,    53,    45,     0,     0,    46,     0,    47,
      48,     0,     0,   150,     0,    49,     0,    95,     0,    50,
      51,    52,     0,    41,     0,    42,     0,     0,     0,    43,
      44,     0,     0,    53,    45,     0,     0,    46,     0,    47,
      48,   110,     0,     0,     0,    49,    47,    91,   192,    50,
      51,   112,     0,    41,   193,    42,     0,    94,     0,    43,
      44,     0,     0,    53,    45,     0,     0,    46,     0,    47,
      48,     0,     0,   119,     0,    49,     0,   194,     0,    50,
      51,    52,     0,     0,     0,     0,     0,     0,     0,   235,
       0,     0,     0,    53,   120,   121,   122,   123,   124,   125,
     126,   127,   128,   129,   130,   131,   132,   133,     0,   134,
     120,   121,   122,   123,   124,   125,   126,   127,   128,   129,
     130,   131,   132,   133,   141,   134,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   170,
     134,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     120,   121,   122,   123,   124,   125,   126,   127,   128,   129,
     130,   131,   132,   133,   218,   134,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   198,
     134,     0,     0,     0,     0,     0,     0,     0,     0,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
     131,   132,   133,   206,   134,     0,     0,     0,     0,     0,
       0,     0,     0,   120,   121,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,   228,   134,     0,
       0,     0,     0,     0,     0,     0,     0,   120,   121,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,   201,   134,     0,     0,     0,     0,   120,   121,   122,
     123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
     133,     0,   134,   120,   121,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,     0,   134,   121,
     122,   123,   124,   125,   126,   127,   128,   129,   130,   131,
     132,   133,     0,   134,   122,   123,   124,   125,   126,   127,
     128,   129,   130,   131,   132,   133,     0,   134,   126,   127,
     128,   129,   130,   131,   132,   133,     0,   134
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-141)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
       0,   141,     2,     6,     0,    42,     2,     7,     0,    29,
       2,     7,    25,   153,     8,     7,     4,    26,    23,    32,
      20,    21,    22,    23,    20,    21,    22,    23,    20,    21,
      22,    23,    10,    12,    23,    55,     2,    88,     3,    90,
      91,     7,    55,    36,    33,    33,    55,    23,    24,    25,
      26,   102,    17,    22,    33,     8,    32,    10,    36,    35,
       5,    14,    15,    33,     9,    10,    19,    36,    38,    22,
      64,    24,    25,    26,    27,    25,   216,    30,    22,    55,
      23,    34,    35,    36,    36,   136,    36,    87,    35,    89,
      33,    87,    36,    89,     0,    48,    24,    25,   135,    44,
      23,   104,    47,    48,    49,     4,    23,    35,    53,     7,
       9,    10,    11,    33,    13,    33,    23,    16,    38,   119,
      38,   141,    21,   119,    31,   162,    25,   119,     3,     4,
      87,    25,    89,   153,     9,    10,    11,    36,    13,    36,
     140,    16,    17,    38,   140,    31,    21,    92,   140,    33,
      25,    22,    23,   119,    38,    33,   101,    33,    28,    20,
      38,    36,    38,    33,    36,   110,    47,    48,    49,    50,
      51,    52,    36,    54,   140,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   134,
      22,    23,   137,   138,    25,    36,   216,    36,   143,    36,
      54,    28,   202,   203,    38,    33,   202,   203,    28,     4,
     202,   203,    33,    27,     9,    10,    11,     6,    13,     7,
     165,    16,    38,   168,    36,   225,    21,    36,     5,   225,
     230,     7,     7,   225,   230,   235,   202,   203,   230,   235,
       7,    36,   242,   235,     7,     7,   242,   192,   212,    19,
     242,    -1,     4,    50,    51,    52,   201,    54,   168,   225,
      20,    21,    22,    23,   230,   210,    83,    -1,     4,   235,
      20,    21,    22,    23,    -1,    -1,   242,    -1,   223,    -1,
      -1,    33,    -1,    -1,     4,    -1,   231,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    -1,    54,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    -1,    54,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,     8,    54,    10,    -1,    -1,    -1,    14,
      15,    -1,    -1,    -1,    19,    -1,    -1,    22,    23,    24,
      25,    -1,    -1,    -1,    -1,    30,    24,    25,    26,    34,
      35,    36,    -1,     8,    32,    10,    -1,    35,    -1,    14,
      15,    -1,    -1,    48,    19,    -1,    -1,    22,    -1,    24,
      25,    -1,    -1,    28,    -1,    30,    -1,    55,    -1,    34,
      35,    36,    -1,     8,    -1,    10,    -1,    -1,    -1,    14,
      15,    -1,    -1,    48,    19,    -1,    -1,    22,    -1,    24,
      25,    26,    -1,    -1,    -1,    30,    24,    25,    26,    34,
      35,    36,    -1,     8,    32,    10,    -1,    35,    -1,    14,
      15,    -1,    -1,    48,    19,    -1,    -1,    22,    -1,    24,
      25,    -1,    -1,    18,    -1,    30,    -1,    55,    -1,    34,
      35,    36,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    18,
      -1,    -1,    -1,    48,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    -1,    54,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    28,    54,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    28,
      54,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    28,    54,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    29,
      54,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,
      40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    29,    54,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    29,    54,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    33,    54,    -1,    -1,    -1,    -1,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    -1,    54,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    -1,    54,    40,
      41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    -1,    54,    41,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    -1,    54,    45,    46,
      47,    48,    49,    50,    51,    52,    -1,    54
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     9,    10,    11,    13,    16,    17,    21,
      25,    36,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    75,    76,    77,    81,
      82,    83,    84,    85,    23,    92,    58,    36,    95,    36,
      78,     8,    10,    14,    15,    19,    22,    24,    25,    30,
      34,    35,    36,    48,    79,    81,    82,    84,    89,    10,
      36,    95,    58,    79,    80,    92,    79,    79,    35,     0,
      75,    60,    62,    60,    62,    60,    61,    62,    63,    60,
      61,    62,    63,    23,    31,    96,    23,    33,    38,    33,
      38,    25,    26,    32,    35,    55,    86,    89,    23,    23,
       7,    38,    12,    33,    25,    32,    55,    87,    87,    79,
      26,    27,    36,    79,    90,    91,    79,    79,    79,    18,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    54,    36,    38,    20,    33,    92,
       4,    28,    96,    25,    82,    83,    80,    82,    83,    80,
      28,    80,    79,    36,    36,    25,    79,    80,    36,    22,
      88,    95,    36,    36,    79,    38,    23,    33,    93,    94,
      28,    58,    79,    79,    79,    79,    79,    79,    79,    79,
      79,    79,    79,    79,    79,    79,    79,    87,    80,    79,
      79,    58,    26,    32,    55,    86,    79,    28,    29,    86,
      28,    33,     4,    28,    33,    87,    29,    79,    91,    27,
       6,    71,    72,    73,     7,    79,    36,    36,    28,    79,
      58,    58,    22,    38,    79,     5,    74,    73,    29,    86,
       4,    33,     7,     7,    79,    18,    58,     7,    58,    79,
      58,     7,     4,    58,     7
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))

/* Error token number */
#define YYTERROR	1
#define YYERRCODE	256


/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */
#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULL;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - Assume YYFAIL is not used.  It's too flawed to consider.  See
       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
       for details.  YYERROR is fine as it does not invoke this
       function.
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YYUSE (yytype);
}




/* The lookahead symbol.  */
int yychar;


#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval YY_INITIAL_VALUE(yyval_default);

/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
/* Line 1787 of yacc.c  */
#line 54 "lua_lr.y"
    { printf("done"); }
    break;

  case 3:
/* Line 1787 of yacc.c  */
#line 56 "lua_lr.y"
    { 
                (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 4:
/* Line 1787 of yacc.c  */
#line 65 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL;
		}
    break;

  case 5:
/* Line 1787 of yacc.c  */
#line 71 "lua_lr.y"
    { 
                (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 6:
/* Line 1787 of yacc.c  */
#line 79 "lua_lr.y"
    { 
                (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 7:
/* Line 1787 of yacc.c  */
#line 87 "lua_lr.y"
    { 
                (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);}
    break;

  case 8:
/* Line 1787 of yacc.c  */
#line 132 "lua_lr.y"
    {                 
                (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);}
    break;

  case 9:
/* Line 1787 of yacc.c  */
#line 141 "lua_lr.y"
    {  
                (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 10:
/* Line 1787 of yacc.c  */
#line 151 "lua_lr.y"
    {                 (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 11:
/* Line 1787 of yacc.c  */
#line 159 "lua_lr.y"
    {                 (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 12:
/* Line 1787 of yacc.c  */
#line 169 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 13:
/* Line 1787 of yacc.c  */
#line 180 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 14:
/* Line 1787 of yacc.c  */
#line 186 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 15:
/* Line 1787 of yacc.c  */
#line 194 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 16:
/* Line 1787 of yacc.c  */
#line 205 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 17:
/* Line 1787 of yacc.c  */
#line 211 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 18:
/* Line 1787 of yacc.c  */
#line 217 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 19:
/* Line 1787 of yacc.c  */
#line 223 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 20:
/* Line 1787 of yacc.c  */
#line 232 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 21:
/* Line 1787 of yacc.c  */
#line 238 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 22:
/* Line 1787 of yacc.c  */
#line 246 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 23:
/* Line 1787 of yacc.c  */
#line 254 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 24:
/* Line 1787 of yacc.c  */
#line 262 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 25:
/* Line 1787 of yacc.c  */
#line 273 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 26:
/* Line 1787 of yacc.c  */
#line 279 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 27:
/* Line 1787 of yacc.c  */
#line 287 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 28:
/* Line 1787 of yacc.c  */
#line 298 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 29:
/* Line 1787 of yacc.c  */
#line 304 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 30:
/* Line 1787 of yacc.c  */
#line 312 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 31:
/* Line 1787 of yacc.c  */
#line 320 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 32:
/* Line 1787 of yacc.c  */
#line 328 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 33:
/* Line 1787 of yacc.c  */
#line 339 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);}
    break;

  case 34:
/* Line 1787 of yacc.c  */
#line 345 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 35:
/* Line 1787 of yacc.c  */
#line 353 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 36:
/* Line 1787 of yacc.c  */
#line 366 "lua_lr.y"
    {(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 37:
/* Line 1787 of yacc.c  */
#line 376 "lua_lr.y"
    {(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 38:
/* Line 1787 of yacc.c  */
#line 386 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (5)].node)->parent = (yyval.node);
		(yyvsp[(2) - (5)].node)->parent = (yyval.node);
		(yyvsp[(3) - (5)].node)->parent = (yyval.node);
		(yyvsp[(4) - (5)].node)->parent = (yyval.node);
		(yyvsp[(5) - (5)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (5)].node);
                (yyvsp[(1) - (5)].node)->next = (yyvsp[(2) - (5)].node);
                (yyvsp[(2) - (5)].node)->next = (yyvsp[(3) - (5)].node);
                (yyvsp[(3) - (5)].node)->next = (yyvsp[(4) - (5)].node);
                (yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node); }
    break;

  case 39:
/* Line 1787 of yacc.c  */
#line 400 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node); }
    break;

  case 40:
/* Line 1787 of yacc.c  */
#line 413 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (7)].node)->parent = (yyval.node);
		(yyvsp[(2) - (7)].node)->parent = (yyval.node);
		(yyvsp[(3) - (7)].node)->parent = (yyval.node);
		(yyvsp[(4) - (7)].node)->parent = (yyval.node);
		(yyvsp[(5) - (7)].node)->parent = (yyval.node);
		(yyvsp[(6) - (7)].node)->parent = (yyval.node);
		(yyvsp[(7) - (7)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (7)].node);
                (yyvsp[(1) - (7)].node)->next = (yyvsp[(2) - (7)].node);
                (yyvsp[(2) - (7)].node)->next = (yyvsp[(3) - (7)].node);
                (yyvsp[(3) - (7)].node)->next = (yyvsp[(4) - (7)].node);
                (yyvsp[(4) - (7)].node)->next = (yyvsp[(5) - (7)].node);
                (yyvsp[(5) - (7)].node)->next = (yyvsp[(6) - (7)].node);
                (yyvsp[(6) - (7)].node)->next = (yyvsp[(7) - (7)].node); }
    break;

  case 41:
/* Line 1787 of yacc.c  */
#line 432 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (9)].node)->parent = (yyval.node);
		(yyvsp[(2) - (9)].node)->parent = (yyval.node);
		(yyvsp[(3) - (9)].node)->parent = (yyval.node);
		(yyvsp[(4) - (9)].node)->parent = (yyval.node);
		(yyvsp[(5) - (9)].node)->parent = (yyval.node);
		(yyvsp[(6) - (9)].node)->parent = (yyval.node);
		(yyvsp[(7) - (9)].node)->parent = (yyval.node);
		(yyvsp[(8) - (9)].node)->parent = (yyval.node);
		(yyvsp[(9) - (9)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (9)].node);
                (yyvsp[(1) - (9)].node)->next = (yyvsp[(2) - (9)].node);
                (yyvsp[(2) - (9)].node)->next = (yyvsp[(3) - (9)].node);
                (yyvsp[(3) - (9)].node)->next = (yyvsp[(4) - (9)].node);
                (yyvsp[(4) - (9)].node)->next = (yyvsp[(5) - (9)].node);
                (yyvsp[(5) - (9)].node)->next = (yyvsp[(6) - (9)].node);
                (yyvsp[(6) - (9)].node)->next = (yyvsp[(7) - (9)].node);
                (yyvsp[(7) - (9)].node)->next = (yyvsp[(8) - (9)].node);
                (yyvsp[(8) - (9)].node)->next = (yyvsp[(9) - (9)].node); }
    break;

  case 42:
/* Line 1787 of yacc.c  */
#line 455 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (11)].node)->parent = (yyval.node);
		(yyvsp[(2) - (11)].node)->parent = (yyval.node);
		(yyvsp[(3) - (11)].node)->parent = (yyval.node);
		(yyvsp[(4) - (11)].node)->parent = (yyval.node);
		(yyvsp[(5) - (11)].node)->parent = (yyval.node);
		(yyvsp[(6) - (11)].node)->parent = (yyval.node);
		(yyvsp[(7) - (11)].node)->parent = (yyval.node);
		(yyvsp[(8) - (11)].node)->parent = (yyval.node);
		(yyvsp[(9) - (11)].node)->parent = (yyval.node);
		(yyvsp[(10) - (11)].node)->parent = (yyval.node);
		(yyvsp[(11) - (11)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (11)].node);
                (yyvsp[(1) - (11)].node)->next = (yyvsp[(2) - (11)].node);
                (yyvsp[(2) - (11)].node)->next = (yyvsp[(3) - (11)].node);
                (yyvsp[(3) - (11)].node)->next = (yyvsp[(4) - (11)].node);
                (yyvsp[(4) - (11)].node)->next = (yyvsp[(5) - (11)].node);
                (yyvsp[(5) - (11)].node)->next = (yyvsp[(6) - (11)].node);
                (yyvsp[(6) - (11)].node)->next = (yyvsp[(7) - (11)].node);
                (yyvsp[(7) - (11)].node)->next = (yyvsp[(8) - (11)].node);
                (yyvsp[(8) - (11)].node)->next = (yyvsp[(9) - (11)].node);
                (yyvsp[(9) - (11)].node)->next = (yyvsp[(10) - (11)].node);
                (yyvsp[(10) - (11)].node)->next = (yyvsp[(11) - (11)].node); }
    break;

  case 43:
/* Line 1787 of yacc.c  */
#line 482 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (7)].node)->parent = (yyval.node);
		(yyvsp[(2) - (7)].node)->parent = (yyval.node);
		(yyvsp[(3) - (7)].node)->parent = (yyval.node);
		(yyvsp[(4) - (7)].node)->parent = (yyval.node);
		(yyvsp[(5) - (7)].node)->parent = (yyval.node);
		(yyvsp[(6) - (7)].node)->parent = (yyval.node);
		(yyvsp[(7) - (7)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (7)].node);
                (yyvsp[(1) - (7)].node)->next = (yyvsp[(2) - (7)].node);
                (yyvsp[(2) - (7)].node)->next = (yyvsp[(3) - (7)].node);
                (yyvsp[(3) - (7)].node)->next = (yyvsp[(4) - (7)].node);
                (yyvsp[(4) - (7)].node)->next = (yyvsp[(5) - (7)].node);
                (yyvsp[(5) - (7)].node)->next = (yyvsp[(6) - (7)].node);
                (yyvsp[(6) - (7)].node)->next = (yyvsp[(7) - (7)].node); }
    break;

  case 44:
/* Line 1787 of yacc.c  */
#line 500 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 45:
/* Line 1787 of yacc.c  */
#line 511 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (5)].node)->parent = (yyval.node);
		(yyvsp[(2) - (5)].node)->parent = (yyval.node);
		(yyvsp[(3) - (5)].node)->parent = (yyval.node);
		(yyvsp[(4) - (5)].node)->parent = (yyval.node);
		(yyvsp[(5) - (5)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (5)].node);
                (yyvsp[(1) - (5)].node)->next = (yyvsp[(2) - (5)].node);
                (yyvsp[(2) - (5)].node)->next = (yyvsp[(3) - (5)].node);
                (yyvsp[(3) - (5)].node)->next = (yyvsp[(4) - (5)].node);
                (yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node); }
    break;

  case 46:
/* Line 1787 of yacc.c  */
#line 525 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);	}
    break;

  case 47:
/* Line 1787 of yacc.c  */
#line 537 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 48:
/* Line 1787 of yacc.c  */
#line 545 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node); }
    break;

  case 49:
/* Line 1787 of yacc.c  */
#line 557 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 50:
/* Line 1787 of yacc.c  */
#line 570 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 51:
/* Line 1787 of yacc.c  */
#line 584 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL; }
    break;

  case 52:
/* Line 1787 of yacc.c  */
#line 589 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 53:
/* Line 1787 of yacc.c  */
#line 598 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 54:
/* Line 1787 of yacc.c  */
#line 604 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 55:
/* Line 1787 of yacc.c  */
#line 615 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node); }
    break;

  case 56:
/* Line 1787 of yacc.c  */
#line 629 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL; }
    break;

  case 57:
/* Line 1787 of yacc.c  */
#line 634 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node); }
    break;

  case 58:
/* Line 1787 of yacc.c  */
#line 645 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 59:
/* Line 1787 of yacc.c  */
#line 653 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 60:
/* Line 1787 of yacc.c  */
#line 663 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 61:
/* Line 1787 of yacc.c  */
#line 676 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 62:
/* Line 1787 of yacc.c  */
#line 682 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 63:
/* Line 1787 of yacc.c  */
#line 692 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 64:
/* Line 1787 of yacc.c  */
#line 705 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 65:
/* Line 1787 of yacc.c  */
#line 711 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 66:
/* Line 1787 of yacc.c  */
#line 721 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 67:
/* Line 1787 of yacc.c  */
#line 736 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 68:
/* Line 1787 of yacc.c  */
#line 742 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 69:
/* Line 1787 of yacc.c  */
#line 757 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 70:
/* Line 1787 of yacc.c  */
#line 763 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 71:
/* Line 1787 of yacc.c  */
#line 769 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 72:
/* Line 1787 of yacc.c  */
#line 775 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 73:
/* Line 1787 of yacc.c  */
#line 781 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 74:
/* Line 1787 of yacc.c  */
#line 787 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 75:
/* Line 1787 of yacc.c  */
#line 793 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 76:
/* Line 1787 of yacc.c  */
#line 801 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);}
    break;

  case 77:
/* Line 1787 of yacc.c  */
#line 807 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 78:
/* Line 1787 of yacc.c  */
#line 817 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 79:
/* Line 1787 of yacc.c  */
#line 823 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 80:
/* Line 1787 of yacc.c  */
#line 833 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 81:
/* Line 1787 of yacc.c  */
#line 843 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 82:
/* Line 1787 of yacc.c  */
#line 853 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 83:
/* Line 1787 of yacc.c  */
#line 863 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 84:
/* Line 1787 of yacc.c  */
#line 873 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 85:
/* Line 1787 of yacc.c  */
#line 883 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 86:
/* Line 1787 of yacc.c  */
#line 893 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 87:
/* Line 1787 of yacc.c  */
#line 903 "lua_lr.y"
    {(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 88:
/* Line 1787 of yacc.c  */
#line 913 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);}
    break;

  case 89:
/* Line 1787 of yacc.c  */
#line 923 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 90:
/* Line 1787 of yacc.c  */
#line 933 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 91:
/* Line 1787 of yacc.c  */
#line 943 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 92:
/* Line 1787 of yacc.c  */
#line 953 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 93:
/* Line 1787 of yacc.c  */
#line 963 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 94:
/* Line 1787 of yacc.c  */
#line 973 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 95:
/* Line 1787 of yacc.c  */
#line 981 "lua_lr.y"
    {(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 96:
/* Line 1787 of yacc.c  */
#line 989 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 97:
/* Line 1787 of yacc.c  */
#line 1000 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 98:
/* Line 1787 of yacc.c  */
#line 1006 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node); 
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 99:
/* Line 1787 of yacc.c  */
#line 1022 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 100:
/* Line 1787 of yacc.c  */
#line 1028 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 101:
/* Line 1787 of yacc.c  */
#line 1040 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 102:
/* Line 1787 of yacc.c  */
#line 1046 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node); }
    break;

  case 103:
/* Line 1787 of yacc.c  */
#line 1058 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 104:
/* Line 1787 of yacc.c  */
#line 1071 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (6)].node)->parent = (yyval.node);
		(yyvsp[(2) - (6)].node)->parent = (yyval.node);
		(yyvsp[(3) - (6)].node)->parent = (yyval.node);
		(yyvsp[(4) - (6)].node)->parent = (yyval.node);
		(yyvsp[(5) - (6)].node)->parent = (yyval.node);
		(yyvsp[(6) - (6)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (6)].node);
                (yyvsp[(1) - (6)].node)->next = (yyvsp[(2) - (6)].node);
                (yyvsp[(2) - (6)].node)->next = (yyvsp[(3) - (6)].node);
                (yyvsp[(3) - (6)].node)->next = (yyvsp[(4) - (6)].node);
                (yyvsp[(4) - (6)].node)->next = (yyvsp[(5) - (6)].node);
                (yyvsp[(5) - (6)].node)->next = (yyvsp[(6) - (6)].node); }
    break;

  case 105:
/* Line 1787 of yacc.c  */
#line 1087 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (5)].node)->parent = (yyval.node);
		(yyvsp[(2) - (5)].node)->parent = (yyval.node);
		(yyvsp[(3) - (5)].node)->parent = (yyval.node);
		(yyvsp[(4) - (5)].node)->parent = (yyval.node);
		(yyvsp[(5) - (5)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (5)].node);
                (yyvsp[(1) - (5)].node)->next = (yyvsp[(2) - (5)].node);
                (yyvsp[(2) - (5)].node)->next = (yyvsp[(3) - (5)].node);
                (yyvsp[(3) - (5)].node)->next = (yyvsp[(4) - (5)].node);
                (yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node); }
    break;

  case 106:
/* Line 1787 of yacc.c  */
#line 1106 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 107:
/* Line 1787 of yacc.c  */
#line 1114 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node); }
    break;

  case 108:
/* Line 1787 of yacc.c  */
#line 1127 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node); }
    break;

  case 109:
/* Line 1787 of yacc.c  */
#line 1139 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (6)].node)->parent = (yyval.node);
		(yyvsp[(2) - (6)].node)->parent = (yyval.node);
		(yyvsp[(3) - (6)].node)->parent = (yyval.node);
		(yyvsp[(4) - (6)].node)->parent = (yyval.node);
		(yyvsp[(5) - (6)].node)->parent = (yyval.node);
	        (yyvsp[(6) - (6)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (6)].node);
                (yyvsp[(1) - (6)].node)->next = (yyvsp[(2) - (6)].node);
                (yyvsp[(2) - (6)].node)->next = (yyvsp[(3) - (6)].node);
                (yyvsp[(3) - (6)].node)->next = (yyvsp[(4) - (6)].node);
                (yyvsp[(4) - (6)].node)->next = (yyvsp[(5) - (6)].node);
                (yyvsp[(5) - (6)].node)->next = (yyvsp[(6) - (6)].node);}
    break;

  case 110:
/* Line 1787 of yacc.c  */
#line 1158 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 111:
/* Line 1787 of yacc.c  */
#line 1166 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 112:
/* Line 1787 of yacc.c  */
#line 1176 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 113:
/* Line 1787 of yacc.c  */
#line 1186 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 114:
/* Line 1787 of yacc.c  */
#line 1195 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (5)].node)->parent = (yyval.node);
		(yyvsp[(2) - (5)].node)->parent = (yyval.node);
		(yyvsp[(3) - (5)].node)->parent = (yyval.node);
		(yyvsp[(4) - (5)].node)->parent = (yyval.node);
		(yyvsp[(5) - (5)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (5)].node);
                (yyvsp[(1) - (5)].node)->next = (yyvsp[(2) - (5)].node);
                (yyvsp[(2) - (5)].node)->next = (yyvsp[(3) - (5)].node);
                (yyvsp[(3) - (5)].node)->next = (yyvsp[(4) - (5)].node);
                (yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);}
    break;

  case 115:
/* Line 1787 of yacc.c  */
#line 1212 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL; }
    break;

  case 116:
/* Line 1787 of yacc.c  */
#line 1217 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 117:
/* Line 1787 of yacc.c  */
#line 1223 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 118:
/* Line 1787 of yacc.c  */
#line 1229 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 119:
/* Line 1787 of yacc.c  */
#line 1244 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
                (yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node); }
    break;

  case 120:
/* Line 1787 of yacc.c  */
#line 1252 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
                (yyvsp[(4) - (4)].node)->parent = (yyval.node);
                (yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
                (yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
                (yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
                (yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node); }
    break;

  case 121:
/* Line 1787 of yacc.c  */
#line 1267 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 122:
/* Line 1787 of yacc.c  */
#line 1273 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 123:
/* Line 1787 of yacc.c  */
#line 1286 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (5)].node)->parent = (yyval.node);
		(yyvsp[(2) - (5)].node)->parent = (yyval.node);
		(yyvsp[(3) - (5)].node)->parent = (yyval.node);
		(yyvsp[(4) - (5)].node)->parent = (yyval.node);
		(yyvsp[(5) - (5)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (5)].node);
                (yyvsp[(1) - (5)].node)->next = (yyvsp[(2) - (5)].node);
                (yyvsp[(2) - (5)].node)->next = (yyvsp[(3) - (5)].node);
                (yyvsp[(3) - (5)].node)->next = (yyvsp[(4) - (5)].node);
                (yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);}
    break;

  case 124:
/* Line 1787 of yacc.c  */
#line 1300 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 125:
/* Line 1787 of yacc.c  */
#line 1310 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 126:
/* Line 1787 of yacc.c  */
#line 1320 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL; }
    break;

  case 127:
/* Line 1787 of yacc.c  */
#line 1325 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 128:
/* Line 1787 of yacc.c  */
#line 1332 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 129:
/* Line 1787 of yacc.c  */
#line 1338 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 130:
/* Line 1787 of yacc.c  */
#line 1345 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL; }
    break;

  case 131:
/* Line 1787 of yacc.c  */
#line 1350 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 132:
/* Line 1787 of yacc.c  */
#line 1358 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;

  case 133:
/* Line 1787 of yacc.c  */
#line 1364 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
                (yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
                (yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node); }
    break;

  case 134:
/* Line 1787 of yacc.c  */
#line 1376 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		(yyval.node)->child = NULL; }
    break;

  case 135:
/* Line 1787 of yacc.c  */
#line 1381 "lua_lr.y"
    { (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = NONTERM;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node); }
    break;


/* Line 1787 of yacc.c  */
#line 3575 "lua_lr.parser.c"
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


/* Line 2050 of yacc.c  */
#line 1389 "lua_lr.y"


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
