%{
    #include <stdio.h>

    extern int yylex(void);
    extern void yyerror(char const *s);
%}

%left tPLUS

%token tSTRING tFLOAT tNUMBER tID tCONSTANT tEQ tGT tLT tGTE tLTE
%token tNEQ tPLUS tMINUS tMULT tDIV tMOD tEMARK tQMARK tAND tOR
%token tLSBRACE tRSBRACE tLPAREN tRPAREN tLBRACE tRBRACE tAT tDOT
%token tCOMMA tCOLON

%start program

%%

program: expressions

expressions: expressions expression
           | expression

expression: tNUMBER { printf("PARSED(%d)\n", $1); }
          | expression tPLUS expression { printf("%d\n", $1 + $3); }

