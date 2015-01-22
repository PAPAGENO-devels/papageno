#!/usr/bin/env python2

import sys, os, re, argparse
from papageno_lib import input_parse, scanner, bitPack, classes, check, matrix, code_emission, transform

commandline_args = input_parse.parse_commandline_args()
print commandline_args;
rules,axiom,cPreamble = input_parse.parse_grammar_description(commandline_args)

# Infer (non)terminals.
nonterminals, terminals = check.inferTokens(rules, axiom)
if commandline_args.verbose==2:
  print "Inferred nonterminals: %r" % nonterminals
  print "Inferred terminals: %r" % terminals

# Detect bad rules.
check.detectBadRules(nonterminals, terminals, axiom, rules)

# Detect repeated rhs.
repeatedError = check.detectRepeatedRhs(rules)

# Delete repeated rhs.
if repeatedError:
  newAxiom = '_NewAxiom' 
  
  if commandline_args.verbose==2:
    print "The previous grammar had %s rules, %s nonterminals, %s terminals" % (len(rules), len(nonterminals), len(terminals))
    print "Grammar after elimination of repeated rhs with newAxiom: %s" %newAxiom

  newRules, newNonterminalsSet = transform.deleteRepeatedRhs(nonterminals, terminals, axiom, newAxiom, rules)

  rules = []

  for rhs, lhs in newRules.items():
    currentRule = classes.Rule()
    rules.append(currentRule)
    if len(lhs) == 1:
      currentRule.lhs = next(iter(lhs))
    else:  
      currentRule.lhs = "_" + "__".join(sorted(lhs))
    for token in rhs:
        if token in terminals:
          currentRule.rhs.append(token)
        elif len(token) == 1:
          currentRule.rhs.append(next(iter(token)))
        else:
          currentRule.rhs.append("_" + "__".join(sorted(token)))

  nonterminals = []
  for n in newNonterminalsSet:
    if len(n) == 1:
      nonterminals.append(next(iter(n)))
    else:  
      nonterminals.append("_" + "__".join(sorted(n)))
  axiom = newAxiom

  #These statements have been done in check.py for the old set of nonterminals
  nonterminals.remove(axiom)
  nonterminals.insert(0, axiom)

  repeatedError = False

  if commandline_args.verbose==2:
    print "Printing new nonterminals:"
    print nonterminals
    print "Printing new rules:"
    for rule in rules:
      sys.stdout.write(rule.toString() + "\n")
                
    numNewRules = len(rules)
    numNewNonterminals = len(nonterminals)
    print "There are %s rules, %s nonterminals" % (numNewRules, numNewNonterminals)

# Detect bad rules.
check.detectBadRules(nonterminals, terminals, axiom, rules)

# Detect unused nonterminals.
unusedNTerm = check.detectUnusedNTerm(nonterminals, axiom, rules)

# Detect non-lhs nonterminals.
check.detectUndefNTerm(nonterminals, rules, unusedNTerm)

# Detect unused terminals.
check.detectUnusedTerm(terminals, rules)

# Detect lhs terminals.
check.detectDefinedTerm(terminals, rules)

# Compute precedence matrix.
origMatrix, conflictError = matrix.buildAndCheckMatrix(nonterminals, terminals, rules)

# Interrupt generation in case of errors.
if repeatedError or conflictError:
  if raw_input("Grammar is not in the required operator precedence form. Continue (y/n)?") != "y":
    sys.exit(-1)

# Build real matrix.
realMatrix = matrix.toRealMatrix(origMatrix, terminals)
# Build integer matrix.
intMatrix, rowLen = matrix.toIntMatrix(realMatrix, terminals)


if commandline_args.verbose==2:
  sys.stdout.write("Printing human readable  precedence matrix.\n")
  sys.stdout.write("%10s " % "i\\j")
  for j in terminals:
    sys.stdout.write("%10s " % j)
  sys.stdout.write("\n")
  for i in terminals:
    sys.stdout.write("%10s " % i)
    for j in terminals:
      sys.stdout.write("%10s " % realMatrix[i][j])
    sys.stdout.write("\n")

