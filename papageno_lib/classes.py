import bitPack

class Rule:
  def __init__(self):
    self.index = 0
    self.text = ""
    self.lhs = ""
    self.rhs = []
    self.tokenMap = dict()
  def toString(self):
    s = ""
    s += self.lhs + " -> " + " ".join(self.rhs)
    return s

class Conflict:
  def __init__(self, rule, i, j):
    self.rule = rule
    self.i = i
    self.j = j
  def toString(self):
    s = ""
    s += self.rule.toString() + ": between " + self.rule.rhs[self.i] + \
      " and " + self.rule.rhs[self.j]
    return s

class ReductionNode:
  
  def __init__(self, rule_id):
    self.rule_id = rule_id
    self.sons = dict()
  
  def hasSonWith(self, label):
    if label in self.sons:
      return self.sons[label]
    return False
  
  def getSubtreeSize(self):
    size = 2
    for label in self.sons:
      son = self.sons[label]
      size += son.getSubtreeSize()
      size += 2
    return size
  
#linearize the tree through a postorder visit 
  def subtreeToVector(self, vector, current_position, nonterminals, terminals):
    sonsNumber = len(self.sons)
    sonsOffsets = dict()
    # Call sons and populate sonsOffsets.
    for label in self.sons:
      son = self.sons[label]
      vector,sonsOffsets[label],current_position = son.subtreeToVector(vector, current_position, nonterminals, terminals)
    myOffset = current_position
    vector[myOffset] = self.rule_id
    vector[myOffset + 1] = sonsNumber*2
    current_position += 2
    for label in self.sons:
      # Get label value.
      labelIndex =  bitPack.tokenToInt(label, nonterminals, terminals)
      vector[current_position] = labelIndex
      vector[current_position + 1] = sonsOffsets[label]
      current_position += 2
    return vector, myOffset, current_position
  
  def recursiveToString(self, base_level):
    s = ""
    s += str(self.rule_id) + "\n"
    for label in self.sons:
      son = self.sons[label]
      s += "  "*(base_level + 1) + label + ":"
      s += son.recursiveToString(base_level + 1)
    return s