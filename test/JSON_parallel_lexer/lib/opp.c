#include "opp.h"
#include "vect_stack.h"
#include <assert.h>
#include "reduction_list.h"
#include "matrix.h"
#include "reduction_tree.h"
#include "rewrite_rules.h"
#define __END_OF_INPUT 1
#define __MORE_INPUT 0

uint8_t rewrite_to_axiom(gr_token token)
{
    uint32_t offset;
    const uint32_t *end, *ptr;

    ptr = rewrite_rules;
    offset = ptr[token_value(token)];
    ptr = &ptr[offset];
    end = ptr + *ptr + 1;
    for (++ptr; ptr != end; ++ptr) {
	if (*ptr == __S) {
	    return 1;
	}
    }
    return 0;
}

uint32_t get_son_with(const uint16_t * tree, uint32_t offset, gr_token label)
{
	uint32_t itr;
    for (itr = offset + 2; itr < offset + tree[offset + 1] + 2; itr += 2) {
	if (tree[itr] == token_value(label)) {
	    return tree[itr + 1];
	}
    }
    return 0;
}

uint32_t get_next_token(token_node ** current_list_pos, 
			token_node ** prev_symbol_ptr, 
			token_node *  chunk_end, 
			token_node *  lookahead_ptr)
{
    *prev_symbol_ptr = *current_list_pos;
    /* end of chunk condition for the final chunk */
    if ((*current_list_pos)->next == NULL) {
	*current_list_pos = lookahead_ptr;
	return __END_OF_INPUT;
    }
    *current_list_pos = (*current_list_pos)->next;
    /* end of chunk condition for an inner chunk */
    if (*current_list_pos == chunk_end) {
	*current_list_pos = lookahead_ptr;
	return __END_OF_INPUT;
    }
    return __MORE_INPUT;
}

uint32_t get_precedence(token_node * current_list_pos, 
			token_node * last_terminal)
{
    uint32_t prec;
    prec = __PRECEDENCE(precedence_matrix, last_terminal->token, current_list_pos->token);
    return prec;
}


void cleanup_stack_and_lists(vect_stack * yields_prec_stack, 
			     reduction_list * red_list, 
			     reduction_list * temp_red_list)
{
    free_vect_stack(yields_prec_stack);
    free_reduction_list(red_list);
    free_reduction_list(temp_red_list);
}

void reduction_step(reduction_list * temp_reduction_list, 
		    uint32_t red_list_node, 
		    token_node * list_itr, 
		    parsing_ctx * ctx)
{
    uint32_t node, offset;
    const uint32_t *itr, *end;
    if (is_terminal(list_itr->token)) {
	itr = &ctx->gr_token_alloc[token_value(list_itr->token)];
	end = itr + 1;
    } else {
	offset = rewrite_rules[list_itr->token];
	itr = &(rewrite_rules[offset]);
	end = itr + *itr + 1;
	++itr;
    }
    /* For each token in the current stack element token list. */
    for (; itr != end; ++itr) {
	node = get_son_with(vect_reduction_tree, red_list_node, *itr);
	/* If current position has a son corresponding to the current token, navigate the tree. */
	if (node != 0) {
	    append_position_on_reduction_list(temp_reduction_list, node);
	}
    }
}

void perform_rewrite(token_node * rewrite_pos, 
		     gr_token current, 
		     gr_token lhs, 
		     vect_stack * stack, 
		     parsing_ctx * ctx)
{
    gr_token next;
    uint32_t node;
    const gr_rule *rule;
    uint32_t rule_number;

    while (current != lhs) {
	node = vect_reduction_tree[0];
	node = get_son_with(vect_reduction_tree, node, current);
	rule = &ctx->grammar[vect_reduction_tree[node]];
	//semantics_fun = rule->semantics;
	next = rule->lhs;
    rule_number = rule->rule_number;
	semantic_fun(rule_number, rewrite_pos, stack, ctx);
	current = next;
    }
}

void call_semantics(reduction_list * main_reduction_list, 
		    token_node * prev_symbol_ptr, 
		    vect_stack * stack, 
		    parsing_ctx * ctx)
{
    //gr_function semantics_fun;
    const gr_rule *rule;
    token_node *rewrite_pos;
    uint8_t rhs_itr;
    uint32_t rule_number;
    /* Manage rewrite rules. */
    rule = &ctx->grammar[vect_reduction_tree[get_reduction_position_at_index(main_reduction_list, 0)]];
    rewrite_pos = prev_symbol_ptr;
    for (rhs_itr = 0; rhs_itr < rule->rhs_length; ++rhs_itr) {
	/* Detect immediate rewrite token. */
	perform_rewrite(rewrite_pos, rewrite_pos->next->token, rule->rhs[rhs_itr], stack, ctx);
	rewrite_pos = rewrite_pos->next;
    }
    /* Reduce handle. */
    rule_number = rule->rule_number;
    //semantics_fun = rule->semantics;
    semantic_fun(rule_number, prev_symbol_ptr, stack, ctx);
}