if commandline_args.verbose==1:
  sys.stdout.write("Printing real matrix.\n")
  for i in xrange(0, len(terminals)):
    for j in xrange(0, rowLen):
      sys.stdout.write("0x%2x " % intMatrix[i*rowLen + j])
    sys.stdout.write("\n")
  sys.stdout.write("Printing real conceptual matrix.\n")
  sys.stdout.write("%10s " % "i\\j")
  for j in xrange(0, len(terminals)):
    sys.stdout.write("%10s " % terminals[j])
  sys.stdout.write("\n")
  for i in xrange(0, len(terminals)):
    sys.stdout.write("%10s " % terminals[i])
    for j in xrange(0, len(terminals)):
      sys.stdout.write("%10s " % bitPack.getPrecedence(intMatrix, i, j, rowLen))
    sys.stdout.write("\n")
  sys.stdout.write("Printing C matrix.\n")
  sys.stdout.write("uint8_t __matrix[__ROW_LEN*__TERM_LEN] = {%d" % intMatrix[0])
  for i in xrange(1, len(intMatrix)):
    sys.stdout.write(", %d" % intMatrix[i])
  sys.stdout.write("}\n")

# Create reduction tree.
root = classes.ReductionNode(len(rules))
for index in xrange(0, len(rules)):
  rule = rules[index]
  node = root
  for rhsToken in rule.rhs:
    tempNode = node.hasSonWith(rhsToken)
    if not tempNode:
      tempNode = classes.ReductionNode(len(rules))
      node.sons[rhsToken] = tempNode
    node = tempNode
  node.rule_id = index

if commandline_args.verbose==2:
  sys.stdout.write("Reduction tree\nroot:%s" % root.recursiveToString(0))

# Vectorize reduction tree.
# compute the number of nodes
treeSize = 1 + root.getSubtreeSize()
# allocate a list large enough to contain them
vectorTree = [0]*treeSize
current_position = 1
vectorTree, vectorTree[0], current_position = root.subtreeToVector(vectorTree, current_position, nonterminals, terminals)

# Print vector tree.
if commandline_args.verbose==1:
  sys.stdout.write("Vectorized reduction tree\n")
  current_position = vectorTree[0]
  level = 0
  workList = []
  workList.append([current_position, level, "root"])
  while len(workList) != 0:
    item = workList.pop(0)
    current_position = item[0]
    level = item[1]
    label = item[2]
    sys.stdout.write("  "*level)
    sys.stdout.write("%s:%d\n" % (label, vectorTree[current_position]))
    sonsNumber = vectorTree[current_position + 1]/2
    current_position += 2
    for i in xrange(0, sonsNumber):
      label = bitPack.intToToken(vectorTree[current_position + i*2], nonterminals, terminals)
      sonOffset = vectorTree[current_position + i*2 + 1]
      workList.insert(i, [sonOffset, level + 1, label])

# Print C vector tree.
if commandline_args.verbose==1:
  sys.stdout.write("C vectorized reduction tree\n")
  sys.stdout.write("uint16_t __reduction_tree = {%d" % vectorTree[0])
  for i in xrange(1, len(vectorTree)):
    sys.stdout.write(", %d" % vectorTree[i])
  sys.stdout.write("};\n")

# Create rewrite rules.
rewrite = dict()
for nonterminal in nonterminals:
  rewrite[nonterminal] = []
modified = True
while modified:
  modified = False
  for rule in rules:
    lhs = rule.lhs
    token = rule.rhs[0]
    if len(rule.rhs) != 1 or token in terminals:
      continue
    if token not in rewrite[lhs]:
      modified = True
      rewrite[lhs].append(token)
    else:
      for ttoken in rewrite[token]:
        if ttoken not in rewrite[lhs]:
          modified = True
          rewrite[lhs].append(ttoken)

# Create inverse rewrite rules.
invRewrite = dict()
for nonterminal in nonterminals:
  invRewrite[nonterminal] = [nonterminal]
for nonterminal in nonterminals:
  for token in rewrite[nonterminal]:
    invRewrite[token].append(nonterminal)

