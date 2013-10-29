LEX = flex
CC = gcc

all: json_bison 

json_bison: parser.h parser.o scanner.o
	gcc -O3 -march=native -fomit-frame-pointer -finline-functions -o $@ parser.o scanner.o -lrt 

%.tab.c %.tab.h: %.y
	bison -d $<

%.c: %.tab.c
	@mv $< $@

%.h: %.tab.h
	@mv $< $@

clean:
	@rm -f parser *.o parser.h scanner.h
