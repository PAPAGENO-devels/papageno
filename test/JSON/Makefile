CC := clang 
INCLUDES := -I./include -I./flex -I../include
CFLAGS := -DDEBUG -g3 -Wall $(INCLUDES)
#CFLAGS := -O3 -pipe -lpthread -Wall $(INCLUDES)
SRCDIR := lib
SRC := $(wildcard $(SRCDIR)/*.c)
ODIR := obj

FOUT := lexer/flex.yy.c
FOBJ := obj/flex.yy.o
OBJ := $(patsubst $(SRCDIR)/%.c, $(ODIR)/%.o, $(SRC))

FLEX := flex/json.l
OBJ += $(ODIR)/lex.o 
GENERATED_FILES = include/rewrite_rules.h include/reduction_tree.h include/grammar_tokens.h include/grammar_semantics.h lib/grammar_semantics.c include/grammar.h lib/grammar.c include/matrix.h lib/rewrite_rules.c 

all: $(FOBJ) $(OBJ)
	@$(CC) $(OBJ) $(FOBJ) -o bin/json_parser

$(FOBJ): $(FOUT)
	$(CC) -c $< -o $@ $(CFLAGS)

$(FOUT): $(FLEX)
	flex -Pyy --header-file=flex/flex.yy.h -o $@ $<

$(ODIR)/%.o: $(SRCDIR)/%.c 
	$(CC) -c $< -o $@ $(CFLAGS) 

clean:
	@rm $(GENERATED_FILES)
	@rm -f $(FOUT)
	@rm -f $(patsubst %.c, %.h, $(FOUT))
	@rm -f $(ODIR)/*.o
	@rm -f bin/json_parser         