# Print inverse rewrite rules.
if commandline_args.verbose==2:
  print "Rewrite rules"
  for nonterminal in nonterminals:
    sys.stdout.write("Rewrite(%s) = {" % nonterminal)
    for token in invRewrite[nonterminal]:
      sys.stdout.write(" %s" % token)
    sys.stdout.write(" }\n")

# Create array rewrite rules.
rewriteSize = len(nonterminals)
for nonterminal in nonterminals:
  rewriteSize += 1 + len(invRewrite[nonterminal])
realRewrite = [0]*rewriteSize
topOfArray = len(nonterminals)
for nonterminal in nonterminals:
  index = nonterminals.index(nonterminal)
  realRewrite[index] = topOfArray
  realRewrite[topOfArray] = len(invRewrite[nonterminal])
  topOfArray += 1
  for token in invRewrite[nonterminal]:
    realRewrite[topOfArray] = bitPack.tokenToPackedInt(token, nonterminals, terminals)
    topOfArray += 1

# Print array rewrite rules.
if commandline_args.verbose==1:
  print "Array rewrite rules"
  for i in xrange(0, len(nonterminals)):
    sys.stdout.write("Rewrite(%s) = {" % nonterminals[i])
    offset = realRewrite[i]
    end = offset + realRewrite[offset] + 1
    offset += 1
    while offset != end:
      sys.stdout.write(" <%d:%s>" % (realRewrite[offset], bitPack.packedIntToToken(realRewrite[offset], nonterminals, terminals)))
      offset += 1
    sys.stdout.write(" }\n")

# Print C rewrite rules.
if commandline_args.verbose==1:
  print "C rewrite rules"
  sys.stdout.write("uint32_t rewrite[] = {%d" % realRewrite[0])
  for i in xrange(1, len(realRewrite)):
    sys.stdout.write(", %d" % realRewrite[i])
  sys.stdout.write("};\n")

# Create rhs mapping for $x substitutions and headerName.
for rule in rules:
  rule.tokenMap["lhs"] = "p_" + rule.lhs
  for i in xrange(0, len(rule.rhs)):
    rule.tokenMap[i + 1] = "p_" + rule.rhs[i] + "%d" % (i + 1)

# Execute $x substitutions.
for rule in rules:
  rule.text = rule.text.replace("$$", rule.tokenMap["lhs"] + "->value")
  for i in xrange(0, len(rule.rhs)):
    rule.text = rule.text.replace("$%d" % (i + 1), rule.tokenMap[i + 1] + "->value")

if commandline_args.verbose==1:
  print "Rules tokenmaps."
  for rule in rules:
    print rule.tokenMap

# Compute average rule length
average_rule_len=0.0
for rule in rules:
  average_rule_len=average_rule_len+len(rule.rhs)
average_rule_len=average_rule_len/len(rules)

# Generate output files.

# Generate grammar_tokens.h
code_emission.emit_grammar_symbols(nonterminals,terminals,axiom,commandline_args.out_header)

# Generate grammar_semantics.h
code_emission.emit_semantic_actions_header(rules,commandline_args.out_header)

# Generate grammar_semantics.c
code_emission.emit_semantic_actions(rules,cPreamble,commandline_args.out_core)

# Generate grammar.h
code_emission.emit_grammar_header(rules,commandline_args.out_header)

# Generate grammar.c
code_emission.emit_grammar(terminals, nonterminals, axiom, rules ,commandline_args.out_core)
# Generate matrix.h
code_emission.emit_precedence_matrix_header(intMatrix,len(terminals),commandline_args.out_header)

# Generate reduction_tree.c
code_emission.emit_reduction_tree(vectorTree,commandline_args.out_header)

# Generate rewrite_rules.h
code_emission.emit_rewrite_rules(realRewrite,commandline_args.out_header)
code_emission.emit_config_header(commandline_args.cache_line_size,average_rule_len,commandline_args.token_avg_size,commandline_args.prealloc_stack,commandline_args.recombination,commandline_args.out_header)