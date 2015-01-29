%{
#include <stdio.h>
#include "parse.tab.h"

extern void yyerror(const char *s);

#define VTYPE(type, value) printf("%s(%s)\n", type, value)
#define TOKEN(id) return t##id
%}

%option noyywrap
%option yylineno

NUMBER [0-9](_[0-9]|[0-9])*

%%

#.*$ {}

{NUMBER} { yylval = atoi(yytext); TOKEN(NUMBER); }
{NUMBER}(\.{NUMBER}|(\.{NUMBER})?[eE][+-]?{NUMBER}) { VTYPE("FLOAT", yytext); TOKEN(FLOAT); }

\"([^"]|\\.)*\" { VTYPE("STRING", yytext); TOKEN(STRING); }
\'([^']|\\.)*\' { VTYPE("STRING", yytext); TOKEN(STRING); }

[a-z_][a-zA-Z0-9_]* { VTYPE("ID", yytext); TOKEN(ID); }
[A-Z][a-zA-Z0-9_]* { VTYPE("CONSTANT", yytext); TOKEN(CONSTANT); }

"=" { TOKEN(EQ);    }
"+" { TOKEN(PLUS);  }
"-" { TOKEN(MINUS); }
"*" { TOKEN(MULT);  }
"/" { TOKEN(DIV);   }

">"  { TOKEN(GT);  }
"<"  { TOKEN(LT);  }
">=" { TOKEN(GTE); }
"<=" { TOKEN(LTE); }
"!=" { TOKEN(NEQ); }

"%" { TOKEN(MOD); }  
"!" { TOKEN(EMARK); }  
"?" { TOKEN(QMARK); }  
"&" { TOKEN(AND); }  
"|" { TOKEN(OR); }  

"[" { TOKEN(LSBRACE); }  
"]" { TOKEN(RSBRACE); }  
"(" { TOKEN(LPAREN); }  
")" { TOKEN(RPAREN); }  
"{" { TOKEN(LBRACE); }  
"}" { TOKEN(RBRACE); }  

"@" { TOKEN(AT); }  
"." { TOKEN(DOT); }  
"," { TOKEN(COMMA); }  
":" { TOKEN(COLON); }  

[\t\n ] {}

. { fprintf(stderr, "Unknown token, '%s'\n", yytext); }

%%

void yyerror(const char *s) {
  fprintf(stderr, "%s. Unexpected \"%s\" on line %d.", s, yytext, yylineno);
}

