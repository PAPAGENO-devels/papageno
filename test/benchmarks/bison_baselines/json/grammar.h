#ifndef GRAMMAR_H_
#define GRAMMAR_H_

typedef enum gr_token {
	OBJECT = 0, MEMBERS, PAIR, VALUE, STRING, CHARS, ARRAY, ELEMENTS,
	LBRACE = 0x80000008, RBRACE, LSQUARE, RSQUARE, COMMA, COLON, BOOL, QUOTES, CHAR, NUMBER, TERM
} gr_token;

typedef struct token_node {
	gr_token token; /**< Terminal token if leaf, else nonterminal token corresponding to the reduction of a rule. */
	void *value; /**< Semantic value of the node. Corresponds to the semantic value of the terminal token if the node is a leaf.*/
	struct token_node *next; /**< Next token in the current list. */
	struct token_node *parent; /**< Token corresponding to the token obtained by the reduction of the current one. */
	struct token_node *child; /**< First token of the rhs of the rule from which the current token was generated. */
} token_node;

#endif
