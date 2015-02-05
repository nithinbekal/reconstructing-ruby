%{
    #include <stdio.h>
    #include "node.h"
    extern void yyerror(struct parser_state *state, const char *s);
%}

%pure-parser
%parse-param { parser_state *state }
%lex-param { state }

%union {
  int ival;
  float fval;
  char *sval;
}

%{
  extern int yylex(YYSTYPE *yylval, parser_state *state);
%}

%left tPLUS
%right tEQ

%token tSTRING tFLOAT tNUMBER tID tCONSTANT tEQ tGT tLT tGTE tLTE
%token tNEQ tPLUS tMINUS tMULT tDIV tMOD tEMARK tQMARK tAND tOR
%token tLSBRACE tRSBRACE tLPAREN tRPAREN tLBRACE tRBRACE tAT tDOT
%token tCOMMA tCOLON

%token kCLASS kDEF kEND

%start program

%%

program: expressions { printf("%s\n", state->source_file); }

expressions: expressions expression
           | expression

expression: class_definition
          | binary_expression
          | method_definition
          | variable
          | assignment
          | method_call
          | value

class_definition: kCLASS tCONSTANT expressions kEND

binary_expression: expression tPLUS expression

method_definition: kDEF tID expressions kEND
          | kDEF tID tLPAREN tID tRPAREN expressions kEND

variable: tID
        | tAT tID

assignment: variable tEQ expression

method_call: variable tDOT tID
           | tCONSTANT tDOT tID tLPAREN tSTRING tRPAREN
           | tID tSTRING

value: tNUMBER

