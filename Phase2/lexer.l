%{
#include "y.tab.h"
int countn = 0;
%}

%option yylineno

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
"#include"[ \t]*<.+\.h>     { return INCLUDE; }
"true"                      { return TRUE; }
"false"                     { return FALSE; }
[-]?{digit}+                { return NUMBER; }
[-]?{digit}+"."{digit}{1,6} { return FLOAT_NUM; }
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

\/\/.*                     { /* single-line comment */ }
\/\*([^*]|\*[^/])*\*\/     { /* multi-line comment */ }

["][^"]*["]                 { return STR; }
['].[']                     { return CHARACTER; }

[ \t]+                     { /* skip whitespace */ }
\n                         { countn++; }
.                          { return *yytext; }

%%
int yywrap() { return 1; }
