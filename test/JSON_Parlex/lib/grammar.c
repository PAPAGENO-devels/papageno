#include "grammar.h"

const gr_token __gr_token_alloc[] = {OBJECT, MEMBERS, PAIR, VALUE, STRING, CHARS, ARRAY, ELEMENTS, LBRACE, RBRACE, COMMA, COLON, NUMBER, BOOL, QUOTES, CHAR, LSQUARE, RSQUARE, TERM};

const char * const __gr_token_name[] = {"OBJECT", "MEMBERS", "PAIR", "VALUE", "STRING", "CHARS", "ARRAY", "ELEMENTS", "LBRACE", "RBRACE", "COMMA", "COLON", "NUMBER", "BOOL", "QUOTES", "CHAR", "LSQUARE", "RSQUARE", "TERM"};

const gr_rule __grammar[] = {
  {OBJECT, &r_OBJECT_LBRACERBRACE, 2, (gr_token []){LBRACE, RBRACE}},
  {OBJECT, &r_OBJECT_LBRACEMEMBERSRBRACE, 3, (gr_token []){LBRACE, MEMBERS, RBRACE}},
  {MEMBERS, &r_MEMBERS_PAIR, 1, (gr_token []){PAIR}},
  {MEMBERS, &r_MEMBERS_PAIRCOMMAMEMBERS, 3, (gr_token []){PAIR, COMMA, MEMBERS}},
  {PAIR, &r_PAIR_STRINGCOLONVALUE, 3, (gr_token []){STRING, COLON, VALUE}},
  {VALUE, &r_VALUE_STRING, 1, (gr_token []){STRING}},
  {VALUE, &r_VALUE_NUMBER, 1, (gr_token []){NUMBER}},
  {VALUE, &r_VALUE_OBJECT, 1, (gr_token []){OBJECT}},
  {VALUE, &r_VALUE_ARRAY, 1, (gr_token []){ARRAY}},
  {VALUE, &r_VALUE_BOOL, 1, (gr_token []){BOOL}},
  {STRING, &r_STRING_QUOTESQUOTES, 2, (gr_token []){QUOTES, QUOTES}},
  {STRING, &r_STRING_QUOTESCHARSQUOTES, 3, (gr_token []){QUOTES, CHARS, QUOTES}},
  {CHARS, &r_CHARS_CHAR, 1, (gr_token []){CHAR}},
  {CHARS, &r_CHARS_CHARCHARS, 2, (gr_token []){CHAR, CHARS}},
  {ARRAY, &r_ARRAY_LSQUARERSQUARE, 2, (gr_token []){LSQUARE, RSQUARE}},
  {ARRAY, &r_ARRAY_LSQUAREELEMENTSRSQUARE, 3, (gr_token []){LSQUARE, ELEMENTS, RSQUARE}},
  {ELEMENTS, &r_ELEMENTS_VALUE, 1, (gr_token []){VALUE}},
  {ELEMENTS, &r_ELEMENTS_VALUECOMMAELEMENTS, 3, (gr_token []){VALUE, COMMA, ELEMENTS}}
};
void init_grammar(parsing_ctx *ctx)
{
  ctx->gr_token_alloc = __gr_token_alloc;
  ctx->gr_token_name = __gr_token_name;
  ctx->grammar = __grammar;
}
const char * gr_token_to_string(gr_token token){
  if (token < NTERM_LEN)
    return __gr_token_name[token]; //token is a nonterminal
  else if (is_terminal(token))
    return __gr_token_name[token_value(token)];  //token is a terminal
  else {
  fprintf(stdout, "ERROR> gr_token_to_string received a malformed input token: %d\n", token);
    exit(1);
  }
}