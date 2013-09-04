#include "grammar_semantics.h"

/* Preamble from grammar definition. */
/* End of the preamble. */

void r_OBJECT_LBRACERBRACE(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_OBJECT, *p_LBRACE1, *p_RBRACE2;

  p_OBJECT = push_token_node_on_stack(stack, OBJECT, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_LBRACE1 = ctx->token_list;
    ctx->token_list = p_OBJECT;
  } else {
    p_LBRACE1 = p->next;
  }
  p->next = p_OBJECT;
  p_RBRACE2 = p_LBRACE1->next;
  p_LBRACE1->parent = p_OBJECT;
  p_RBRACE2->parent = p_OBJECT;
  p_OBJECT->next = p_RBRACE2->next;
  p_OBJECT->child = p_LBRACE1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_OBJECT_LBRACEMEMBERSRBRACE(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_OBJECT, *p_LBRACE1, *p_MEMBERS2, *p_RBRACE3;

  p_OBJECT = push_token_node_on_stack(stack, OBJECT, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_LBRACE1 = ctx->token_list;
    ctx->token_list = p_OBJECT;
  } else {
    p_LBRACE1 = p->next;
  }
  p->next = p_OBJECT;
  p_MEMBERS2 = p_LBRACE1->next;
  p_RBRACE3 = p_MEMBERS2->next;
  p_LBRACE1->parent = p_OBJECT;
  p_MEMBERS2->parent = p_OBJECT;
  p_RBRACE3->parent = p_OBJECT;
  p_OBJECT->next = p_RBRACE3->next;
  p_OBJECT->child = p_LBRACE1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_MEMBERS_PAIR(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_MEMBERS, *p_PAIR1;

  p_MEMBERS = push_token_node_on_stack(stack, MEMBERS, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_PAIR1 = ctx->token_list;
    ctx->token_list = p_MEMBERS;
  } else {
    p_PAIR1 = p->next;
  }
  p->next = p_MEMBERS;
  p_PAIR1->parent = p_MEMBERS;
  p_MEMBERS->next = p_PAIR1->next;
  p_MEMBERS->child = p_PAIR1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_MEMBERS_PAIRCOMMAMEMBERS(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_MEMBERS, *p_PAIR1, *p_COMMA2, *p_MEMBERS3;

  p_MEMBERS = push_token_node_on_stack(stack, MEMBERS, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_PAIR1 = ctx->token_list;
    ctx->token_list = p_MEMBERS;
  } else {
    p_PAIR1 = p->next;
  }
  p->next = p_MEMBERS;
  p_COMMA2 = p_PAIR1->next;
  p_MEMBERS3 = p_COMMA2->next;
  p_PAIR1->parent = p_MEMBERS;
  p_COMMA2->parent = p_MEMBERS;
  p_MEMBERS3->parent = p_MEMBERS;
  p_MEMBERS->next = p_MEMBERS3->next;
  p_MEMBERS->child = p_PAIR1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_PAIR_STRINGCOLONVALUE(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_PAIR, *p_STRING1, *p_COLON2, *p_VALUE3;

  p_PAIR = push_token_node_on_stack(stack, PAIR, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_STRING1 = ctx->token_list;
    ctx->token_list = p_PAIR;
  } else {
    p_STRING1 = p->next;
  }
  p->next = p_PAIR;
  p_COLON2 = p_STRING1->next;
  p_VALUE3 = p_COLON2->next;
  p_STRING1->parent = p_PAIR;
  p_COLON2->parent = p_PAIR;
  p_VALUE3->parent = p_PAIR;
  p_PAIR->next = p_VALUE3->next;
  p_PAIR->child = p_STRING1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_VALUE_STRING(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_VALUE, *p_STRING1;

  p_VALUE = push_token_node_on_stack(stack, VALUE, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_STRING1 = ctx->token_list;
    ctx->token_list = p_VALUE;
  } else {
    p_STRING1 = p->next;
  }
  p->next = p_VALUE;
  p_STRING1->parent = p_VALUE;
  p_VALUE->next = p_STRING1->next;
  p_VALUE->child = p_STRING1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_VALUE_NUMBER(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_VALUE, *p_NUMBER1;

  p_VALUE = push_token_node_on_stack(stack, VALUE, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_NUMBER1 = ctx->token_list;
    ctx->token_list = p_VALUE;
  } else {
    p_NUMBER1 = p->next;
  }
  p->next = p_VALUE;
  p_NUMBER1->parent = p_VALUE;
  p_VALUE->next = p_NUMBER1->next;
  p_VALUE->child = p_NUMBER1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_VALUE_OBJECT(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_VALUE, *p_OBJECT1;

  p_VALUE = push_token_node_on_stack(stack, VALUE, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_OBJECT1 = ctx->token_list;
    ctx->token_list = p_VALUE;
  } else {
    p_OBJECT1 = p->next;
  }
  p->next = p_VALUE;
  p_OBJECT1->parent = p_VALUE;
  p_VALUE->next = p_OBJECT1->next;
  p_VALUE->child = p_OBJECT1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_VALUE_ARRAY(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_VALUE, *p_ARRAY1;

  p_VALUE = push_token_node_on_stack(stack, VALUE, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_ARRAY1 = ctx->token_list;
    ctx->token_list = p_VALUE;
  } else {
    p_ARRAY1 = p->next;
  }
  p->next = p_VALUE;
  p_ARRAY1->parent = p_VALUE;
  p_VALUE->next = p_ARRAY1->next;
  p_VALUE->child = p_ARRAY1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_VALUE_BOOL(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_VALUE, *p_BOOL1;

  p_VALUE = push_token_node_on_stack(stack, VALUE, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_BOOL1 = ctx->token_list;
    ctx->token_list = p_VALUE;
  } else {
    p_BOOL1 = p->next;
  }
  p->next = p_VALUE;
  p_BOOL1->parent = p_VALUE;
  p_VALUE->next = p_BOOL1->next;
  p_VALUE->child = p_BOOL1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_STRING_QUOTESQUOTES(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_STRING, *p_QUOTES1, *p_QUOTES2;

  p_STRING = push_token_node_on_stack(stack, STRING, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_QUOTES1 = ctx->token_list;
    ctx->token_list = p_STRING;
  } else {
    p_QUOTES1 = p->next;
  }
  p->next = p_STRING;
  p_QUOTES2 = p_QUOTES1->next;
  p_QUOTES1->parent = p_STRING;
  p_QUOTES2->parent = p_STRING;
  p_STRING->next = p_QUOTES2->next;
  p_STRING->child = p_QUOTES1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_STRING_QUOTESCHARSQUOTES(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_STRING, *p_QUOTES1, *p_CHARS2, *p_QUOTES3;

  p_STRING = push_token_node_on_stack(stack, STRING, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_QUOTES1 = ctx->token_list;
    ctx->token_list = p_STRING;
  } else {
    p_QUOTES1 = p->next;
  }
  p->next = p_STRING;
  p_CHARS2 = p_QUOTES1->next;
  p_QUOTES3 = p_CHARS2->next;
  p_QUOTES1->parent = p_STRING;
  p_CHARS2->parent = p_STRING;
  p_QUOTES3->parent = p_STRING;
  p_STRING->next = p_QUOTES3->next;
  p_STRING->child = p_QUOTES1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_CHARS_CHAR(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_CHARS, *p_CHAR1;

  p_CHARS = push_token_node_on_stack(stack, CHARS, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_CHAR1 = ctx->token_list;
    ctx->token_list = p_CHARS;
  } else {
    p_CHAR1 = p->next;
  }
  p->next = p_CHARS;
  p_CHAR1->parent = p_CHARS;
  p_CHARS->next = p_CHAR1->next;
  p_CHARS->child = p_CHAR1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_CHARS_CHARCHARS(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_CHARS, *p_CHAR1, *p_CHARS2;

  p_CHARS = push_token_node_on_stack(stack, CHARS, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_CHAR1 = ctx->token_list;
    ctx->token_list = p_CHARS;
  } else {
    p_CHAR1 = p->next;
  }
  p->next = p_CHARS;
  p_CHARS2 = p_CHAR1->next;
  p_CHAR1->parent = p_CHARS;
  p_CHARS2->parent = p_CHARS;
  p_CHARS->next = p_CHARS2->next;
  p_CHARS->child = p_CHAR1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_ARRAY_LSQUARERSQUARE(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_ARRAY, *p_LSQUARE1, *p_RSQUARE2;

  p_ARRAY = push_token_node_on_stack(stack, ARRAY, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_LSQUARE1 = ctx->token_list;
    ctx->token_list = p_ARRAY;
  } else {
    p_LSQUARE1 = p->next;
  }
  p->next = p_ARRAY;
  p_RSQUARE2 = p_LSQUARE1->next;
  p_LSQUARE1->parent = p_ARRAY;
  p_RSQUARE2->parent = p_ARRAY;
  p_ARRAY->next = p_RSQUARE2->next;
  p_ARRAY->child = p_LSQUARE1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_ARRAY_LSQUAREELEMENTSRSQUARE(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_ARRAY, *p_LSQUARE1, *p_ELEMENTS2, *p_RSQUARE3;

  p_ARRAY = push_token_node_on_stack(stack, ARRAY, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_LSQUARE1 = ctx->token_list;
    ctx->token_list = p_ARRAY;
  } else {
    p_LSQUARE1 = p->next;
  }
  p->next = p_ARRAY;
  p_ELEMENTS2 = p_LSQUARE1->next;
  p_RSQUARE3 = p_ELEMENTS2->next;
  p_LSQUARE1->parent = p_ARRAY;
  p_ELEMENTS2->parent = p_ARRAY;
  p_RSQUARE3->parent = p_ARRAY;
  p_ARRAY->next = p_RSQUARE3->next;
  p_ARRAY->child = p_LSQUARE1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_ELEMENTS_VALUE(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_ELEMENTS, *p_VALUE1;

  p_ELEMENTS = push_token_node_on_stack(stack, ELEMENTS, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_VALUE1 = ctx->token_list;
    ctx->token_list = p_ELEMENTS;
  } else {
    p_VALUE1 = p->next;
  }
  p->next = p_ELEMENTS;
  p_VALUE1->parent = p_ELEMENTS;
  p_ELEMENTS->next = p_VALUE1->next;
  p_ELEMENTS->child = p_VALUE1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

void r_ELEMENTS_VALUECOMMAELEMENTS(token_node *p, token_node_stack *stack, parsing_ctx *ctx)
{
  token_node *p_ELEMENTS, *p_VALUE1, *p_COMMA2, *p_ELEMENTS3;

  p_ELEMENTS = push_token_node_on_stack(stack, ELEMENTS, NULL, ctx->NODE_REALLOC_SIZE);
  if (p->token == TERM) {
    p_VALUE1 = ctx->token_list;
    ctx->token_list = p_ELEMENTS;
  } else {
    p_VALUE1 = p->next;
  }
  p->next = p_ELEMENTS;
  p_COMMA2 = p_VALUE1->next;
  p_ELEMENTS3 = p_COMMA2->next;
  p_VALUE1->parent = p_ELEMENTS;
  p_COMMA2->parent = p_ELEMENTS;
  p_ELEMENTS3->parent = p_ELEMENTS;
  p_ELEMENTS->next = p_ELEMENTS3->next;
  p_ELEMENTS->child = p_VALUE1;
/* Semantic action follows. */
{ }
/* End of semantic action. */
}

