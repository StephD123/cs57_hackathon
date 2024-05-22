/*  Lex file for hackathon  */
%{
#include <stdio.h>
#include "y.tab.h"
#include<vector> 
#include<string> 
using namespace std; 
vector<string> tokens;
%}
%%
    /* Identify keywords */
"int"       {tokens.push_back(yytext); return INT; }
"if"        {tokens.push_back(yytext); return IF; }
"while"     {tokens.push_back(yytext); return WHILE; }
"else"      {tokens.push_back(yytext); return ELSE; }
"print"     {tokens.push_back(yytext); return PRINT; }
"extern void print(int);"   {tokens.push_back("extern print"); return EXTERN_P; }
"extern int read();"     {tokens.push_back("extern read"); return EXTERN_R; }
"return"    {tokens.push_back(yytext); return RETURN; }
"print"     {tokens.push_back(yytext); return PRINT; }
"read"      {tokens.push_back(yytext); return READ; }
[0-9]*      {  tokens.push_back(yytext); return CONST; }
[*/+\-()=;{}<>!]      { tokens.push_back(yytext); return yytext[0]; }
[A-Za-z0-9]+   {   /* When a string has been found that is not a keyword, it is a variable/function name */
                tokens.push_back("VAR");
                return VAR;}
[ \n\t]         
.           { tokens.push_back(yytext); }
%%

int yywrap() {
    return(1);
}