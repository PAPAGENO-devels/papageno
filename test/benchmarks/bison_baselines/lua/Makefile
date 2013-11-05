SOURCES = lua_lr.parser.c lua_lr.lexer.c lua_lr.parser.h
EXEC_NAME = lua_lr 

OBJECTS = $(filter-out %.h, $(SOURCES))

all : $(EXEC_NAME)

$(EXEC_NAME) : $(OBJECTS)
	gcc -march=native -O3 -o $@ $^

%.parser.h : %.parser.c

%.parser.c : %.y
	bison -d -o $@ $<

%.lexer.c : %.l
	flex -o $@ $<

clean:
	rm -rf  lua_lr.parser.c lua_lr.lexer.c lua_lr.parser.h *.o  $(EXEC_NAME)
