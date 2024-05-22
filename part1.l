/*  Lex file for compiler frontend  */

%{
#include "ast.h"
#include <stdio.h>
#include "y.tab.h"
%}
%%
    /* Identify keywords */
"int"       {   printf("%s", yytext); return INT; }
"if"        {   printf("%s", yytext); return IF; }
"while"     {   printf("%s", yytext); return WHILE; }
"else"      {   printf("%s", yytext); return ELSE; }
"print"     {   printf("%s", yytext); return PRINT; }
"extern void print(int);"   { printf("%s", yytext); return EXTERN_P; }
"extern int read();"     { printf("%s", yytext); return EXTERN_R; }
"return"    {   printf("%s", yytext); return RETURN; }
"print"     {   printf("%s", yytext); return PRINT; }
"read"      {   printf("%s", yytext); return READ; }
[0-9]*      {   /* When a number has been found, return constant */
                printf("%s", yytext); 
                yylval.ival = atoi(yytext);
                return CONST;
            }
[*/+\-()=;{}<>!]      {   printf("%s", yytext); return yytext[0]; }
[A-Za-z0-9]+   {   /* When a string has been found that is not a keyword, it is a variable/function name */
                printf("%s", yytext); 
                yylval.vname = (char*)calloc(strlen(yytext) + 1,sizeof(char));
                strcpy(yylval.vname, yytext);
                return VAR;
}
\n          { printf("%s", yytext); }
.           { printf("%s", yytext); }
%%

int yywrap() {
    return(1);
}