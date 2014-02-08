#include "debug_functions.h"

#ifdef __DEBUG

void print_token_node_tree(parsing_ctx *ctx, uint32_t level, token_node *tree)
{
  uint32_t itr;
  token_node *child_itr = NULL;

  fprintf(stdout, "L:%03d", level);
  for (itr = 0; itr < level; itr++) {
    fprintf(stdout, "    ");
  }
  if (tree->value != NULL) {
    fprintf(stdout, "<%s>\n", (char *) tree->value);
  } else {
    fprintf(stdout, "<%s, %d>\n", ctx->gr_token_name[token_value(tree->token)], token_value(tree->token));
  }
  child_itr = tree->child;
  while (child_itr != NULL && child_itr->parent == tree) {
    print_token_node_tree(ctx, level + 1, child_itr);
    child_itr = child_itr->next;
  }
}

#endif
