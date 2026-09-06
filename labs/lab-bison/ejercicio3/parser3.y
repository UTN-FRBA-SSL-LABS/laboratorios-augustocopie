%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int  yylex(void);
void yyerror(const char *msg) { fprintf(stderr, "Error: %s\n", msg); }
%}

%token NUM
%token POW
%token UMINUS   /* token ficticio para el menos unario — ya declarado, no hay que tocarlo */

/*
 * Declaraciones de precedencia y asociatividad.
 * En Bison, las directivas que van más abajo tienen mayor precedencia.
 */
%left '+' '-'           /* TODO 1: Menor precedencia, asociatividad izquierda */
%left '*' '/'           /* TODO 2: Mayor que +, -, asociatividad izquierda */
%right POW              /* TODO 3: Mayor que *, /, asociatividad derecha (2^3^2 = 2^(3^2)) */
%right UMINUS           /* TODO 4: Máxima precedencia, asociatividad derecha */

%%

input:
    /* vacío */
  | input linea
  ;

linea:
    exp '\n'   { printf("= %d\n", $1); }
  ;

exp:
    exp '+' exp           { $$ = $1 + $3; }
  | exp '-' exp           { $$ = $1 - $3; }
  | exp '*' exp           { $$ = $1 * $3; }
  | exp '/' exp           { $$ = $1 / $3; }
  | exp POW exp           { $$ = (int)pow($1, $3); }
  | '-' exp %prec UMINUS  { $$ = -$2; } /* TODO 5: Negar el valor de exp ($2) */
  | '(' exp ')'           { $$ = $2; }
  | NUM                   { $$ = $1; }
  ;

%%

int main(void) {
    return yyparse();
}