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

%%

"if"        { print("IF_KEYWORD", yytext); }
"else"      { print("ELSE_KEYWORD", yytext); }
"int"       { print("TYPE_INT", yytext); }
"float"     { print("TYPE_FLOAT", yytext); }
"bool"      { print("TYPE_BOOL", yytext); }
"true"      { print("BOOL_LITERAL", yytext); }
"false"     { print("BOOL_LITERAL", yytext); }

"=="        { print("COMPARE_OP", yytext); }
"!="        { print("COMPARE_OP", yytext); }
">="        { print("COMPARE_OP", yytext); }
"<="        { print("COMPARE_OP", yytext); }
">"         { print("COMPARE_OP", yytext); }
"<"         { print("COMPARE_OP", yytext); }

{ID}        { print("IDENTIFIER", yytext); }
{INT_NUM}   { print("INT_LITERAL", yytext); }
{FLOAT_NUM} { print("FLOAT_LITERAL", yytext); }

"="         { print("ASSIGN_OP", yytext); }
"+"         { print("ADD_OP", yytext); }
"-"         { print("SUB_OP", yytext); }
"*"         { print("MUL_OP", yytext); }
"/"         { print("DIV_OP", yytext); }

";"         { print("SEMICOLON", yytext); }
"{"         { print("LBRACE", yytext); }
"}"         { print("RBRACE", yytext); }
"("         { print("LPAREN", yytext); }
")"         { print("RPAREN", yytext); }

[ \t\n]     ;    // Skip whitespace
.           { print("UNKNOWN", yytext); }

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