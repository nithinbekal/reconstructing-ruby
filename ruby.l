%{
#include <stdio.h>
#include <string.h>
#include "parse.tab.h"
#include "node.h"

extern void yyerror(const char *s);

#define YY_DECL int yylex(YYSTYPE *yylval, parser_state *state)
#define TOKEN(id) return t##id
#define KEYWORD(id) return k##id
%}

%option noyywrap
%option yylineno

NUMBER [0-9](_[0-9]|[0-9])*

%%

class { KEYWORD(CLASS); }
def   { KEYWORD(DEF);   }
end   { KEYWORD(END);   }

#.*$ {}

{NUMBER} { yylval->ival = atoi(yytext); TOKEN(NUMBER); }
{NUMBER}(\.{NUMBER}|(\.{NUMBER})?[eE][+-]?{NUMBER}) { yylval->fval = atof(yytext); TOKEN(FLOAT); }

\"([^"]|\\.)*\" { yylval->sval = strdup(yytext); TOKEN(STRING); }
\'([^']|\\.)*\' { yylval->sval = strdup(yytext); TOKEN(STRING); }

[a-z_][a-zA-Z0-9_]* { yylval->sval = strdup(yytext); TOKEN(ID); }
[A-Z][a-zA-Z0-9_]*  { yylval->sval = strdup(yytext); TOKEN(CONSTANT); }

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