uint32_t opp_parse(token_node * lookback_ptr, 
		      token_node * lookahead_ptr, 
		      token_node * list_begin, 
		      token_node * chunk_end, 
		      parsing_ctx * ctx)
{
    uint32_t parse_result = 0;
    reduction_list *main_reduction_list, *temp_reduction_list;	/* reduction_list represents where we are inside the reduction tree. */
    uint32_t end_chunk_parse = __MORE_INPUT;
    uint32_t reduction_error = 0;
    uint32_t node = 0;
    token_node * current_list_pos = list_begin;
    token_node * prev_symbol_ptr    = lookback_ptr;
    token_node * list_itr         = NULL;
    vect_stack yields_prec_stack,parsing_stack;
    token_node * last_terminal = NULL;
    uint32_t prec=0;
    vect_stack stack;
    
    init_vect_stack(&stack, ctx->NODE_ALLOC_SIZE);
    init_vect_stack(&yields_prec_stack, ctx->PREC_ALLOC_SIZE);
    init_vect_stack(&parsing_stack,     ctx->PREC_ALLOC_SIZE);

    main_reduction_list = (reduction_list *) malloc(sizeof(reduction_list));
    init_reduction_list(main_reduction_list);

    temp_reduction_list = (reduction_list *) malloc(sizeof(reduction_list));
    init_reduction_list(temp_reduction_list);

    /* set correctly last_terminal and current_pos */
    while ( !( is_terminal(current_list_pos->token) || end_chunk_parse ) ) {
	    end_chunk_parse = get_next_token(&current_list_pos, &prev_symbol_ptr, chunk_end, lookahead_ptr); 
	}
    last_terminal= is_terminal(lookback_ptr->token) ? lookback_ptr : current_list_pos;
    /* Start the parsing process. */
    while (current_list_pos != NULL) {
	/* lookup precedence between last stack terminal token and new token. */
        prec = get_precedence(current_list_pos,last_terminal);
        /*this was inserted by the guys: add the string terminator to the precedence table to remove this cruft */
        if (lookback_ptr->token == __TERM && prec == __EQ && yields_prec_stack.top_of_stack == 0) {
	     prec = __GT;
        }
	/* Invalid precedence value fetched from precedence table, abort parsing */
	if (prec == __NOP) {
	    parse_result = __PARSE_ERROR;
	    break;
	}
	/* if precedence is __EQ or __LT, we should shift */
	if (prec != __GT || yields_prec_stack.top_of_stack == 0) {
	    if (end_chunk_parse == __END_OF_INPUT) {
		parse_result = __PARSE_IN_PROGRESS;
		break;
	    }
	    /* Push token_node on top of yields_prec_stack. */
	    if (prec == __LT) {
               vect_stack_push(&yields_prec_stack, last_terminal, ctx->PREC_REALLOC_SIZE);
	    }
	    /* Get next token. */
	    assert(is_terminal(current_list_pos->token));
	    vect_stack_push(&parsing_stack, last_terminal, ctx->NODE_REALLOC_SIZE);
	    last_terminal=current_list_pos;
	    end_chunk_parse = get_next_token(&current_list_pos, &prev_symbol_ptr, chunk_end, lookahead_ptr);
	} else {
		/*clear reduction list */
	        main_reduction_list->idx_last = 0;
		/* node is the offset of the root of the vectorized reduction trie. */
		node = vect_reduction_tree[0];
		/* obtain the position of the previous yields precedence */
		prev_symbol_ptr = vect_stack_pop(&yields_prec_stack);
	        /* add pop to parsing stack to remove all the terminals up to the one 
		 which should be reduced */
		while (last_terminal!= prev_symbol_ptr && last_terminal!=NULL){
		  last_terminal=vect_stack_pop(&parsing_stack);
		}
		/* the stack pop should always be successful, as TOS !=0 
		 * it should_never get here*/
		assert(prev_symbol_ptr !=NULL);
		list_itr = prev_symbol_ptr->next;
		/* Set the first element of the reduction list to the root. */
		append_position_on_reduction_list(main_reduction_list, node);
		reduction_error = 0;

		/* starting from the previous yields precedence scan the candidate rhs and 
		 *match it against the reduction trie */
		while (list_itr != NULL && list_itr != current_list_pos && list_itr != chunk_end) {
		    /* For each available position in the reduction tree. */
		    uint32_t i;
		    for (i = 0; i < main_reduction_list->idx_last; i++) {
			reduction_step(temp_reduction_list, 
				       get_reduction_position_at_index(main_reduction_list, i), 
				       list_itr, 
		                       ctx);
		    }
		    swap_reduction_lists(&temp_reduction_list, &main_reduction_list);
		    /* erase temp_reduction_list */
		    temp_reduction_list->idx_last = 0;
		    list_itr = list_itr->next;
		    /* If there is at least one available position in the reduction tree after having considered current token, go on. */
		    if (main_reduction_list->idx_last <= 0) {
			reduction_error = 1;
			break;
		    }
		}
		
		/* Finished handle identification. */
		if (!reduction_error && vect_reduction_tree[get_reduction_position_at_index(main_reduction_list, 0)] == __GRAMMAR_SIZE) {
		    DEBUG_PRINT("Not in reducible position.\n")
			reduction_error = 1;
		}
		if (!reduction_error) {
		    call_semantics(main_reduction_list, prev_symbol_ptr, &stack, ctx);
		} else {
		    parse_result = __PARSE_NOT_RECOGNIZED;
		    break;
		}
		/* if the axiom is reached and only two terminators are left reduce and exit */
		if (lookback_ptr->token == __TERM && ctx->token_list->next == NULL && current_list_pos->token == __TERM &&
		    !is_terminal(ctx->token_list->token) && rewrite_to_axiom(ctx->token_list->token)) {
		    perform_rewrite(lookback_ptr, ctx->token_list->token, __S, &stack, ctx);
		    parse_result = __PARSE_SUCCESS;
		    break;
		}
	    }
	/* If next token is a nonterminal just move on. Eventually you might hit the terminator */
	while ( !( is_terminal(current_list_pos->token) || end_chunk_parse ) ) {
	    end_chunk_parse = get_next_token(&current_list_pos, &prev_symbol_ptr, chunk_end, lookahead_ptr);
	}
    }/*end of the parsing loop */
    cleanup_stack_and_lists(&yields_prec_stack, main_reduction_list, temp_reduction_list);
    return parse_result;
}


