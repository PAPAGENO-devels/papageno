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
#line 1 "lua.y"

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


/* Line 371 of yacc.c  */
#line 107 "lua.tab.c"

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
   by #include "lua.tab.h".  */
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
/* Line 387 of yacc.c  */
#line 40 "lua.y"

	token_node *node;


/* Line 387 of yacc.c  */
#line 210 "lua.tab.c"
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

/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 238 "lua.tab.c"

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
#define YYFINAL  59
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   683

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  56
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  25
/* YYNRULES -- Number of rules.  */
#define YYNRULES  101
/* YYNRULES -- Number of states.  */
#define YYNSTATES  203

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
       0,     0,     3,     5,     6,     8,    11,    13,    15,    18,
      20,    24,    26,    28,    30,    33,    37,    43,    48,    57,
      64,    72,    78,    90,   100,   108,   112,   117,   122,   125,
     130,   136,   138,   141,   144,   148,   152,   154,   158,   160,
     164,   166,   170,   172,   177,   181,   183,   187,   189,   193,
     195,   197,   199,   201,   203,   205,   207,   209,   211,   215,
     219,   223,   227,   231,   235,   239,   243,   247,   251,   255,
     259,   263,   267,   271,   274,   277,   280,   282,   284,   288,
     291,   296,   300,   303,   305,   307,   310,   316,   321,   323,
     327,   329,   333,   336,   338,   341,   344,   346,   350,   354,
     360,   364
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      57,     0,    -1,    58,    -1,    -1,    59,    -1,    59,    62,
      -1,    62,    -1,    60,    -1,    59,    60,    -1,    33,    -1,
      66,    13,    69,    -1,    72,    -1,    63,    -1,     3,    -1,
      17,    24,    -1,     7,    58,    12,    -1,    38,    70,     7,
      58,    12,    -1,    30,    58,    37,    70,    -1,    18,    70,
      35,    58,    61,    10,    58,    12,    -1,    18,    70,    35,
      58,    61,    12,    -1,    18,    70,    35,    58,    10,    58,
      12,    -1,    18,    70,    35,    58,    12,    -1,    15,    24,
      13,    70,     6,    70,     6,    70,     7,    58,    12,    -1,
      15,    24,    13,    70,     6,    70,     7,    58,    12,    -1,
      15,    68,    19,    69,     7,    58,    12,    -1,    16,    64,
      75,    -1,    22,    16,    24,    75,    -1,    22,    68,    13,
      69,    -1,    22,    68,    -1,    11,    70,    35,    58,    -1,
      61,    11,    70,    35,    58,    -1,    31,    -1,    31,    69,
      -1,    31,    33,    -1,    31,    69,    33,    -1,     5,    24,
       5,    -1,    65,    -1,    65,     4,    24,    -1,    24,    -1,
      65,     8,    24,    -1,    67,    -1,    66,     6,    67,    -1,
      24,    -1,    71,    21,    70,    29,    -1,    71,     8,    24,
      -1,    24,    -1,    68,     6,    24,    -1,    70,    -1,    69,
       6,    70,    -1,    25,    -1,    14,    -1,    36,    -1,    26,
      -1,    34,    -1,     9,    -1,    74,    -1,    71,    -1,    77,
      -1,    70,    27,    70,    -1,    70,    39,    70,    -1,    70,
      45,    70,    -1,    70,    44,    70,    -1,    70,    43,    70,
      -1,    70,    42,    70,    -1,    70,    41,    70,    -1,    70,
      40,    70,    -1,    70,    46,    70,    -1,    70,    48,    70,
      -1,    70,    47,    70,    -1,    70,    51,    70,    -1,    70,
      50,    70,    -1,    70,    49,    70,    -1,    70,    55,    70,
      -1,    54,    70,    -1,    53,    70,    -1,    47,    70,    -1,
      67,    -1,    72,    -1,    23,    70,    32,    -1,    71,    73,
      -1,    71,     4,    24,    73,    -1,    23,    69,    32,    -1,
      23,    32,    -1,    77,    -1,    34,    -1,    16,    75,    -1,
      23,    76,    32,    58,    12,    -1,    23,    32,    58,    12,
      -1,    68,    -1,    68,     6,     9,    -1,     9,    -1,    20,
      78,    28,    -1,    20,    28,    -1,    79,    -1,    79,     6,
      -1,    79,    33,    -1,    80,    -1,    79,     6,    80,    -1,
      79,    33,    80,    -1,    21,    70,    29,    13,    70,    -1,
      24,    13,    70,    -1,    70,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   117,   117,   122,   129,   138,   148,   158,   166,   179,
     187,   199,   207,   215,   223,   233,   245,   261,   275,   297,
     315,   335,   351,   379,   403,   423,   435,   449,   463,   475,
     476,   494,   502,   512,   522,   536,   550,   558,   572,   580,
     594,   602,   616,   623,   637,   651,   659,   673,   681,   695,
     703,   711,   719,   727,   735,   743,   751,   759,   767,   779,
     791,   803,   815,   827,   839,   851,   863,   875,   887,   899,
     911,   923,   935,   947,   957,   967,   979,   987,   995,  1009,
    1019,  1035,  1047,  1057,  1065,  1075,  1087,  1102,  1118,  1126,
    1138,  1148,  1160,  1172,  1180,  1190,  1202,  1210,  1222,  1236,
    1252,  1264
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "BREAK", "COLON", "COLON2", "COMMA",
  "DO", "DOT", "DOT3", "ELSE", "ELSEIF", "END", "EQ", "FALSE", "FOR",
  "FUNCTION", "GOTO", "IF", "IN", "LBRACE", "LBRACK", "LOCAL", "LPAREN",
  "NAME", "NIL", "NUMBER", "OR", "RBRACE", "RBRACK", "REPEAT", "RETURN",
  "RPAREN", "SEMI", "STRING", "THEN", "TRUE", "UNTIL", "WHILE", "AND",
  "EQ2", "NEQ", "GTEQ", "LTEQ", "GT", "LT", "DOT2", "MINUS", "PLUS",
  "PERCENT", "DIVIDE", "ASTERISK", "UMINUS", "SHARP", "NOT", "CARET",
  "$accept", "chunk", "block", "statList", "stat", "elseIfBlock",
  "retStat", "label", "funcName", "nameDotList", "varList", "var",
  "nameList", "exprList", "expr", "prefixExp", "functionCall", "args",
  "functionDef", "funcBody", "parList", "tableConstructor", "fieldList",
  "fieldListBody", "field", YY_NULL
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
       0,    56,    57,    58,    58,    58,    58,    59,    59,    60,
      60,    60,    60,    60,    60,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    60,    60,    60,    60,    60,    61,
      61,    62,    62,    62,    62,    63,    64,    64,    65,    65,
      66,    66,    67,    67,    67,    68,    68,    69,    69,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    71,    71,    71,    72,
      72,    73,    73,    73,    73,    74,    75,    75,    76,    76,
      76,    77,    77,    78,    78,    78,    79,    79,    79,    80,
      80,    80
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     0,     1,     2,     1,     1,     2,     1,
       3,     1,     1,     1,     2,     3,     5,     4,     8,     6,
       7,     5,    11,     9,     7,     3,     4,     4,     2,     4,
       5,     1,     2,     2,     3,     3,     1,     3,     1,     3,
       1,     3,     1,     4,     3,     1,     3,     1,     3,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     2,     2,     2,     1,     1,     3,     2,
       4,     3,     2,     1,     1,     2,     5,     4,     1,     3,
       1,     3,     2,     1,     2,     2,     1,     3,     3,     5,
       3,     1
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       3,    13,     0,     3,     0,     0,     0,     0,     0,     0,
      42,     3,    31,     9,     0,     0,     2,     4,     7,     6,
      12,     0,    76,     0,    11,     0,     0,    45,     0,    38,
       0,    36,    14,    54,    50,     0,     0,    49,    52,    53,
      51,     0,     0,     0,    76,     0,    56,    77,    55,    57,
       0,    45,    28,     0,     0,    33,    32,    47,     0,     1,
       8,     5,     0,     0,     0,     0,     0,     0,    84,    79,
      83,    35,    15,     0,     0,     0,     0,    25,     0,     0,
      85,     0,    42,    92,   101,     0,    93,    96,    75,    74,
      73,     0,     3,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    78,
       0,     0,    34,     3,    76,    10,     0,    44,     0,    82,
       0,     0,    46,     0,    90,     3,    88,     0,    37,    39,
       0,     0,    91,    94,    95,    58,     0,    59,    65,    64,
      63,    62,    61,    60,    66,    68,    67,    71,    70,    69,
      72,    26,    27,    17,    48,     0,    80,    43,    81,     0,
       3,     0,     0,     3,     0,   100,    97,    98,     3,     0,
      21,     0,    16,     0,     0,    87,    89,     0,     0,     0,
       0,     3,     0,    19,     0,     3,    24,    86,    99,    20,
       3,     0,     0,     0,     0,    29,    18,     3,     3,    23,
      30,     0,    22
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    15,    16,    17,    18,   171,    19,    20,    30,    31,
      21,    44,    28,    56,    57,    46,    47,    69,    48,    77,
     127,    49,    85,    86,    87
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -48
static const yytype_int16 yypact[] =
{
     460,   -48,   -14,   460,    18,    22,    43,   434,    44,   434,
     -48,   460,   341,   -48,   434,    32,   -48,   460,   -48,   -48,
     -48,    63,    93,    87,     4,    65,    60,    83,    84,   -48,
      77,    67,   -48,   -48,   -48,    77,   122,   -48,   -48,   -48,
     -48,   434,   434,   434,   -48,   462,    87,   -48,   -48,   -48,
      81,   -48,    96,   487,    82,   -48,     1,   612,   207,   -48,
     -48,   -48,   106,   434,    90,   102,   434,   373,   -48,   -48,
     -48,   -48,   -48,   434,   108,   434,     9,   -48,   113,   116,
     -48,   434,   131,   -48,   612,   121,     3,   -48,    97,    97,
      97,   434,   460,   434,   434,   434,   434,   434,   434,   434,
     434,   434,   434,   434,   434,   434,   434,    77,   434,   -48,
     434,   434,   -48,   460,    98,   148,    78,   -48,   512,   -48,
      34,    38,   -48,   110,   -48,   460,   149,   125,   -48,   -48,
     537,   434,   -48,   408,   408,   267,    11,   628,   222,   222,
     222,   222,   222,   222,   222,    73,    73,    97,    97,    97,
      97,   -48,   148,   612,   612,   147,   -48,   -48,   -48,   434,
     460,   152,    21,   460,   158,   612,   -48,   -48,   460,   434,
     -48,   123,   -48,     8,   160,   -48,   -48,   161,   434,   162,
     562,   460,   434,   -48,   434,   460,   -48,   -48,   612,   -48,
     460,   165,   587,   294,   166,   -48,   -48,   460,   460,   -48,
     -48,   167,   -48
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -48,   -48,    28,   -48,   144,   -48,   163,   -48,   -48,   -48,
     -48,     0,    -2,   -47,   194,     2,    26,    66,   -48,   -34,
     -48,   -19,   -48,   -48,    33
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -78
static const yytype_int16 yytable[] =
{
      22,    80,    23,    22,    70,    23,    52,   111,   -77,   133,
      25,    22,   -77,    23,   184,   185,   115,    22,   124,    23,
     120,   168,   169,   170,   -77,   -77,    24,    70,   123,    24,
     176,    26,    59,    51,   112,    91,   134,    24,   -77,    54,
     111,   125,    27,    24,   159,   122,    29,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
      50,   152,   114,   106,    23,    91,   158,    32,    51,    62,
      71,    78,    72,   151,   126,    79,    63,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
      74,    64,    22,   106,    23,    65,    73,    70,    36,   -40,
      76,    67,    74,    75,   -41,   107,   -40,    36,    66,   108,
      67,   -41,    68,    22,   116,    23,   111,   160,    24,   110,
     136,    68,   103,   104,   105,    22,   117,    23,   106,     9,
      10,    33,   122,   181,   182,   183,    34,   128,    35,    24,
     129,   155,    36,    81,   131,     9,    82,    37,    38,   132,
      83,    24,   106,   161,   111,   162,    39,   163,    40,   172,
      22,    60,    23,    22,   175,    23,   166,   167,    22,    41,
      23,   178,   186,   187,   189,    42,    43,   196,   199,   202,
      61,    22,   156,    23,     0,    22,    24,    23,   174,    24,
      22,   177,    23,     0,    24,     0,   179,    22,    22,    23,
      23,    45,     0,    53,     0,     0,     0,    24,    58,   191,
       0,    24,     0,   194,   113,     0,    24,     0,   195,     0,
       0,     0,     0,    24,    24,   200,   201,     0,     0,     0,
      84,     0,     0,     0,    91,    88,    89,    90,     0,     0,
       0,     0,     0,     0,     0,     0,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,     0,
     118,     0,   106,     0,     0,     0,     0,   121,   100,   101,
     102,   103,   104,   105,     0,   130,     0,   106,     0,     0,
       0,     0,     0,     0,     0,   135,     0,   137,   138,   139,
     140,   141,   142,   143,   144,   145,   146,   147,   148,   149,
     150,   198,     0,     0,   153,   154,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,     0,
       0,    91,   106,     0,     0,   165,     0,    84,    84,     0,
       0,     0,     0,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,   103,   104,   105,     0,     0,     0,   106,
      33,     0,     0,   173,     0,    34,     0,    35,     0,     0,
       0,    36,     0,   180,     9,    10,    37,    38,     0,     0,
       0,     0,   188,     0,    55,    39,   192,    40,   193,     0,
       0,     0,    33,     0,     0,     0,     0,    34,    41,    35,
       0,     0,     0,    36,    42,    43,     9,    10,    37,    38,
       0,     0,     0,     0,     0,   119,     0,    39,     0,    40,
       0,     0,     0,     0,     0,     0,     0,    33,     0,     0,
      41,     0,    34,     0,    35,     0,    42,    43,    36,    81,
       0,     9,    82,    37,    38,     0,     0,     0,     0,     0,
       0,     0,    39,    33,    40,     0,     0,     0,    34,     0,
      35,     0,     0,     0,    36,    41,     0,     9,    10,    37,
      38,    42,    43,     1,     0,     2,     0,     3,    39,     0,
      40,     0,     0,     0,     0,     4,     5,     6,     7,     0,
       0,    41,     8,     9,    10,     0,     0,    42,    43,    91,
      11,    12,     0,    13,     0,     0,     0,    92,    14,     0,
       0,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   104,   105,    91,     0,     0,   106,     0,   109,
       0,     0,     0,     0,     0,     0,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,    91,
       0,   157,   106,     0,     0,     0,     0,     0,     0,     0,
       0,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   104,   105,    91,     0,   164,   106,     0,     0,
       0,     0,     0,     0,     0,     0,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,    91,
       0,     0,   106,     0,     0,     0,     0,   190,     0,     0,
       0,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   104,   105,    91,     0,     0,   106,     0,     0,
       0,     0,   197,     0,     0,     0,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,    91,
       0,     0,   106,     0,     0,     0,     0,     0,     0,     0,
       0,    93,    94,    95,    96,    97,    98,    99,   100,   101,
     102,   103,   104,   105,     0,     0,     0,   106,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
       0,     0,     0,   106
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-48)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
       0,    35,     0,     3,    23,     3,     8,     6,     4,     6,
      24,    11,     8,    11,     6,     7,    63,    17,     9,    17,
      67,    10,    11,    12,    20,    21,     0,    46,    75,     3,
       9,     3,     0,    24,    33,    27,    33,    11,    34,    11,
       6,    32,    24,    17,     6,    24,    24,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      16,   108,    62,    55,    62,    27,    32,    24,    24,     6,
       5,     4,    12,   107,    76,     8,    13,    39,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
       6,     4,    92,    55,    92,     8,    13,   116,    20,     6,
      23,    23,     6,    19,     6,    24,    13,    20,    21,    13,
      23,    13,    34,   113,    24,   113,     6,     7,    92,    37,
      92,    34,    49,    50,    51,   125,    24,   125,    55,    23,
      24,     9,    24,    10,    11,    12,    14,    24,    16,   113,
      24,   113,    20,    21,    13,    23,    24,    25,    26,    28,
      28,   125,    55,   125,     6,     6,    34,    32,    36,    12,
     160,    17,   160,   163,    12,   163,   133,   134,   168,    47,
     168,    13,    12,    12,    12,    53,    54,    12,    12,    12,
      17,   181,   116,   181,    -1,   185,   160,   185,   160,   163,
     190,   163,   190,    -1,   168,    -1,   168,   197,   198,   197,
     198,     7,    -1,     9,    -1,    -1,    -1,   181,    14,   181,
      -1,   185,    -1,   185,     7,    -1,   190,    -1,   190,    -1,
      -1,    -1,    -1,   197,   198,   197,   198,    -1,    -1,    -1,
      36,    -1,    -1,    -1,    27,    41,    42,    43,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    -1,
      66,    -1,    55,    -1,    -1,    -1,    -1,    73,    46,    47,
      48,    49,    50,    51,    -1,    81,    -1,    55,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    91,    -1,    93,    94,    95,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
     106,     7,    -1,    -1,   110,   111,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    -1,
      -1,    27,    55,    -1,    -1,   131,    -1,   133,   134,    -1,
      -1,    -1,    -1,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    -1,    -1,    -1,    55,
       9,    -1,    -1,   159,    -1,    14,    -1,    16,    -1,    -1,
      -1,    20,    -1,   169,    23,    24,    25,    26,    -1,    -1,
      -1,    -1,   178,    -1,    33,    34,   182,    36,   184,    -1,
      -1,    -1,     9,    -1,    -1,    -1,    -1,    14,    47,    16,
      -1,    -1,    -1,    20,    53,    54,    23,    24,    25,    26,
      -1,    -1,    -1,    -1,    -1,    32,    -1,    34,    -1,    36,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     9,    -1,    -1,
      47,    -1,    14,    -1,    16,    -1,    53,    54,    20,    21,
      -1,    23,    24,    25,    26,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    34,     9,    36,    -1,    -1,    -1,    14,    -1,
      16,    -1,    -1,    -1,    20,    47,    -1,    23,    24,    25,
      26,    53,    54,     3,    -1,     5,    -1,     7,    34,    -1,
      36,    -1,    -1,    -1,    -1,    15,    16,    17,    18,    -1,
      -1,    47,    22,    23,    24,    -1,    -1,    53,    54,    27,
      30,    31,    -1,    33,    -1,    -1,    -1,    35,    38,    -1,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    27,    -1,    -1,    55,    -1,    32,
      -1,    -1,    -1,    -1,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    27,
      -1,    29,    55,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    27,    -1,    29,    55,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    27,
      -1,    -1,    55,    -1,    -1,    -1,    -1,    35,    -1,    -1,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    27,    -1,    -1,    55,    -1,    -1,
      -1,    -1,    35,    -1,    -1,    -1,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    27,
      -1,    -1,    55,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    -1,    -1,    -1,    55,    40,    41,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      -1,    -1,    -1,    55
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     5,     7,    15,    16,    17,    18,    22,    23,
      24,    30,    31,    33,    38,    57,    58,    59,    60,    62,
      63,    66,    67,    71,    72,    24,    58,    24,    68,    24,
      64,    65,    24,     9,    14,    16,    20,    25,    26,    34,
      36,    47,    53,    54,    67,    70,    71,    72,    74,    77,
      16,    24,    68,    70,    58,    33,    69,    70,    70,     0,
      60,    62,     6,    13,     4,     8,    21,    23,    34,    73,
      77,     5,    12,    13,     6,    19,    23,    75,     4,     8,
      75,    21,    24,    28,    70,    78,    79,    80,    70,    70,
      70,    27,    35,    39,    40,    41,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    55,    24,    13,    32,
      37,     6,    33,     7,    67,    69,    24,    24,    70,    32,
      69,    70,    24,    69,     9,    32,    68,    76,    24,    24,
      70,    13,    28,     6,    33,    70,    58,    70,    70,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    70,    70,
      70,    75,    69,    70,    70,    58,    73,    29,    32,     6,
       7,    58,     6,    32,    29,    70,    80,    80,    10,    11,
      12,    61,    12,    70,    58,    12,     9,    58,    13,    58,
      70,    10,    11,    12,     6,     7,    12,    12,    70,    12,
      35,    58,    70,    70,    58,    58,    12,    35,     7,    12,
      58,    58,    12
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
#line 117 "lua.y"
    {
		fprintf(stderr, "BISON> finished parsing.\n");
		bison_tree = (yyvsp[(1) - (1)].node);}
    break;

  case 3:
/* Line 1787 of yacc.c  */
#line 122 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyval.node)->next = NULL;
		}
    break;

  case 4:
