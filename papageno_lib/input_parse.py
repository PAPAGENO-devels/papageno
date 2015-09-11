#!/usr/bin/env python2

import argparse,re,sys,scanner

def parse_commandline_args():
  parser = argparse.ArgumentParser(description='PAPAGENO : the PArallel PArser GENeratOr')
  parser.add_argument('--verbose'   ,'-v', metavar='verb'          ,help='Verbosity level [0-2]',default=0, type=int)
  parser.add_argument('--inputfile' ,'-i', metavar='inputfile'     ,help='Grammar description file', required=True)
  parser.add_argument('--out_header'     , metavar='header_outpath',help='Location where the output headerfiles should be generated. Defaults to ./include/ in the calling path',default='./include/')
  parser.add_argument('--out_core'       , metavar='source_outpath',help='Location where the output C files should be generated. Defaults to ./lib/ in the calling path',default='./lib/')
  parser.add_argument('--recombination'  , metavar='recombination' ,help='String chunk recombination strategy: choose between single and log. Defaults to single', default='SINGLE')
  parser.add_argument('--prealloc_stack' , metavar='prealloc_stack',help='Preallocated number of symbols for buffered parsing stack. Defaults to 1024',default=1024,type=int)  
  parser.add_argument('--token_avg_size' , metavar='token_avg_size',help='Size, in bytes of the average token. Default is 5 bytes',default='5.0')  
  parser.add_argument('--cache_line_size', metavar='cache_line_size',help='Size, in bytes of cache line. Default is 64 bytes',default=64,type=int)  
  parser.add_argument('--skip_advanced_matching',help='Force disable the copy-rules support features, may improve parsing performance', action='store_true')
  return parser.parse_args()

def parse_grammar_description(args):
  inputFile = open(args.inputfile, "r")
  inputLines = inputFile.readlines()

  # Parse C preamble.
  lineIndex = 0
  cPreamble = ""
  for inputLine in inputLines:
    if re.match("%nonterminal", inputLine):
      break
    if re.match("%%", inputLine):
      lineIndex += 1
      break
    cPreamble += inputLine
    lineIndex += 1

  if args.verbose==1:
    print "C preamble"
    print cPreamble

  # Parse axiom.
  axiom, lineIndex = scanner.getAxiom(inputLines, lineIndex)

  # Parse reduction rules and semantic functions.
  inp = ''.join(inputLines[lineIndex:])
  rules = scanner.getRules(inp)
  # fill each rule with an index
  for index in xrange(0, len(rules)):
    rule = rules[index]
    rule.index = index 
  if args.verbose==2:
    print "Rules:"
    for index in xrange(0, len(rules)):
      rule = rules[index]
      sys.stdout.write("%2d:%s\n" % (index, rule.toString()))
  return rules,axiom,cPreamble 