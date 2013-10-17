#include "token_node.h"

token_node *new_token_node(gr_token token, void *value)
{
    token_node *temp = (token_node*) malloc(sizeof(token_node));

    temp->token = token;
    temp->value = value;
    temp->next = NULL;
    temp->parent = NULL;
    temp->child = NULL;

    return temp;
}

void free_token_node(token_node *node)
{
	token_node *itr = NULL;
	if (node == NULL) {
		return;
	}
	if (node->parent != NULL) {
		free_token_node(node->parent);
	}
	if (node->value != NULL) {
		free(node->value);
	}
    itr = node->next;
	while(itr != NULL && itr->parent == node->parent) {
		itr->parent = NULL;
		itr = itr->next;
	}
	free(node);
}

