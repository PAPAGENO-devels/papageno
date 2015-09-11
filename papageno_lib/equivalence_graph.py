

indent = "   "

class Color:
    White, Black = range(2)

class Node:
    def __init__(self, value):
        self.value = value  # value
        self.adjacent = []  # list of adjacent nodes
        self.color = Color.White

    def getWhiteAdjacents(self):
        ret = []
        for node in self.adjacent:
            if node.color == Color.White:
                ret.append(node)
        return ret

    def appendNode(self, node):
        self.adjacent.append(node)

    def transitionsToString(self, graphid):
        ret = ""
        for neighbour in self.adjacent:
            ret += indent + self.value + "_" + str(graphid) + "->" + neighbour.value + "_" + str(graphid) + "\n"
        return ret

    def valueToString(self, graphid):
        return self.value + "_" + str(graphid) + " [label=" + self.value + "]"

class Graph:
    def __init__(self, root):
        self.root = root  # shortcut to the root element
        self.nodes = [root]  # list of nodes
        self.rules_used = []  # list of renaming rules used to generate the graph

    def appendToNode(self, node, newnode):
        already_present = self.getNodeByValue(newnode.value)
        if already_present != None:  # if a node with the same name already exists, reuse it
            newnode = already_present

        if node in self.nodes:
            node.appendNode(newnode)
            if newnode not in self.nodes:  # allow cycles, but don't replicate nodes
                self.nodes.append(newnode)

    def getNodeByValue(self, value):
        for node in self.nodes:
            if node.value == value:
                return node
        return None

    def associateRule(self, rule):
        self.rules_used.append(rule)

    def rulesToString(self):
        ret = ""
        for rule in self.rules_used:
            ret += rule.toString() + "\n"
        return ret

    def toString(self, graphid):
        ret = ""
        for node in self.nodes:
            ret += indent + node.valueToString(graphid) + "\n"
        for node in self.nodes:
            transitions = node.transitionsToString(graphid)
            if transitions != "":
                ret += transitions
        return ret

    def formatToDot(self, graphid):
        ret = "subgraph super_" + self.root.value + " {\n"
        ret += self.toString(graphid)
        ret += "}"
        return ret

class GraphsList:
    def __init__(self):
        self.graphs = []

    def getRootByValue(self, value):
        for graph in self.graphs:
            if graph.root.value == value:
                return graph.root
        return None

    def processRule(self, rule):
        # try appending to existing sub-graphs
        for graph in self.graphs:
            node = graph.getNodeByValue(rule.lhs)
            if node != None:
                newchild = Node(rule.rhs[0])
                graph.appendToNode(node, newchild)
                graph.associateRule(rule)
        # try adding a new sub-graph
        root = self.getRootByValue(rule.lhs)
        if root == None:
            newroot = Node(rule.lhs)
            newgraph = Graph(newroot)
            newchild = Node(rule.rhs[0])
            newgraph.appendToNode(newroot, newchild)
            newgraph.associateRule(rule)
            self.graphs.append(newgraph)

    def formatToDot(self):
        ret = "digraph equivalent_nonterminals {\n"
        graphid = 0  # id to distinguish between the graphs (so that graphviz won't link them by mistake)
        for graph in self.graphs:
            ret += graph.formatToDot(graphid) + "\n"
            graphid += 1
        ret += "}\n"
        return ret
     
# Loop detection

def oneStepAhead(node, addBifurcationCallback):
    possibilities = node.getWhiteAdjacents()  # visit only the white adjacent nodes
    if len(possibilities) > 1:
        for i in xrange(1, len(possibilities)):
            addBifurcationCallback(possibilities[i])
    elif len(possibilities) == 0:
        node.color = Color.Black  # color the dead ends in black, so that we won't visit them ever again
        return None
    return possibilities[0]

def twoStepsAhead(node, addBifurcationCallback):
    step_1 = oneStepAhead(node, addBifurcationCallback)
    if step_1 == None:
        return None
    return oneStepAhead(step_1, addBifurcationCallback)

def explorePath(starting_point, addBifurcationCallback):
    finished = False
    cycle_found = False
    turtle = starting_point
    hare = starting_point
    while not finished:
        turtle = oneStepAhead(turtle, addBifurcationCallback)
        hare = twoStepsAhead(hare, addBifurcationCallback)
        if (turtle == None) or (hare == None):  # reached a dead end
            finished = True
        elif (turtle == hare):  # the hare looped and catched up with the turtle
            finished = True
            cycle_found = True
    return cycle_found

def hasCycles(graph):
    starting_points = []
    def appendCallback(node):
        starting_points.append(node)

    starting_points.append(graph.root)

    for start in starting_points:
        if explorePath(start, appendCallback):
            return True
    return False