%{
#include <stdio.h>
#include <stdlib.h>
void yyerror(const char *s);
int yylex();
extern FILE *yyin;
extern int yylineno;
%}

%token VOID CHARACTER PRINTFF SCANFF INT FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID
%token LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN

%nonassoc IF
%nonassoc ELSE
%left OR
%left AND
%left EQ NE
%left LT GT LE GE
%left ADD SUBTRACT
%left MULTIPLY DIVIDE
%right UNARY

%%

program: headers main_function;

headers: /* empty */
       | headers INCLUDE
       ;

main_function: INT ID '(' ')' '{' body return_stmt '}';

body: /* empty */
    | body statement
    ;

statement: declaration ';'
        | assignment ';'
        | print_stmt ';'
        | scan_stmt ';'
        | for_loop
        | if_stmt
        ;

declaration: type ID
           | type ID '=' expression
           ;

type: INT
     | FLOAT
     | CHAR
     ;

assignment: ID '=' expression
          | ID UNARY
          | UNARY ID
          ;

expression: NUMBER
          | FLOAT_NUM
          | CHARACTER
          | ID
          | expression ADD expression
          | expression SUBTRACT expression
          | expression MULTIPLY expression
          | expression DIVIDE expression
          ;

print_stmt: PRINTFF '(' STR ')';

scan_stmt: SCANFF '(' STR ',' '&' ID ')';

for_loop: FOR '(' assignment ';' condition ';' assignment ')' '{' body '}';

if_stmt: IF '(' condition ')' '{' body '}' else_part;

else_part: /* empty */
         | ELSE '{' body '}'
         ;

condition: expression comp_op expression
         | TRUE
         | FALSE
         ;

comp_op: LT | GT | LE | GE | EQ | NE;

return_stmt: RETURN expression ';'
          | /* empty */
          ;

%%

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            exit(1);
        }
    }
    
    if (yyparse() == 0) {
        printf("Parsing successful ✅\n");
    } else {
        printf("Parsing failed ❌\n");
    }
    
    if (argc > 1) fclose(yyin);
    return 0;
}

void yyerror(const char *msg) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, msg);
    exit(1);
}