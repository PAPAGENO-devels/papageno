import sys, re
import classes

def getAxiom(inputLines, lineIndex):
  axiom = ""
  for inputLine in inputLines[lineIndex:]:
    if inputLine == "\n":
      lineIndex += 1
      continue
    lineIndex += 1
    if re.match("%axiom", inputLine):
      lineSplit = re.split("\W+", inputLine)
      if axiom == "":
        axiom = lineSplit[2]
      else:
        print "Only one axiom is allowed: old %s, new %s" % (axiom, lineSplit[2])
    if re.match("%%", inputLine):
      break
  if axiom == "":
    print "The axiom must be defined."
    sys.exit(-1)
  return axiom, lineIndex

def getRules(inp):
  rules = []
  i = 0
  ch = inp[i]
  while i < len(inp):
    # LHS : RHS [RHS]* [{.}] [| RHS [RHS]* [{.}]] ;
    currentRule = classes.Rule()
    rules.append(currentRule)
    currentLhs, ch, i = nextToken(i, inp)
    currentRule.lhs = currentLhs
    ch, i = skipSpace(i, inp)
    if ch != ":":
      print "No : after lhs."
      sys.exit(-1)
    ch, i = nextChar(i, inp)
    while ch != ";":
      # RHS [RHS]* [{.}]
      ch, i = skipSpace(i, inp)
      while (ch.isalpha() or ch.isdigit()):
        token, ch, i = nextToken(i, inp)
        currentRule.rhs.append(token)
        ch, i = skipSpace(i, inp)
      if ch == "{":
        # {.}
        braceBalance = 1
        currentRule.text = "{"
        ch, i = nextChar(i, inp)
        while braceBalance != 0:
          currentRule.text += ch
          if ch == "}":
            braceBalance -= 1
          if ch == "{":
            braceBalance += 1
          ch, i = nextChar(i, inp)
        ch, i = skipSpace(i, inp)
      if ch == "|":
        currentRule = classes.Rule()
        rules.append(currentRule)
        currentRule.lhs = currentLhs
        ch, i = nextChar(i, inp)
        ch, i = skipSpace(i, inp)
    ch, i = nextChar(i, inp)
    ch, i = skipSpace(i, inp)
  if len(rules) == 0:
    print "Grammar has no rules."
    sys.exit(-1)
  return rules

def nextChar(index, inputRules):
  index += 1
  if index >= len(inputRules):
    return "", index
  return inputRules[index], index

def skipSpace(index, inputRules):
  if index >= len(inputRules):
    return "", index
  ch = inputRules[index]
  if ch == "2" :
    print inputRules[index:(index+20)]
  if ch == "/" and inputRules[index + 1] == "*":
    comment = True
  else:
    comment = False
  while ch.isspace() or comment:
    ch, index = nextChar(index, inputRules)
    if ch == "/" and inputRules[index + 1] == "*":
      comment = True
    if inputRules[index - 1] == "/" and inputRules[index - 2] == "*":
      comment = False
    if ch == "":
      break
  return ch, index

def nextToken(index, inputRules):
  if index >= len(inputRules):
    return "EOF", "", index
  ch, index = skipSpace(index, inputRules)
  if ch == "":
    return "EOF", "", index
  if not ch.isalpha():
    print "Token must start with a letter."
    sys.exit(-1)
  token = ""
  while (ch.isalpha() or (ch in "_-") or ch.isdigit()):
    token += ch
    ch, index = nextChar(index, inputRules)
  return token, ch, index

