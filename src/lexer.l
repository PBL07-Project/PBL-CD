%{
#include <fstream>
#include <iostream>
#define YY_FLEX_LEXER
#define YY_NO_UNISTD_H

class Compiler : public yyFlexLexer {
    std::ofstream out;
public:
    explicit Compiler(std::istream* in = nullptr) : yyFlexLexer(in), out("output.txt") {}
    virtual int yylex() override;
    void print(const char* type, const char* text);
    ~Compiler() { out.close(); }
};
%}

%option noyywrap
%option c++
%option yyclass="Compiler"
%option outfile="lex.yy.cpp"

DIGIT     [0-9]
LETTER    [a-zA-Z_]
ID        {LETTER}({LETTER}|{DIGIT})*
INT_NUM   {DIGIT}+
FLOAT_NUM {DIGIT}+\.{DIGIT}+
STRING    \"(\\.|[^"\\])*\"
CHAR      \'(\\.|[^'\\])\'

%%

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"bool"|"true"|"false"|"printf"|"scanf" { print("KEYWORD", YYText()); }

[(){}[\]\,\;:] { print("SEPARATOR", YYText()); }

"+"|"-"|"*"|"/"|"%" { print("ARITHMETIC_OP", YYText()); }
"=="|"!="|"<"|">"|"<="|">=" { print("COMPARE_OP", YYText()); }
"&&"|"\|\|"|"!" { print("LOGICAL_OP", YYText()); }
"&"|"\|"|"^"|"~"|"<<"|">>" { print("BITWISE_OP", YYText()); }
"="|"+="|"-="|"*="|"/="|"%="|"&="|"\|="|"^="|"<<="|">>=" { print("ASSIGNMENT_OP", YYText()); }
"?"|":" { print("TERNARY_OP", YYText()); }

{STRING}    { print("STRING_LITERAL", YYText()); }
{CHAR}      { print("CHAR_LITERAL", YYText()); }
{ID}        { print("IDENTIFIER", YYText()); }
{INT_NUM}   { print("INT_LITERAL", YYText()); }
{FLOAT_NUM} { print("FLOAT_LITERAL", YYText()); }

[ \t\n]     ;    // Skip whitespace
.           { print("UNKNOWN", YYText()); }

%%

void Compiler::print(const char* type, const char* text) {
    out << type << ": " << text << '\n';
}

int main() {
    std::ifstream in("input.cpp");
    Compiler lexer(&in);
    lexer.yylex();
    return 0;
}