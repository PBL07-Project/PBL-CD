# Tell make these are not actual file targets
.PHONY: all build run

# Default target when you run `make`
all: run

# Step 1: Generate lex.yy.cpp and compile it
build:
	flex lexer.l
	g++ lex.yy.cpp -o compiler -std=c++17 -L/opt/homebrew/opt/flex/lib -lfl

# Step 2: Run compiler (process input.cpp → output.txt)
run: build
	./compiler
