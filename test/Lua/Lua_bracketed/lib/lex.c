#include "lex.h"

struct lex_token* flex_token;
parsing_ctx * ctx = NULL;
//Stack used to distinguish the body of a function from the context of a table
context_token *func_table_stack;


void compute_alloc_realloc_size(FILE *input_file, uint32_t *alloc_size, uint32_t *realloc_size)
{
  fseek(input_file, 0, SEEK_END);
  *alloc_size = ((float) ftell(input_file)) / TOKEN_SIZE;
  *realloc_size = *alloc_size/10;
  fseek(input_file, 0, SEEK_SET);
}

void append_token_node(gr_token token, void* semantic_value, token_node **token_builder, token_node_stack *stack, uint32_t realloc_size, int8_t handle_context)
{
  gr_token top;
  if (handle_context) {
    //Rename token according to the operator precedence form of the grammar
    switch (token) {
      case XEQ:
        if (top_context(func_table_stack) == 1)
          token = EQ;
        break;
      case LBRACE:
      case DO:
      case IF:
        push_context(&func_table_stack, token);
        break;
      case RBRACE:
        if (func_table_stack == NULL) {
          fprintf(stdout, "Input file has non balanced braces. Exit.\n");
          exit(1);
        }
        top = pop_context(&func_table_stack);
        if (top != LBRACE) {
          fprintf(stdout, "Input file has non balanced braces. Exit.\n");
          exit(1);
        }
        break;  
      case SEMI:
        if (top_context(func_table_stack) == 1)
          token = SEMIFIELD;
        break; 
      case END:
        if (func_table_stack != NULL) {
          top = pop_context(&func_table_stack);
          if (top == LBRACE) {
            fprintf(stdout, "Input file has non balanced open and closed contexts. Exit.\n");
            exit(1);
          }
        }
        break;  
      case FUNCTION:
        push_context(&func_table_stack, token);
        break;        
      default:
        break;
    }
  }
  token_node *tok = push_token_node_on_stack(stack, token, semantic_value, realloc_size);
  if (ctx->token_list == NULL) {
    ctx->token_list = tok;
    *token_builder = tok;
  } else {
    (*token_builder)->next = tok;
    *token_builder = tok;
  }
}

void perform_lexing(char *file_name, parsing_ctx *c)
{
  uint32_t token_list_length = 0, alloc_size = 0, realloc_size = 0;
  int8_t flex_return_code;
  token_node *token_builder = NULL;
  token_node_stack stack;

  ctx = c;
  func_table_stack = NULL;

  yyin = fopen(file_name, "r");
  if (yyin == NULL) {
    DEBUG_STDOUT_PRINT("ERROR> could not open input file. Aborting.\n")
    exit(1);
  }

  compute_alloc_realloc_size(yyin, &alloc_size, &realloc_size);
  DEBUG_STDOUT_PRINT("LEXER> alloc_size %d, realloc_size %d\n", alloc_size, realloc_size)
  ctx->token_list = NULL;
  init_token_node_stack(&stack, alloc_size);
  flex_token = (lex_token*) malloc(sizeof(lex_token));
  //Initialize flex_token
  flex_token->handle_context = 0;
  flex_token->string_buffer = (char*) malloc(sizeof(char)*MAX_BUFFER_SIZE); 
  if (flex_token->string_buffer == NULL) {
     DEBUG_STDOUT_PRINT("LEXER> Error: could not complete malloc string_buffer. Aborting.\n");
     exit(1);
  } 

  flex_return_code = yylex();

  while (flex_return_code != END_OF_FILE) {
    if (flex_return_code == LEX_CORRECT) {
      append_token_node(flex_token->token, flex_token->semantic_value, &token_builder, &stack, realloc_size, flex_token->handle_context);
      DEBUG_STDOUT_PRINT("Lexer read token : %x = %s\n", flex_token->token, (char *)flex_token->semantic_value)  
      ++token_list_length;
    }
    else if (flex_return_code == ADD_SEMI) {
      //append both SEMI and token to the token list
      append_token_node((gr_token) SEMI, ";", &token_builder, &stack, realloc_size, 0);
      DEBUG_STDOUT_PRINT("Lexer added token SEMI\n")           
      append_token_node(flex_token->token, flex_token->semantic_value, &token_builder, &stack, realloc_size, flex_token->handle_context);
      DEBUG_STDOUT_PRINT("Lexer read token : %x = %s\n", flex_token->token, (char *)flex_token->semantic_value)  
      token_list_length +=2;   
    }
    else {//flex_return_code is ERROR
      DEBUG_STDOUT_PRINT("Lexer scanned erroneous input. Abort.\n")
      fclose(yyin);
      exit(1);
    }

    if (flex_token->handle_context == 1)
      flex_token->handle_context = 0;
    flex_return_code = yylex();

  }

  ctx->token_list_length = token_list_length;
  fclose(yyin);

  //Empty input file (only with spaces)
  if(ctx->token_list_length == 0) {
    fprintf(stdout, "Input file is empty. Exit.\n");
    exit(1);
  }

  #ifdef DEBUG
  DEBUG_STDOUT_PRINT("ctx->token_list_length is %d\n", ctx->token_list_length)
  token_node * temp = ctx->token_list;
  int32_t i;
  for(i = 0; i<ctx->token_list_length; i++)
  {
    DEBUG_STDOUT_PRINT("token number %d is %s = %x with semantic_value = %s\n", i, gr_token_to_string(temp->token), temp->token, (char*) temp->value)
    temp = temp->next;
  }
  #endif
}
