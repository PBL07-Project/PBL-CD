%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
int yylex();
%}

%token VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID
%token LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program: headers main '(' ')' '{' bodies return_stmt '}';

headers: headers INCLUDE
       | INCLUDE
       ;

main: datatype ID;

datatype: INT
        | FLOAT
        | CHAR
        | VOID
        ;

bodies: body
      | bodies body
      ;

body: FOR '(' statement ';' condition ';' statement ')' '{' bodies '}'
    | IF '(' condition ')' '{' bodies '}' %prec LOWER_THAN_ELSE
    | IF '(' condition ')' '{' bodies '}' ELSE '{' bodies '}'
    | statement ';'
    | PRINTFF '(' STR ')' ';'
    | SCANFF '(' STR ',' '&' ID ')' ';'   // ✅ & is allowed directly
    ;

condition: value relop value
         | TRUE
         | FALSE
         ;

statement: datatype ID init
         | ID '=' expression
         | ID UNARY
         | UNARY ID
         ;

init: '=' value
    | /* empty */
    ;

expression: expression arithmetic expression
          | value
          ;

arithmetic: ADD
          | SUBTRACT
          | MULTIPLY
          | DIVIDE
          ;

relop: LT
     | GT
     | LE
     | GE
     | EQ
     | NE
     ;

value: NUMBER
     | FLOAT_NUM
     | CHARACTER
     | ID
     ;

return_stmt: RETURN value ';'
           | /* empty */
           ;

%%

int main() {
    if (yyparse() == 0)
        printf("Parsing successful ✅\n");
    else
        printf("Parsing failed ❌\n");
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "Syntax error: %s\n", msg);
}
