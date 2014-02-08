#ifndef __FLEX_TOKEN_H_
#define __FLEX_TOKEN_H_

#include "grammar_tokens.h"

typedef struct lex_token {
  gr_token token[2];  /**< The gr_token representation of the token. There are two possible tokens: the first one is not valid if yylex returns __FIRST_LIST_LEXING_ERROR, 
                      the second one is not valid if it returns __SECOND_LIST_LEXING_ERROR*/
  int32_t token_lex_list_length; /*length of the sequence of CHAR tokens read while scanning a string */
  void *semantic_value; /**< The semantic value of the token. */
  int8_t begin_with_string;
  int8_t state_before_rsolidus;
  int32_t quotes_number;
} lex_token;

/*flex_token is used by flex to save the tokens inside lex_token_list.*/


#endif
