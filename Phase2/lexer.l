%{
#include "y.tab.h"
extern int yylineno;
%}

%option yylineno noyywrap

alpha       [a-zA-Z]
digit       [0-9]
unary       "++"|"--"

%%

"printf"                    { return PRINTFF; }
"scanf"                     { return SCANFF; }
"int"                       { return INT; }
"float"                     { return FLOAT; }
"char"                      { return CHAR; }
"void"                      { return VOID; }
"return"                    { return RETURN; }
"for"                       { return FOR; }
"if"                        { return IF; }
"else"                      { return ELSE; }
"#include"[ \t]*<[a-zA-Z0-9_./]+\.h>  { return INCLUDE; }
"true"                      { return TRUE; }
"false"                     { return FALSE; }
[-]?{digit}+                { return NUMBER; }
[-]?{digit}+\.{digit}{1,6}  { return FLOAT_NUM; }
{alpha}({alpha}|{digit})*   { return ID; }
{unary}                     { return UNARY; }

"<="                        { return LE; }
">="                        { return GE; }
"=="                        { return EQ; }
"!="                        { return NE; }
">"                         { return GT; }
"<"                         { return LT; }
"&&"                        { return AND; }
"||"                        { return OR; }

"+"                         { return ADD; }
"-"                         { return SUBTRACT; }
"/"                         { return DIVIDE; }
"*"                         { return MULTIPLY; }

\/\/.*                      { /* Skip single-line comments */ }
\/\*([^*]|\*[^/])*\*\/      { /* Skip multi-line comments */ }

\"([^\"\n]|\\\")*\"         { return STR; }
'([^'\n]|\\')'              { return CHARACTER; }

[ \t]+                      { /* Skip whitespace */ }
\n                          { /* Skip newlines */ }
.                           { return *yytext; }
<<EOF>>                     { return 0; }

%%