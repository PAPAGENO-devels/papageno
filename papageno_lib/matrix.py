import sys
import classes, bitPack

def buildAndCheckMatrix(nonterminals, terminals, rules):
  matrix = dict()
  lts, rts = buildTerminalSets(nonterminals, terminals, rules)
  # Initialize precedence matrix.
  nonOperator = []
  for i in terminals:
    matrix[i] = dict()
    for j in terminals:
      matrix[i][j] = dict()
      matrix[i][j]['='] = []
      matrix[i][j]['>'] = []
      matrix[i][j]['<'] = []
  for rule in rules:
    # Check digrams.
    rhs = rule.rhs
    for i in xrange(0, len(rhs) - 1):
      tok1 = rhs[i]
      tok2 = rhs[i + 1]
      if (tok1 in terminals) and (tok2 in terminals):
        matrix[tok1][tok2]['='].append(classes.Conflict(rule, i, i + 1))
      elif (tok1 in nonterminals) and (tok2 in terminals):
        for tok in rts[tok1]:
          matrix[tok][tok2]['>'].append(classes.Conflict(rule, i, i + 1))
      elif (tok1 in terminals) and (tok2 in nonterminals):
        for tok in lts[tok2]:
          matrix[tok1][tok]['<'].append(classes.Conflict(rule, i, i + 1))
      else:
        nonOperator.append(classes.Conflict(rule, i, i + 1))
    # Check trigrams.
    for i in xrange(0, len(rhs) - 2):
      tok1 = rhs[i]
      tok2 = rhs[i + 1]
      tok3 = rhs[i + 2]
      if (tok1 in terminals) and (tok2 in nonterminals) and (tok3 in terminals):
        matrix[tok1][tok3]['='].append(classes.Conflict(rule, i, i + 2))
  for j in terminals:
    if j != '__TERM':
      matrix['__TERM'][j]['<'].append(classes.Conflict(rules[0], 0, 0))
      matrix[j]['__TERM']['>'].append(classes.Conflict(rules[0], 0, 0))
  matrix['__TERM']['__TERM']['='].append(classes.Conflict(rules[0], 0, 0))
  # Check matrix.
  conflictError = False
  if len(nonOperator) > 0:
    conflictError = True
    print "\33[1;31mERROR\33[0m: The following rules violate the operator precedence form:"\
      "no two nonterminals may be adjacent."
    i = 0
    for con in nonOperator:
      sys.stdout.write("%2d: %s\n" % (i, con.toString()))
      i += 1
  for i in terminals:
    for j in terminals:
      conflicts = dict()
      if len(matrix[i][j]['=']) > 0:
        conflicts['='] = matrix[i][j]['=']
      if len(matrix[i][j]['>']) > 0:
        conflicts['>'] = matrix[i][j]['>']
      if len(matrix[i][j]['<']) > 0:
        conflicts['<'] = matrix[i][j]['<']
      if len(conflicts) > 1:
        conflictError = True
        print "\33[1;31mERROR\33[0m: Terminals %s and %s have conflicting relations:" % (i, j)
        for prec in conflicts:
          print "  \33[1;34m%s\33[0m:" % prec
          for con in conflicts[prec]:
            print "    %s" % con.toString()
  return matrix, conflictError

def buildTerminalSets(nonterminals, terminals, rules):
  lts = dict()
  rts = dict()
  # Initialize terminal sets.
  for nonterminal in nonterminals:
    lts[nonterminal] = set()
    rts[nonterminal] = set()
  # Direct terminals.
  for rule in rules:
    found = False
    i = 0
    while not found and i < len(rule.rhs):
      token = rule.rhs[i]
      if token in terminals:
        lts[rule.lhs].add(token)
        found = True
      i += 1
    i = len(rule.rhs) - 1
    found = False
    while not found and i >= 0:
      token = rule.rhs[i]
      if token in terminals:
        rts[rule.lhs].add(token)
        found = True
      i -= 1
  # Indirect terminals.
  modified = True
  while modified:
    modified = False
    for rule in rules:
      lhs = rule.lhs
      rhs = rule.rhs
      token = rhs[0]
      if token in nonterminals:
        for ttoken in lts[token]:
          if ttoken not in lts[lhs]:
            lts[lhs].add(ttoken)
            modified = True
      token = rhs[len(rhs) - 1]
      if token in nonterminals:
        for ttoken in rts[token]:
          if ttoken not in rts[lhs]:
            rts[lhs].add(ttoken)
            modified = True
  return lts, rts

def toRealMatrix(matrix, terminals):
  realMatrix = dict()
  for i in terminals:
    realMatrix[i] = dict()
    for j in terminals:
      realMatrix[i][j] = 'ND'

  for i in terminals:
    for j in terminals:
      if len(matrix[i][j]['=']) > 0:
        realMatrix[i][j] = '='
      elif len(matrix[i][j]['>']) > 0:
        realMatrix[i][j] = '>'
      elif len(matrix[i][j]['<']) > 0:
        realMatrix[i][j] = '<'
      else:
        realMatrix[i][j] = 'ND'
  return realMatrix

def toIntMatrix(realMatrix, terminals):
  if len(terminals) % 4 == 0:
    rowLen = len(terminals)/4
  else:
    rowLen = len(terminals)/4 + 1

  intMatrix = [0]*rowLen*len(terminals)
  for i in xrange(0, len(terminals)):
    for j in xrange(0, len(terminals)):
      bitPack.writePrecedence(intMatrix, i, j, realMatrix[terminals[i]][terminals[j]], rowLen)
  return intMatrix, rowLen
