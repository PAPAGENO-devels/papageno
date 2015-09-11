#include "grammar_semantics.h"

/* Preamble from grammar definition. */
/* End of the preamble. */

void semantic_fun(uint32_t rule_number, token_node *p, vect_stack *stack, parsing_ctx *ctx){

  switch(rule_number){
    case 0:
    {
      // variables declaration
      token_node *p_OBJECT, *p_LBRACE1, *p_RBRACE2;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = OBJECT;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_OBJECT = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 1:
    {
      // variables declaration
      token_node *p_OBJECT, *p_LBRACE1, *p_MEMBERS2, *p_RBRACE3;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = OBJECT;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_OBJECT = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 2:
    {
      // variables declaration
      token_node *p_MEMBERS, *p_PAIR1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = MEMBERS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_MEMBERS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 3:
    {
      // variables declaration
      token_node *p_MEMBERS, *p_MEMBERS1, *p_COMMA2, *p_PAIR3;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = MEMBERS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_MEMBERS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
        p_MEMBERS1 = ctx->token_list;
        ctx->token_list = p_MEMBERS;
      } else {
        p_MEMBERS1 = p->next;
      }
      p->next = p_MEMBERS;
      p_COMMA2 = p_MEMBERS1->next;
      p_PAIR3 = p_COMMA2->next;
      p_MEMBERS1->parent = p_MEMBERS;
      p_COMMA2->parent = p_MEMBERS;
      p_PAIR3->parent = p_MEMBERS;
      p_MEMBERS->next = p_PAIR3->next;
      p_MEMBERS->child = p_MEMBERS1;
      /* Semantic action follows. */
      { }
      /* End of semantic action. */
    }
    break;
    case 4:
    {
      // variables declaration
      token_node *p_MEMBERS, *p_ELEMENTS1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = MEMBERS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_MEMBERS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
        p_ELEMENTS1 = ctx->token_list;
        ctx->token_list = p_MEMBERS;
      } else {
        p_ELEMENTS1 = p->next;
      }
      p->next = p_MEMBERS;
      p_ELEMENTS1->parent = p_MEMBERS;
      p_MEMBERS->next = p_ELEMENTS1->next;
      p_MEMBERS->child = p_ELEMENTS1;
      /* Semantic action follows. */
      { }
      /* End of semantic action. */
    }
    break;
    case 5:
    {
      // variables declaration
      token_node *p_MEMBERS, *p_CHARS1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = MEMBERS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_MEMBERS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
        p_CHARS1 = ctx->token_list;
        ctx->token_list = p_MEMBERS;
      } else {
        p_CHARS1 = p->next;
      }
      p->next = p_MEMBERS;
      p_CHARS1->parent = p_MEMBERS;
      p_MEMBERS->next = p_CHARS1->next;
      p_MEMBERS->child = p_CHARS1;
      /* Semantic action follows. */
      { }
      /* End of semantic action. */
    }
    break;
    case 6:
    {
      // variables declaration
      token_node *p_PAIR, *p_STRING1, *p_COLON2, *p_VALUE3;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = PAIR;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_PAIR = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 7:
    {
      // variables declaration
      token_node *p_VALUE, *p_STRING1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = VALUE;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_VALUE = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 8:
    {
      // variables declaration
      token_node *p_VALUE, *p_NUMBER1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = VALUE;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_VALUE = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 9:
    {
      // variables declaration
      token_node *p_VALUE, *p_OBJECT1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = VALUE;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_VALUE = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 10:
    {
      // variables declaration
      token_node *p_VALUE, *p_ARRAY1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = VALUE;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_VALUE = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 11:
    {
      // variables declaration
      token_node *p_VALUE, *p_BOOL1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = VALUE;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_VALUE = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 12:
    {
      // variables declaration
      token_node *p_STRING, *p_QUOTES1, *p_QUOTES2;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = STRING;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_STRING = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 13:
    {
      // variables declaration
      token_node *p_STRING, *p_QUOTES1, *p_CHARS2, *p_QUOTES3;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = STRING;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_STRING = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 14:
    {
      // variables declaration
      token_node *p_CHARS, *p_CHAR1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = CHARS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_CHARS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 15:
    {
      // variables declaration
      token_node *p_CHARS, *p_CHARS1, *p_CHAR2;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = CHARS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_CHARS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
        p_CHARS1 = ctx->token_list;
        ctx->token_list = p_CHARS;
      } else {
        p_CHARS1 = p->next;
      }
      p->next = p_CHARS;
      p_CHAR2 = p_CHARS1->next;
      p_CHARS1->parent = p_CHARS;
      p_CHAR2->parent = p_CHARS;
      p_CHARS->next = p_CHAR2->next;
      p_CHARS->child = p_CHARS1;
      /* Semantic action follows. */
      { }
      /* End of semantic action. */
    }
    break;
    case 16:
    {
      // variables declaration
      token_node *p_ARRAY, *p_LSQUARE1, *p_RSQUARE2;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = ARRAY;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_ARRAY = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 17:
    {
      // variables declaration
      token_node *p_ARRAY, *p_LSQUARE1, *p_ELEMENTS2, *p_RSQUARE3;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = ARRAY;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_ARRAY = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 18:
    {
      // variables declaration
      token_node *p_ELEMENTS, *p_VALUE1;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = ELEMENTS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_ELEMENTS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
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
    break;
    case 19:
    {
      // variables declaration
      token_node *p_ELEMENTS, *p_ELEMENTS1, *p_COMMA2, *p_VALUE3;
      token_node *ttp = (token_node*) malloc(sizeof(token_node));
      ttp->token = ELEMENTS;
      ttp->value = NULL;
      ttp->next = NULL;
      ttp->parent = NULL;
      ttp->child = NULL;
      p_ELEMENTS = vect_stack_push(stack, ttp, ctx->NODE_REALLOC_SIZE);
      if (p->token == __TERM) {
        p_ELEMENTS1 = ctx->token_list;
        ctx->token_list = p_ELEMENTS;
      } else {
        p_ELEMENTS1 = p->next;
      }
      p->next = p_ELEMENTS;
      p_COMMA2 = p_ELEMENTS1->next;
      p_VALUE3 = p_COMMA2->next;
      p_ELEMENTS1->parent = p_ELEMENTS;
      p_COMMA2->parent = p_ELEMENTS;
      p_VALUE3->parent = p_ELEMENTS;
      p_ELEMENTS->next = p_VALUE3->next;
      p_ELEMENTS->child = p_ELEMENTS1;
      /* Semantic action follows. */
      { }
      /* End of semantic action. */
    }
    break;
  }
}