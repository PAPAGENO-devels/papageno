import sys, re
import classes

#Takes as input a description of a grammar H=(nonterminals, terminals, rules, axiom)
#and creates an equivalent invertible grammar G=(V, terminals, P, newAxiom) by applying an
#optimized version of Harrison's algorithm.
def deleteRepeatedRhs(nonterminalsList, terminalsList, axiom, newAxiom, rules):
	#To apply Harrison's algorithm, the input grammar H must satisfy the following condition:
	#either it has no copy rules
	#or it can have copy rules, but the axiom must not have rules with the same rhs as other nonterminals of H. 
	#If these conditions do not hold, all its copy rules will be deleted.
	nonterminals = set(nonterminalsList)
	terminals = set(terminalsList)
	
	dictRules = initalizeDictRules(rules)
	
	#Check if the input grammar satisfies the preconditions of the algorithm
	hasAxiomWithRrhs = False
	for keyRhs, valueLhs in dictRules.items():
		if axiom in valueLhs and len(valueLhs)>1:
			hasAxiomWithRrhs = True
			break

	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#--------------------------------------
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#NOTE!!!!! I commented out the two following lines replacing them with the third line so that the copy rules are ALWAYS removed, but they should be enabled again
	# if hasCopyRules(nonterminals, rules) and hasAxiomWithRrhs:
	# 	deleteCopyRules(nonterminalsList, rules, dictRules)
	deleteCopyRules(nonterminalsList, rules, dictRules)


	#Initialize the new nonterminal set V
	V = set(dictRules.values())
	addedNonterminals = {}

	#Initialize the new set of productions P with the terminal rules of the original grammar
	#and avoid doing the next checks and expansions for these rules, deleting them from the dictionary of rules
	newDictRules = {}
	for keyRhs, valueLhs in dictRules.items()[:]:
		isTerminalRule = True
		for token in keyRhs:
			if token in nonterminals:
				isTerminalRule = False	
				break
		if isTerminalRule:
			newDictRules[keyRhs] = valueLhs
			del dictRules[keyRhs]
	
	#Add the new rules by expanding nonterminals in the rhs
	dictRulesForIteration = {}
	loop = True
	while loop:
		for keyRhs, valueLhs in dictRules.items():
			newRuleRhs = []
			addNewRules(dictRulesForIteration, keyRhs, valueLhs, nonterminals, V, newRuleRhs)
		addedNonterminals = set(dictRulesForIteration.values()).difference(V)
		#For Python2.7 one can possibly replace the immediately above line by the following line:
		#addedNonterminals = {nonTerm for nonTerm in dictRulesForIteration.values() if nonTerm not in V}
		V.update(addedNonterminals)
		newDictRules.update(dictRulesForIteration)
		if len(addedNonterminals) == 0:
			loop = False
	
	#List of nonterminals of the invertible grammar G
	V = set(newDictRules.values())

	#Delete rules with rhs with undefined nonterminals:
	#this implementation of the algorithm can generate rhs of rules with nonterminals which are no more defined.
	#TODO: a bit slightly more efficient version can store beforehand the list of rhs of every nonterminal and then delete the nonterminals whose rhs are all deleted.
	deleted = True
	while deleted:
		deleted = False
		for keyRhs, valueLhs in newDictRules.items()[:]:
			for token in keyRhs:
				if (token not in terminals) and (token not in V):
					del newDictRules[keyRhs]
					deleted = True
					break
		if deleted:
			V = set(newDictRules.values())
	
	V.add(frozenset([newAxiom]))

	#Add rules for the axiom of G, which have as rhs all new nonterminals that contain the old axiom
	for nonTerm in V:
		if axiom in nonTerm:
			#If the rule has exactly the old axiom as rhs, replace it with the new axiom
			if len(nonTerm) == 1 and tuple([nonTerm]) in newDictRules:
				newDictRules[tuple([frozenset([newAxiom])])] = newDictRules[tuple([nonTerm])]
			newDictRules[tuple([nonTerm])] = frozenset([newAxiom])


	return (newDictRules, V)

def initalizeDictRules(rules):
	dictRules = {}
	for rule in rules:
		#Use frozenset even if they will be united when two lhs have to be merged,
		#but avoid to convert sets representing nonterminals in frozensets within function addNewRules
		valueLhs = frozenset([rule.lhs])
		keyRhs = tuple(rule.rhs)
		if keyRhs in dictRules:
			dictRules[keyRhs] = dictRules[keyRhs].union(valueLhs)
		else:
			dictRules[keyRhs] = valueLhs
	return dictRules


def addNewRules(dictRulesForIteration, keyRhs, valueLhs, nonterminals, newNonterminals, newRuleRhs):
	if len(keyRhs) == 0:
		newKeyRhs = tuple(newRuleRhs)
		if newKeyRhs in dictRulesForIteration:
			dictRulesForIteration[newKeyRhs] = dictRulesForIteration[newKeyRhs].union(valueLhs)
		else:
			dictRulesForIteration[newKeyRhs] = valueLhs
		return
	token = keyRhs[0]
	if token in nonterminals:
		for nonTermSuperSet in newNonterminals:
			if token in nonTermSuperSet:
				newRuleRhs.append(nonTermSuperSet)
				addNewRules(dictRulesForIteration, keyRhs[1:], valueLhs, nonterminals, newNonterminals, newRuleRhs)
				newRuleRhs.pop()
	else: 
		#token in terminals
		newRuleRhs.append(token)
		addNewRules(dictRulesForIteration, keyRhs[1:], valueLhs, nonterminals, newNonterminals, newRuleRhs)
		newRuleRhs.pop()

def hasCopyRules(nonterminals, rules):
	for rule in rules:
		if len(rule.rhs) == 1 and rule.rhs[0] in nonterminals:
			return True
	return False

def deleteCopyRules(nonterminals, rules, dictRules):
	#Copy contatins the rhs of the copy rules of each nonterminal
	copy = {}
	#Contains the list of rhs of each nonterminal but not the rhs of copy rules
	rhsDict = {}

	#Initialization
	for n in nonterminals:
		copy[n] = set()

	for rule in rules:
		if len(rule.rhs) == 1 and rule.rhs[0] in nonterminals:
			#It is a copy rule
			#Update the copy set of rule.lhs
			copy[rule.lhs].add(rule.rhs[0])
			#Delete the copy rule from dictRules
			copyRhsTuple = tuple(rule.rhs)
			if copyRhsTuple in dictRules:
				del dictRules[copyRhsTuple]
		else:
			#Update the list of rhs of the nonterminal which is the lhs of the rule
			if rule.lhs in rhsDict:
				rhsDict[rule.lhs].append(rule.rhs)
			else:
				rhsDict[rule.lhs] = [rule.rhs]
	#Compute the transitive closure of renaming derivations
	changedCopySets = True
	while changedCopySets:
		changedCopySets = False
		for n in nonterminals:
			lenCopySet = len(copy[n])
			for copyRhs in copy[n].copy():
				copy[n].update(copy[copyRhs])
			if lenCopySet < len(copy[n]):
				changedCopySets = True
	#Update dictRules by replacing copy rules with their expansion
	for n in nonterminals:
		for copyRhs in copy[n]:
			rhsDictCopyrRhs = rhsDict.get(copyRhs, [])
			for rhs in rhsDictCopyrRhs:
				#add the rule to dictRule
				rhsTuple = tuple(rhs)
				if n not in dictRules[rhsTuple]:
					dictRules[rhsTuple] = dictRules[rhsTuple].union(set([n]))