/* Line 1787 of yacc.c  */
#line 129 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 5:
/* Line 1787 of yacc.c  */
#line 138 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 6:
/* Line 1787 of yacc.c  */
#line 148 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 7:
/* Line 1787 of yacc.c  */
#line 158 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 8:
/* Line 1787 of yacc.c  */
#line 166 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 9:
/* Line 1787 of yacc.c  */
#line 179 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 10:
/* Line 1787 of yacc.c  */
#line 187 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 11:
/* Line 1787 of yacc.c  */
#line 199 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 12:
/* Line 1787 of yacc.c  */
#line 207 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 13:
/* Line 1787 of yacc.c  */
#line 215 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 14:
/* Line 1787 of yacc.c  */
#line 223 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 15:
/* Line 1787 of yacc.c  */
#line 233 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 16:
/* Line 1787 of yacc.c  */
#line 245 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);
		}
    break;

  case 17:
/* Line 1787 of yacc.c  */
#line 261 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
		(yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
		(yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
		(yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);
		}
    break;

  case 18:
/* Line 1787 of yacc.c  */
#line 275 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (8)].node)->parent = (yyval.node);
		(yyvsp[(2) - (8)].node)->parent = (yyval.node);
		(yyvsp[(3) - (8)].node)->parent = (yyval.node);
		(yyvsp[(4) - (8)].node)->parent = (yyval.node);
		(yyvsp[(5) - (8)].node)->parent = (yyval.node);
		(yyvsp[(6) - (8)].node)->parent = (yyval.node);
		(yyvsp[(7) - (8)].node)->parent = (yyval.node);
		(yyvsp[(8) - (8)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (8)].node);
		(yyvsp[(1) - (8)].node)->next = (yyvsp[(2) - (8)].node);
		(yyvsp[(2) - (8)].node)->next = (yyvsp[(3) - (8)].node);
		(yyvsp[(3) - (8)].node)->next = (yyvsp[(4) - (8)].node);
		(yyvsp[(4) - (8)].node)->next = (yyvsp[(5) - (8)].node);
		(yyvsp[(5) - (8)].node)->next = (yyvsp[(6) - (8)].node);
		(yyvsp[(6) - (8)].node)->next = (yyvsp[(7) - (8)].node);
		(yyvsp[(7) - (8)].node)->next = (yyvsp[(8) - (8)].node);
		}
    break;

  case 19:
