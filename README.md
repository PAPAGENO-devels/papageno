PAPAGENO
========

### PArallel PArser GENeratOr based on Floyd's Operator Precedence Grammars

PAPAGENO is a functional and efficient parallel parser generator.

It generates parallel C parsers starting from a grammar specification
with the same syntax as Bison.

The generated parsers are self-contained and can be used with a common 
GNU Flex generated lexer without further effort.

The generated parsers have been tested successfully on x86_64 and ARM 
architectures.

PAPAGENO is realized in Python 2.x.

### Authors and Contributors

 * Alessandro Barenghi <alessandro.barenghi@polimi.it>
 * Federica Panella <federica.panella@polimi.it>

#### Acknowledgements

We acknowledge the support of Ermes Viviani for the development of the initial codebase.

### References and Publications 

The performances attained with a PAPAGENO-generated JSON parser scale almost 
linearly with the number of threads you are willing to employ.
The properties of Floyd's operator precedence grammars allow to split the parsing
work among different threads without wasting computation effort when combining the results
(no partial reparsing needed). You can find some benchmarks in:

Alessandro Barenghi, Ermes Viviani, Stefano Crespi Reghizzi, Dino Mandrioli and Matteo Pradella. 
_PAPAGENO: a parallel parser generator for operator precedence grammars_ 
in Proceedings of the 5th International Conference on Software Language Engineering,  
Lecture Notes in Computer Science, volume 7745, pp 264-274, Springer, ISBN:978-3-642-36088-6. 
[PDF Draft](http://home.deib.polimi.it/barenghi/lib/exe/fetch.php?media=sle2012.pdf)

A description of the algorithm employed in PAPAGENO is available in:

Alessandro Barenghi, Stefano Crespi Reghizzi, Dino Mandrioli, Matteo Pradella, 
_Parallel Parsing of Operator Precedence Grammars_ 
Information Processing Letters, 2013, ISSN 0020-0190
[PDF](http://dx.doi.org/10.1016/j.ipl.2013.01.008)
