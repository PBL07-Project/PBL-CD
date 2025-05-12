# Makefile for Phase 3 compiler front-end

# Tools
CC      := gcc
FLEX    := flex
BISON   := bison

# Flags
CFLAGS  := -Wall -g

# Files
LEX_SRC := lexer3.l
Y_SRC   := parser3.y

LEX_OUT := lex.yy.c
Y_OUT   := parser3.c
Y_HDR   := parser3.h

TARGET  := phase3
INPUT   := input.c
SYMTAB  := symtab.txt

.PHONY: all clean run

all: $(TARGET)

# Generate the scanner
$(LEX_OUT): $(LEX_SRC)
	$(FLEX) -o $@ $<

# Generate the parser (and header)
$(Y_OUT) $(Y_HDR): $(Y_SRC)
	$(BISON) -d -o $(Y_OUT) $(Y_SRC)

# Link it all
$(TARGET): $(LEX_OUT) $(Y_OUT)
	$(CC) $(CFLAGS) -o $@ $(Y_OUT) $(LEX_OUT)

# Run on input.c to produce symtab.txt
run: $(TARGET)
	./$(TARGET) $(INPUT) $(SYMTAB)

# Clean up generated files
clean:
	rm -f $(LEX_OUT) $(Y_OUT) $(Y_HDR) $(TARGET) $(SYMTAB)
