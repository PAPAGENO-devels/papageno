import ctypes

def emit_precedence_matrix_header(intMatrix,terminals_no,out_header_path): 
  print "Generating include/matrix.h"
  matrix_h = open(out_header_path + "matrix.h", "w")
  if ((terminals_no %4)==0):
    matrix_row_length= terminals_no/4
  else:
    matrix_row_length = terminals_no/4 + 1
  matrix_h.write("""
#ifndef MATRIX_H_
#define MATRIX_H_
		 
#include "parsing_context.h"

#define ROW_LEN  %d/**< Length of a row of the precedence matrix measured in bytes. */""" % matrix_row_length)
  matrix_h.write("""
#define PRECEDENCE(matrix, i, j) ((uint32_t)((((matrix)[gr_term_key(i)*ROW_LEN + (gr_term_key(j) >> 2)]) >> (6 - 2*(gr_term_key(j) & 0x03))) & 0x03))

static const uint8_t precedence_matrix[ROW_LEN*TERM_LEN] = {%d""" % intMatrix[0])
  for i in range(1, len(intMatrix)):
    matrix_h.write(", %d" % intMatrix[i])
  matrix_h.write("""};
#endif
""")
  matrix_h.close()
  
def emit_grammar_symbols(nonterminals,terminals,axiom,out_header_path):
  nonterminal_bit_flag_pos=30
  nonterminal_bit_mask=1<<nonterminal_bit_flag_pos

  print "Generating include/grammar_tokens.h"
  grammar_tokens_h = open(out_header_path + "grammar_tokens.h", "w")
  grammar_tokens_h.write("""
			 #ifndef FLEX_GRAMMAR_H_
			 
			 #define FLEX_GRAMMAR_H_
			 
			 """)
  grammar_tokens_h.write("#define TOKEN_NUM %d\n" % (len(nonterminals) + len(terminals)))
  grammar_tokens_h.write("#define NTERM_LEN %d\n" % len(nonterminals))
  grammar_tokens_h.write("#define TERM_LEN  %d\n" % len(terminals))
  grammar_tokens_h.write("#define S %s\n\n" % axiom)
  grammar_tokens_h.write("#define is_terminal(token) ((uint8_t)((token & 0x%08X" % ctypes.c_uint32(nonterminal_bit_mask).value )
  grammar_tokens_h.write(") >> %d))\n"% nonterminal_bit_flag_pos)
  grammar_tokens_h.write("#define token_value(token) ((uint32_t)(token & 0x%08X))\n" % ctypes.c_uint32(~nonterminal_bit_mask).value )
  grammar_tokens_h.write("#define gr_term_key(token) (token_value(token) - NTERM_LEN)\n")
  grammar_tokens_h.write("#define gr_nterm_key(token)(token_value(token))\n")
  grammar_tokens_h.write("#define gr_term_token(key) ((gr_token)(0x%08X | (key + NTERM_LEN)))\n" % ctypes.c_uint32(~nonterminal_bit_mask).value )
  grammar_tokens_h.write("#define gr_nterm_token(key) ((gr_token)key)\n\n")
  grammar_tokens_h.write("typedef enum gr_token {\n")
  grammar_tokens_h.write("  %s = 0," % axiom)
  for nonterminal in nonterminals:
    if not nonterminal == axiom:
      grammar_tokens_h.write(" %s," % nonterminal)
  terminalHead = True
  for terminal in terminals:
    if terminalHead:
      grammar_tokens_h.write("\n  %s = %s" % (terminal, hex(len(nonterminals) | nonterminal_bit_mask)))
      terminalHead = False
    else:
      grammar_tokens_h.write(", %s" % terminal)
  grammar_tokens_h.write("\n} gr_token;\n\n#endif\n")
  grammar_tokens_h.close()

def emit_semantic_actions_header(rules,out_header_path):
  print "Generating include/grammar_semantics.h"
  grammar_semantics_h = open(out_header_path + "grammar_semantics.h", "w")
  grammar_semantics_h.write("""#ifndef GRAMMAR_SEMANTICS_H_
#define GRAMMAR_SEMANTICS_H_

#include "token_node.h"
#include "token_node_stack.h"
#include "parsing_context.h"

""")
  for rule in rules:
    grammar_semantics_h.write("void %s(token_node *p, token_node_stack *stack, parsing_ctx *ctx);\n" % rule.headerName)
  grammar_semantics_h.write("\n#endif\n")
  grammar_semantics_h.close()


def emit_grammar_header(rules,out_header_path):
  print "Generating include/grammar.h"
  grammar_h = open(out_header_path + "grammar.h", "w+")
  grammar_h.write("""#ifndef GRAMMAR_H_
#define GRAMMAR_H_

#include <stdio.h>

#include "config.h"
#include "parsing_context.h"
#include "grammar_tokens.h"
#include "grammar_semantics.h"
#include "token_node.h"
#include "token_node_stack.h"
""")
  grammar_h.write("#define GRAMMAR_SIZE %d\n\n" % len(rules))
  grammar_h.write("""typedef void (*gr_function) (token_node *, token_node_stack *, parsing_ctx *);
typedef struct gr_rule {
  gr_token lhs;
  gr_function semantics;
  uint8_t rhs_length;
  gr_token *rhs;
} gr_rule;

void init_grammar(parsing_ctx *ctx);

const char * gr_token_to_string(gr_token token);

#endif
""")
  grammar_h.close()

