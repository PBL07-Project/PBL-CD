%{
#include <stdio.h>
#include <stdlib.h>

FILE *output_fp;

typedef enum {
    TOK_PRINTFF,
    TOK_SCANFF,
    TOK_INT,
    TOK_FLOAT,
    TOK_CHAR,
    TOK_VOID,
    TOK_RETURN,
    TOK_FOR,
    TOK_IF,
    TOK_ELSE,
    TOK_INCLUDE,
    TOK_TRUE,
    TOK_FALSE,
    TOK_NUMBER,
    TOK_FLOAT_NUM,
    TOK_ID,
    TOK_UNARY,
    TOK_LE,
    TOK_GE,
    TOK_EQ,
    TOK_NE,
    TOK_GT,
    TOK_LT,
    TOK_AND,
    TOK_OR,
    TOK_ADD,
    TOK_SUBTRACT,
    TOK_DIVIDE,
    TOK_MULTIPLY,
    TOK_STR,
    TOK_CHARACTER,
    TOK_UNKNOWN
} TokenType;

const char *token_names[] = {
    "PRINTFF", "SCANFF", "INT", "FLOAT", "CHAR", "VOID",
    "RETURN", "FOR", "IF", "ELSE", "INCLUDE", "TRUE", "FALSE",
    "NUMBER", "FLOAT_NUM", "ID", "UNARY", "LE", "GE", "EQ", "NE",
    "GT", "LT", "AND", "OR", "ADD", "SUBTRACT", "DIVIDE", "MULTIPLY",
    "STR", "CHARACTER", "UNKNOWN"
};

%}

%option noyywrap

alpha       [a-zA-Z]
digit       [0-9]
unary       "++"|"--"

%%

"printf"                    { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_PRINTFF], yytext); }
"scanf"                     { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_SCANFF], yytext); }
"int"                       { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_INT], yytext); }
"float"                     { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_FLOAT], yytext); }
"char"                      { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_CHAR], yytext); }
"void"                      { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_VOID], yytext); }
"return"                    { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_RETURN], yytext); }
"for"                       { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_FOR], yytext); }
"if"                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_IF], yytext); }
"else"                      { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_ELSE], yytext); }
"#include"[ \t]*<[^>]+>     { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_INCLUDE], yytext); }
"true"                      { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_TRUE], yytext); }
"false"                     { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_FALSE], yytext); }
[-]?{digit}+                { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_NUMBER], yytext); }
[-]?{digit}+\.{digit}{1,6}  { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_FLOAT_NUM], yytext); }
{alpha}({alpha}|{digit})*   { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_ID], yytext); }
{unary}                     { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_UNARY], yytext); }

"<="                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_LE], yytext); }
">="                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_GE], yytext); }
"=="                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_EQ], yytext); }
"!="                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_NE], yytext); }
">"                         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_GT], yytext); }
"<"                         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_LT], yytext); }
"&&"                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_AND], yytext); }
"||"                        { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_OR], yytext); }

"+"                         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_ADD], yytext); }
"-"                         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_SUBTRACT], yytext); }
"/"                         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_DIVIDE], yytext); }
"*"                         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_MULTIPLY], yytext); }

\"([^\"\n]|\\\")*\"         { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_STR], yytext); }
'([^'\n]|\\')'              { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_CHARACTER], yytext); }

[ \t\n]+                    ; /* Skip whitespace */
.                           { fprintf(output_fp, "%-15s: %s\n", token_names[TOK_UNKNOWN], yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    output_fp = fopen("output.txt", "w");
    
    if (!yyin || !output_fp) {
        perror("Error opening files");
        return 1;
    }

    fprintf(output_fp, "/* Token Listing for %s */\n\n", argv[1]);
    fprintf(output_fp, "%-15s  %s\n", "TOKEN TYPE", "LEXEME");
    fprintf(output_fp, "---------------------------------\n");
    
    yylex();

    fclose(yyin);
    fclose(output_fp);
    return 0;
}