# Final Cross-Platform Makefile
CC = gcc
CFLAGS = -Wall -g
BISON_FLAGS = -d -o y.tab.c
FLEX = flex
INPUT = input.c
OUTPUT = output.txt

.PHONY: all clean run

all: compiler

compiler: y.tab.c lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c y.tab.c -o $@

y.tab.c: parser.y
	bison $(BISON_FLAGS) $<

lex.yy.c: lexer.l
	$(FLEX) $<

run: compiler
	./compiler < $(INPUT) > $(OUTPUT)

clean:
	rm -f compiler lex.yy.c y.tab.c y.tab.h $(OUTPUT)