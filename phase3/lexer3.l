/* lexer3.l */
%{
    #include "parser3.h"    /* tokens & YYSTYPE from Bison */
    #include <stdlib.h>
    #include <string.h>

    /* shared line counter */
    int countn = 1;
    extern int yylineno;
%}

%option yylineno noyywrap

alpha       [a-zA-Z]
digit       [0-9]
unary       "++"|"--"

%%

"#include"[ \t]*<[a-zA-Z0-9_./]+\.h> {
    countn = yylineno;
    return INCLUDE;
}

"printf"    { countn = yylineno; return PRINTFF; }
"scanf"     { countn = yylineno; return SCANFF; }
"int"       { countn = yylineno; return INT; }
"float"     { countn = yylineno; return FLOAT; }
"char"      { countn = yylineno; return CHAR; }
"void"      { countn = yylineno; return VOID; }
"return"    { countn = yylineno; return RETURN; }
"for"       { countn = yylineno; return FOR; }
"if"        { countn = yylineno; return IF; }
"else"      { countn = yylineno; return ELSE; }
"true"      { countn = yylineno; return TRUE; }
"false"     { countn = yylineno; return FALSE; }

[-]?{digit}+\.{digit}{1,6} {
    countn = yylineno;
    yylval.fval = atof(yytext);
    return FLOAT_NUM;
}
[-]?{digit}+ {
    countn = yylineno;
    yylval.ival = atoi(yytext);
    return NUMBER;
}
{alpha}({alpha}|{digit})* { countn = yylineno; return ID; }
{unary}                  { countn = yylineno; return UNARY; }

"<="  { countn = yylineno; return LE; }
">="  { countn = yylineno; return GE; }
"=="  { countn = yylineno; return EQ; }
"!="  { countn = yylineno; return NE; }
">"   { countn = yylineno; return GT; }
"<"   { countn = yylineno; return LT; }
"&&"  { countn = yylineno; return AND; }
"||"  { countn = yylineno; return OR; }

"+"   { countn = yylineno; return ADD; }
"-"   { countn = yylineno; return SUBTRACT; }
"/"   { countn = yylineno; return DIVIDE; }
"*"   { countn = yylineno; return MULTIPLY; }

\"([^\"\n]|\\\")*\" {
    countn = yylineno;
    yylval.sval = strdup(yytext);
    return STR;
}
'([^'\n]|\\')' { countn = yylineno; return CHARACTER; }

\/\/.*                      { /* skip single-line comment */ }
\/\*([^*]|\*[^/])*\*\/      { /* skip multi-line comment */ }

[ \t]+      { /* skip whitespace */ }
\n          { yylineno++; countn = yylineno; }
<<EOF>>     { return 0; }
.           { return *yytext; }

%%
