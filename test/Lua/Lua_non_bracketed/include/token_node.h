#ifndef __TOKEN_NODE_H_
#define __TOKEN_NODE_H_

#include <stdlib.h>

#include "config.h"
#include "grammar_tokens.h"

typedef struct token_node {
	gr_token token; /**< Terminal token if leaf, else nonterminal token corresponding to the reduction of a rule. */
	void *value; /**< Semantic value of the node. Corresponds to the semantic value of the terminal token if the node is a leaf.*/
	struct token_node *next; /**< Next token in the current list. */
	struct token_node *parent; /**< Token corresponding to the token obtained by the reduction of the current one. */
	struct token_node *child; /**< First token of the rhs of the rule from which the current token was generated. */
} token_node;

token_node *new_token_node(gr_token token, void *value);
void free_token_node(token_node *node);

#endif
