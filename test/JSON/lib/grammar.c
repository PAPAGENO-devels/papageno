#include "grammar.h"

const gr_token __gr_token_alloc[] = {OBJECT, MEMBERS, PAIR, VALUE, STRING, CHARS, ARRAY, ELEMENTS, LBRACE, RBRACE, COMMA, COLON, NUMBER, BOOL, QUOTES, CHAR, LSQUARE, RSQUARE, __TERM};

const char * const __gr_token_name[] = {"OBJECT", "MEMBERS", "PAIR", "VALUE", "STRING", "CHARS", "ARRAY", "ELEMENTS", "LBRACE", "RBRACE", "COMMA", "COLON", "NUMBER", "BOOL", "QUOTES", "CHAR", "LSQUARE", "RSQUARE", "__TERM"};

const gr_rule __grammar[] = {
  {0, OBJECT, 2, (gr_token []){LBRACE, RBRACE}},
  {1, OBJECT, 3, (gr_token []){LBRACE, MEMBERS, RBRACE}},
  {2, MEMBERS, 1, (gr_token []){PAIR}},
  {3, MEMBERS, 3, (gr_token []){MEMBERS, COMMA, PAIR}},
  {4, MEMBERS, 1, (gr_token []){ELEMENTS}},
  {5, MEMBERS, 1, (gr_token []){CHARS}},
  {6, PAIR, 3, (gr_token []){STRING, COLON, VALUE}},
  {7, VALUE, 1, (gr_token []){STRING}},
  {8, VALUE, 1, (gr_token []){NUMBER}},
  {9, VALUE, 1, (gr_token []){OBJECT}},
  {10, VALUE, 1, (gr_token []){ARRAY}},
  {11, VALUE, 1, (gr_token []){BOOL}},
  {12, STRING, 2, (gr_token []){QUOTES, QUOTES}},
  {13, STRING, 3, (gr_token []){QUOTES, CHARS, QUOTES}},
  {14, CHARS, 1, (gr_token []){CHAR}},
  {15, CHARS, 2, (gr_token []){CHARS, CHAR}},
  {16, ARRAY, 2, (gr_token []){LSQUARE, RSQUARE}},
  {17, ARRAY, 3, (gr_token []){LSQUARE, ELEMENTS, RSQUARE}},
  {18, ELEMENTS, 1, (gr_token []){VALUE}},
  {19, ELEMENTS, 3, (gr_token []){ELEMENTS, COMMA, VALUE}}
};
void init_grammar(parsing_ctx *ctx)
{
  ctx->gr_token_alloc = __gr_token_alloc;
  ctx->gr_token_name = __gr_token_name;
  ctx->grammar = __grammar;
}
const char * gr_token_to_string(gr_token token){
  if (token < __NTERM_LEN)
    return __gr_token_name[token]; //token is a nonterminal
  else if (is_terminal(token))
    return __gr_token_name[token_value(token)];  //token is a terminal
  else {
  fprintf(stdout, "ERROR> gr_token_to_string received a malformed input token: %d\n", token);
    exit(1);
  }
}