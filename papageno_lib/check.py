import sys

def inferTokens(rules, axiom):
  nonterminals = []
  tokens = []
  # Infer nonterminals from lhs
  for rule in rules:
    if rule.lhs not in nonterminals:
      nonterminals.append(rule.lhs)
    for token in rule.rhs:
      if token not in nonterminals and token not in tokens:
        tokens.append(token)
  if axiom not in nonterminals:
    print "Axiom %s does not define any production." % axiom
    sys.exit(-1)
  nonterminals.remove(axiom)
  nonterminals.insert(0, axiom)
  terminals = []
  for token in tokens:
    if token not in nonterminals:
      terminals.append(token)
  terminals.append('__TERM')
  return nonterminals, terminals

def detectBadRules(nonterminals, terminals, axiom, rules):
  axiomIsUsed = False
  for rule in rules:
    if rule.lhs == axiom:
      axiomIsUsed = True
      break
  if not axiomIsUsed:
    print "\33[1;31mERROR\33[0m: Axiom does not appear in any rule."
  unknownTokens = dict()
  for rule in rules:
    if rule.lhs not in nonterminals and rule.lhs not in terminals:
      if rule.lhs not in unknownTokens:
        unknownTokens[rule.lhs] = []
      unknownTokens[rule.lhs].append(rule)
    for token in rule.rhs:
      if token not in nonterminals and token not in terminals:
        if token not in unknownTokens:
          unknownTokens[token] = []
        unknownTokens[token].append(rule)
  if len(unknownTokens) > 0:
    print "\33[1;31mERROR\33[0m: Unknown nonterminal/terminal symbols detected:"
    for key in unknownTokens:
      print "  \33[1;34m%s\33[0m in the following rules:" % key
      index = 0
      for rule in unknownTokens[key]:
        print "  %2d: %s" % (index, rule.toString())
        index += 1
  if not axiomIsUsed or len(unknownTokens) > 0:
    print "Grammar is incomplete. Aborting."
    sys.exit(-1)

def detectRepeatedRhs(rules):
  repeatedRhs = dict()
  for rule in rules:
    rhs = ".".join(rule.rhs)
    if rhs not in repeatedRhs:
      repeatedRhs[rhs] = []
      repeatedRhs[rhs].append(rule)
    else:
      repeatedRhs[rhs].append(rule)
  repeatedError = False
  for key in repeatedRhs:
    value = repeatedRhs[key]
    if len(value) > 1:
      print "\33[1;31mERROR\33[0m: Repeated rhs among the following rules:"
      repeatedError = True
      i = 0
      for rule in value:
        sys.stdout.write("%2d: %s\n" % (i, rule.toString()))
        i += 1
  return repeatedError

def detectUnusedNTerm(nonterminals, axiom, rules):
  unusedNTerm = []
  for nonterminal in nonterminals:
    if nonterminal == axiom:
      continue
    found = False
    for rule in rules:
      for token in rule.rhs:
        if token == nonterminal:
          found = True
          break
      if found:
        break
    if not found:
      unusedNTerm.append(nonterminal)
  if len(unusedNTerm) > 0:
    sys.stdout.write("\33[1;31mWARNING\33[0m: the following nonterminals are not used: %r\n" % unusedNTerm)
  return unusedNTerm

def detectUndefNTerm(nonterminals, rules, unusedNTerm):
  undefNTerm = []
  for nonterminal in nonterminals:
    found = False
    for rule in rules:
      if rule.lhs == nonterminal:
        found = True
        break
    if not found:
      undefNTerm.append(nonterminal)
  for nonterminal in unusedNTerm:
    if nonterminal in undefNTerm:
      undefNTerm.remove(nonterminal)
  if len(undefNTerm) > 0:
    sys.stdout.write("\33[1;31mWARNING\33[0m: the following nonterminals are used in a rhs but not as as lhs: %r\n" % undefNTerm)

def detectUnusedTerm(terminals, rules):
  unusedTerm = []
  for terminal in terminals:
    if terminal == "__TERM":
      continue
    found = False
    for rule in rules:
      for token in rule.rhs:
        if token == terminal:
          found = True
          break
      if found:
        break
    if not found:
      unusedTerm.append(terminal)
  if len(unusedTerm) > 0:
    sys.stdout.write("\33[1;31mWARNING\33[0m: the following terminals are not used: %r\n" % unusedTerm)

def detectDefinedTerm(terminals, rules):
  definedTerm = dict()
  defined = False
  for terminal in terminals:
    definedTerm[terminal] = []
    for rule in rules:
      if rule.lhs == terminal:
        definedTerm[terminal].append(rule)
        defined = True
  if defined:
    sys.stdout.write("\33[1;31mERROR\33[0m: the following terminals are used as lhs:\n")
    for terminal in terminals:
      if len(definedTerm[terminal]) == 0:
        continue
      sys.stdout.write("\33[1;34m%s\33[0m\n" % terminal)
      for rule in definedTerm[terminal]:
        sys.stdout.write("  %s\n" % rule.toString())

def detectRenamingRules(nonterminals, rules):
  renamingRules = []
  for rule in rules:
    if len(rule.rhs) == 1:
      if (rule.lhs in nonterminals) and (rule.rhs[0] in nonterminals):
        renamingRules.append(rule)
  if len(renamingRules) > 0:
    sys.stdout.write("\33[1;31mWARNING\33[0m: the grammar contains the following renaming rules:\n")
    for renaming in renamingRules:
      sys.stdout.write("  %s\n" % renaming.toString())
  return renamingRules