/* parser3.y */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern FILE *yyin;
    extern char *yytext;
    extern int yylineno;
    extern int countn;

    int yylex(void);
    void yyerror(const char *s);

    struct dataType {
        char *id_name, *data_type, *type;
        int line_no;
    } symbol_table[100];

    int count = 0;
    char current_type[32];

    int search(char *name) {
        for (int i = count - 1; i >= 0; i--)
            if (strcmp(symbol_table[i].id_name, name) == 0)
                return 1;
        return 0;
    }

    void add(char kind) {
        if (search(yytext)) return;
        symbol_table[count].id_name   = strdup(yytext);
        symbol_table[count].data_type = strdup(
            (kind=='V'||kind=='F') ? current_type : "N/A");
        symbol_table[count].type      = strdup(
            kind=='H'? "Header":
            kind=='K'? "Keyword":
            kind=='V'? "Variable":
            kind=='C'? "Constant":
            kind=='F'? "Function":"Unknown");
        symbol_table[count].line_no   = countn;
        count++;
    }

    void insert_type() {
        strcpy(current_type, yytext);
    }
%}

%union {
    int    ival;
    double fval;
    char  *sval;
}

%token <ival>   NUMBER
%token <fval>   FLOAT_NUM
%token <sval>   STR
%token          CHARACTER ID
%token          VOID INT FLOAT CHAR
%token          PRINTFF SCANFF FOR IF ELSE RETURN TRUE FALSE
%token          LE GE EQ NE GT LT AND OR ADD SUBTRACT MULTIPLY DIVIDE UNARY INCLUDE

%nonassoc IFX
%nonassoc ELSE
%left OR
%left AND
%left EQ NE
%left LT GT LE GE
%left ADD SUBTRACT
%left MULTIPLY DIVIDE
%right UNARY

%%

program
    : headers main_func
    ;

headers
    : /* empty */
    | headers INCLUDE { add('H'); }
    ;

main_func
    : INT ID '(' ')' '{' body return_stmt '}'
      { add('F'); }
    ;

body
    : /* empty */
    | body statement
    ;

statement
    : declaration ';'
    | assignment  ';'
    | print_stmt  ';'
    | scan_stmt   ';'
    | for_loop
    | if_stmt
    ;

declaration
    : type ID          { insert_type(); add('V'); }
    | type ID '=' expr { insert_type(); add('V'); }
    ;

type
    : INT   { insert_type(); }
    | FLOAT { insert_type(); }
    | CHAR  { insert_type(); }
    | VOID  { insert_type(); }
    ;

assignment
    : ID '=' expr      { add('K'); }
    | ID UNARY         { add('K'); }
    | UNARY ID         { add('K'); }
    ;

expr
    : expr ADD expr
    | expr SUBTRACT expr
    | expr MULTIPLY expr
    | expr DIVIDE expr
    | NUMBER           { add('C'); }
    | FLOAT_NUM        { add('C'); }
    | CHARACTER        { add('C'); }
    | ID
    ;

print_stmt
    : PRINTFF '(' STR ')' { add('K'); }
    ;

scan_stmt
    : SCANFF '(' STR ',' '&' ID ')' { add('K'); }
    ;

for_loop
    : FOR '(' assignment ';' condition ';' assignment ')' '{' body '}' 
      { add('K'); }
    ;

if_stmt
    : IF '(' condition ')' '{' body '}'           %prec IFX { add('K'); }
    | IF '(' condition ')' '{' body '}' ELSE '{' body '}' { add('K'); }
    ;

condition
    : expr LE expr
    | expr GE expr
    | expr LT expr
    | expr GT expr
    | expr EQ expr
    | expr NE expr
    | TRUE    { add('K'); }
    | FALSE   { add('K'); }
    ;

return_stmt
    : RETURN expr ';' { add('K'); }
    | /* nothing */
    ;

%%

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s input.c output.txt\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("fopen input"); return 1; }

    FILE *fout = fopen(argv[2], "w");
    if (!fout) { perror("fopen output"); return 1; }

        if (yyparse() == 0) {
        fprintf(fout, "\nPHASE 3: SYMBOL TABLE\n\n");
        fprintf(fout, "%-20s %-12s %-12s %s\n",
                "SYMBOL", "DATATYPE", "TYPE", "LINE");
        fprintf(fout, "----------------------------------------------------------\n");
        for (int i = 0; i < count; i++) {
            fprintf(fout, "%-20s %-12s %-12s %4d\n",
                    symbol_table[i].id_name,
                    symbol_table[i].data_type,
                    symbol_table[i].type,
                    symbol_table[i].line_no);
        }
    }


    fclose(yyin);
    fclose(fout);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", countn, s);
    
}