def emit_grammar(terminals, nonterminals, axiom, rules, out_core):
  print "Generating lib/grammar.c"
  grammar_c = open(out_core + "grammar.c", "w")
  grammar_c.write('#include "grammar.h"\n\n')
  grammar_c.write('const gr_token __gr_token_alloc[] = {%s' % axiom)
  for nonterminal in nonterminals:
    if nonterminal == axiom:
      continue
    grammar_c.write(', %s' % nonterminal)
  for terminal in terminals:
    grammar_c.write(', %s' % terminal)
  grammar_c.write('};\n\n')
  grammar_c.write('const char * const __gr_token_name[] = {"%s"' % axiom)
  for nonterminal in nonterminals:
    if nonterminal == axiom:
      continue
    grammar_c.write(', "%s"' % nonterminal)
  for terminal in terminals:
    grammar_c.write(', "%s"' % terminal)
  grammar_c.write('};\n\n')
  grammar_c.write('const gr_rule __grammar[] = {')
  rule = rules[0]
  grammar_c.write('\n  {%s, &%s, %d, (gr_token []){%s' % (rule.lhs, rule.headerName, len(rule.rhs), rule.rhs[0]))
  for rhsIndex in range(1, len(rule.rhs)):
    grammar_c.write(', %s' % rule.rhs[rhsIndex])
  grammar_c.write('}}')
  for rule in rules[1:]:
    grammar_c.write(',\n  {%s, &%s, %d, (gr_token []){%s' % (rule.lhs, rule.headerName, len(rule.rhs), rule.rhs[0]))
    for rhsIndex in range(1, len(rule.rhs)):
      grammar_c.write(', %s' % rule.rhs[rhsIndex])
    grammar_c.write('}}')
  grammar_c.write("""
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
  fprintf(stdout, \"ERROR> gr_token_to_string received a malformed input token: %d\\n\", token);
    exit(1);
  }
}""")
  grammar_c.close()
  
def emit_semantic_actions(rules,cPreamble, out_core):
  print "Generating lib/grammar_semantics.c"
  grammar_semantics_c = open(out_core + "grammar_semantics.c", "w")
  grammar_semantics_c.write('#include "grammar_semantics.h"\n\n')
  grammar_semantics_c.write('/* Preamble from grammar definition. */\n%s/* End of the preamble. */\n\n' % cPreamble)
  for rule in rules:
    grammar_semantics_c.write("void %s(token_node *p, token_node_stack *stack, parsing_ctx *ctx)\n{\n" % rule.headerName)
    grammar_semantics_c.write("  token_node *%s" % rule.tokenMap["lhs"])
    for rhsIndex in range(0, len(rule.rhs)):
      grammar_semantics_c.write(", *%s" % rule.tokenMap[rhsIndex + 1])
    grammar_semantics_c.write(";\n\n")
    grammar_semantics_c.write("  %s = push_token_node_on_stack(stack, %s, NULL, ctx->NODE_REALLOC_SIZE);\n" % (rule.tokenMap["lhs"], rule.lhs))
    grammar_semantics_c.write("  if (p->token == TERM) {\n")
    grammar_semantics_c.write("    %s = ctx->token_list;\n" % rule.tokenMap[1])
    grammar_semantics_c.write("    ctx->token_list = %s;\n" % rule.tokenMap["lhs"])
    grammar_semantics_c.write("  } else {\n")
    grammar_semantics_c.write("    %s = p->next;\n" % rule.tokenMap[1])
    grammar_semantics_c.write("  }\n")
    grammar_semantics_c.write("  p->next = %s;\n" % rule.tokenMap["lhs"])
    for rhsIndex in range(1, len(rule.rhs)):
      grammar_semantics_c.write("  %s = %s->next;\n" % (rule.tokenMap[rhsIndex + 1], rule.tokenMap[rhsIndex]))
    for rhsIndex in range(0, len(rule.rhs)):
      grammar_semantics_c.write("  %s->parent = %s;\n" % (rule.tokenMap[rhsIndex + 1], rule.tokenMap["lhs"]))
    grammar_semantics_c.write("  %s->next = %s->next;\n" % (rule.tokenMap["lhs"], rule.tokenMap[len(rule.rhs)]))
    grammar_semantics_c.write("  %s->child = %s;\n" % (rule.tokenMap["lhs"], rule.tokenMap[1]))
    grammar_semantics_c.write("/* Semantic action follows. */\n%s\n/* End of semantic action. */\n}\n\n" % rule.text)
  grammar_semantics_c.close()
  
  
def emit_reduction_tree(vectorTree,out_header_path):
  print "Generating include/reduction_tree.h"
  vectorized_tree_c = open(out_header_path + "reduction_tree.h", "w")
  vectorized_tree_c.write('#ifndef REDUCTION_TREE_H\n#define REDUCTION_TREE_H\n static const uint16_t vect_reduction_tree[] = {%d' % vectorTree[0])
  for i in range(1, len(vectorTree)):
    vectorized_tree_c.write(", %d" % vectorTree[i])
  vectorized_tree_c.write("""};\n#endif""")
  vectorized_tree_c.close()

def emit_rewrite_rules(realRewrite, out_header):
  print "Generating lib/rewrite_rules.c"
  rewrite_rules_c = open(out_header + "rewrite_rules.h", "w")
  rewrite_rules_c.write("""#ifndef REWRITE_RULES_H_
#define REWRITE_RULES_H_
#include "config.h"
#include "parsing_context.h"
""")
  rewrite_rules_c.write('static const uint32_t rewrite_rules[] = {%d' % realRewrite[0])
  for i in range(1, len(realRewrite)):
    rewrite_rules_c.write(", %d" % realRewrite[i])
  rewrite_rules_c.write("};\n#endif\n")
  rewrite_rules_c.close()