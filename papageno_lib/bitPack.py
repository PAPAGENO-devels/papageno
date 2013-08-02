import ctypes


def precRelToInt(rel):
  if rel == '=':
    return 0
  if rel == '>':
    return 1
  if rel == '<':
    return 2
  return 3

def intToPrecRel(rel):
  if rel == 0:
    return "="
  if rel == 1:
    return ">"
  if rel == 2:
    return "<"
  return "ND"

def writePrecedence(matrix, i, j, rel, rowLen):
  pos = j % 4
  shift = 6 - 2*pos
  oldValue = matrix[i*rowLen + j/4]
  newValue = oldValue & ~(0x03 << shift)
  newValue = newValue | ((precRelToInt(rel) & 0x03) << shift)
  matrix[i*rowLen + j/4] = newValue

def getPrecedence(matrix, i, j, rowLen):
  pos = j % 4
  shift = 6 - 2*pos
  value = (matrix[i*rowLen + j/4] & (0x03 << shift)) >> shift
  return intToPrecRel(value)

def intToToken(i, nonterminals, terminals):
  if i < len(nonterminals):
    return nonterminals[i]
  else:
    return terminals[i - len(nonterminals)]

def tokenToInt(t, nonterminals, terminals):
  if t in nonterminals:
    return nonterminals.index(t)
  else:
    return terminals.index(t) + len(nonterminals)

def packedIntToToken(i, nonterminals, terminals):
  nonterminal_bit_flag_pos=30
  nonterminal_bit_mask=1<<nonterminal_bit_flag_pos
  i = i & ctypes.c_uint32(~nonterminal_bit_mask).value
  return intToToken(i, nonterminals, terminals)

def tokenToPackedInt(t, nonterminals, terminals):
  if t in nonterminals:
    return tokenToInt(t, nonterminals, terminals)
  else:
    nonterminal_bit_flag_pos=30
    nonterminal_bit_mask=1<<nonterminal_bit_flag_pos
    return tokenToInt(t, nonterminals, terminals) | ctypes.c_uint32(nonterminal_bit_mask).value
