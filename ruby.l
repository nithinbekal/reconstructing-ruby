%{
  #include <stdio.h>
%}

%option noyywrap

%%

[0-9]+ { printf("NUMBER: %s\n", yytext); }
.      { fprintf(stderr, "Unknown token, %s\n", yytext); }
\n     {}

%%