/* Line 1787 of yacc.c  */
#line 297 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(5) - (6)].node)->next = (yyvsp[(6) - (6)].node);
		}
    break;

  case 20:
/* Line 1787 of yacc.c  */
#line 315 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(6) - (7)].node)->next = (yyvsp[(7) - (7)].node);
		}
    break;

  case 21:
/* Line 1787 of yacc.c  */
#line 335 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);
		}
    break;

  case 22:
/* Line 1787 of yacc.c  */
#line 351 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(10) - (11)].node)->next = (yyvsp[(11) - (11)].node);
		}
    break;

  case 23:
/* Line 1787 of yacc.c  */
#line 379 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(8) - (9)].node)->next = (yyvsp[(9) - (9)].node);
		}
    break;

  case 24:
/* Line 1787 of yacc.c  */
#line 403 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(6) - (7)].node)->next = (yyvsp[(7) - (7)].node);
		}
    break;

  case 25:
/* Line 1787 of yacc.c  */
#line 423 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 26:
/* Line 1787 of yacc.c  */
#line 435 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
		(yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
		(yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
		(yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);
		}
    break;

  case 27:
/* Line 1787 of yacc.c  */
#line 449 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
		(yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
		(yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
		(yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);
		}
    break;

  case 28:
/* Line 1787 of yacc.c  */
#line 463 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 30:
/* Line 1787 of yacc.c  */
#line 476 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);
		}
    break;

  case 31:
/* Line 1787 of yacc.c  */
#line 494 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 32:
/* Line 1787 of yacc.c  */
#line 502 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 33:
/* Line 1787 of yacc.c  */
#line 512 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 34:
/* Line 1787 of yacc.c  */
#line 522 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 35:
/* Line 1787 of yacc.c  */
#line 536 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 36:
/* Line 1787 of yacc.c  */
#line 550 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 37:
/* Line 1787 of yacc.c  */
#line 558 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 38:
/* Line 1787 of yacc.c  */
#line 572 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 39:
/* Line 1787 of yacc.c  */
#line 580 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 40:
/* Line 1787 of yacc.c  */
#line 594 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 41:
/* Line 1787 of yacc.c  */
#line 602 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 42:
/* Line 1787 of yacc.c  */
#line 616 "lua.y"
    {    (yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 43:
/* Line 1787 of yacc.c  */
#line 623 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
		(yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
		(yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
		(yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);
		}
    break;

  case 44:
/* Line 1787 of yacc.c  */
#line 637 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 45:
/* Line 1787 of yacc.c  */
#line 651 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 46:
/* Line 1787 of yacc.c  */
#line 659 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 47:
/* Line 1787 of yacc.c  */
#line 673 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 48:
/* Line 1787 of yacc.c  */
#line 681 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 49:
/* Line 1787 of yacc.c  */
#line 695 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 50:
/* Line 1787 of yacc.c  */
#line 703 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 51:
/* Line 1787 of yacc.c  */
#line 711 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 52:
/* Line 1787 of yacc.c  */
#line 719 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 53:
/* Line 1787 of yacc.c  */
#line 727 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 54:
/* Line 1787 of yacc.c  */
#line 735 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 55:
/* Line 1787 of yacc.c  */
#line 743 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 56:
/* Line 1787 of yacc.c  */
#line 751 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 57:
/* Line 1787 of yacc.c  */
#line 759 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 58:
/* Line 1787 of yacc.c  */
#line 767 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 59:
/* Line 1787 of yacc.c  */
#line 779 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 60:
/* Line 1787 of yacc.c  */
#line 791 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 61:
/* Line 1787 of yacc.c  */
#line 803 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 62:
/* Line 1787 of yacc.c  */
#line 815 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 63:
/* Line 1787 of yacc.c  */
#line 827 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 64:
/* Line 1787 of yacc.c  */
#line 839 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 65:
/* Line 1787 of yacc.c  */
#line 851 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 66:
/* Line 1787 of yacc.c  */
#line 863 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 67:
/* Line 1787 of yacc.c  */
#line 875 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 68:
/* Line 1787 of yacc.c  */
#line 887 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 69:
/* Line 1787 of yacc.c  */
#line 899 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 70:
/* Line 1787 of yacc.c  */
#line 911 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 71:
/* Line 1787 of yacc.c  */
#line 923 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 72:
/* Line 1787 of yacc.c  */
#line 935 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 73:
/* Line 1787 of yacc.c  */
#line 947 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 74:
/* Line 1787 of yacc.c  */
#line 957 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 75:
/* Line 1787 of yacc.c  */
#line 967 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 76:
/* Line 1787 of yacc.c  */
#line 979 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 77:
/* Line 1787 of yacc.c  */
#line 987 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 78:
/* Line 1787 of yacc.c  */
#line 995 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 79:
/* Line 1787 of yacc.c  */
#line 1009 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 80:
/* Line 1787 of yacc.c  */
#line 1019 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
		(yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
		(yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
		(yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);
		}
    break;

  case 81:
/* Line 1787 of yacc.c  */
#line 1035 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 82:
/* Line 1787 of yacc.c  */
#line 1047 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 83:
/* Line 1787 of yacc.c  */
#line 1057 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 84:
/* Line 1787 of yacc.c  */
#line 1065 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 85:
/* Line 1787 of yacc.c  */
#line 1075 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 86:
/* Line 1787 of yacc.c  */
#line 1087 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (5)].node)->parent = (yyval.node);
		(yyvsp[(2) - (5)].node)->parent = (yyval.node);
		(yyvsp[(3) - (5)].node)->parent = (yyval.node);
		(yyvsp[(4) - (5)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (5)].node);
		(yyvsp[(1) - (5)].node)->next = (yyvsp[(2) - (5)].node);
		(yyvsp[(2) - (5)].node)->next = (yyvsp[(3) - (5)].node);
		(yyvsp[(3) - (5)].node)->next = (yyvsp[(4) - (5)].node);
		(yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);
		}
    break;

  case 87:
/* Line 1787 of yacc.c  */
#line 1102 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (4)].node)->parent = (yyval.node);
		(yyvsp[(2) - (4)].node)->parent = (yyval.node);
		(yyvsp[(3) - (4)].node)->parent = (yyval.node);
		(yyvsp[(4) - (4)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (4)].node);
		(yyvsp[(1) - (4)].node)->next = (yyvsp[(2) - (4)].node);
		(yyvsp[(2) - (4)].node)->next = (yyvsp[(3) - (4)].node);
		(yyvsp[(3) - (4)].node)->next = (yyvsp[(4) - (4)].node);		
		}
    break;

  case 88:
/* Line 1787 of yacc.c  */
#line 1118 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 89:
/* Line 1787 of yacc.c  */
#line 1126 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 90:
/* Line 1787 of yacc.c  */
#line 1138 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 91:
/* Line 1787 of yacc.c  */
#line 1148 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 92:
/* Line 1787 of yacc.c  */
#line 1160 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 93:
/* Line 1787 of yacc.c  */
#line 1172 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 94:
/* Line 1787 of yacc.c  */
#line 1180 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 95:
/* Line 1787 of yacc.c  */
#line 1190 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (2)].node)->parent = (yyval.node);
		(yyvsp[(2) - (2)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (2)].node);
		(yyvsp[(1) - (2)].node)->next = (yyvsp[(2) - (2)].node);
		}
    break;

  case 96:
/* Line 1787 of yacc.c  */
#line 1202 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;

  case 97:
/* Line 1787 of yacc.c  */
#line 1210 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 98:
/* Line 1787 of yacc.c  */
#line 1222 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 99:
/* Line 1787 of yacc.c  */
#line 1236 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
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
		(yyvsp[(4) - (5)].node)->next = (yyvsp[(5) - (5)].node);
		}
    break;

  case 100:
/* Line 1787 of yacc.c  */
#line 1252 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (3)].node)->parent = (yyval.node);
		(yyvsp[(2) - (3)].node)->parent = (yyval.node);
		(yyvsp[(3) - (3)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (3)].node);
		(yyvsp[(1) - (3)].node)->next = (yyvsp[(2) - (3)].node);
		(yyvsp[(2) - (3)].node)->next = (yyvsp[(3) - (3)].node);
		}
    break;

  case 101:
/* Line 1787 of yacc.c  */
#line 1264 "lua.y"
    {
		(yyval.node) = (token_node*) malloc(sizeof(token_node));
		(yyval.node)->token = OBJECT;
		(yyval.node)->value = NULL;
		(yyvsp[(1) - (1)].node)->parent = (yyval.node);
		(yyval.node)->next = NULL;
		(yyval.node)->child = (yyvsp[(1) - (1)].node);
		}
    break;


/* Line 1787 of yacc.c  */
#line 3310 "lua.tab.c"
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


