/*  Yacc file for compiler frontend. Constructs AST and makes a global variable pointing to root node. */

%{
#include <stdio.h>
#include <vector>
#include "y.tab.h"
extern int yylex();
extern int yylex_destroy();
extern int yywrap();
int yyerror(const char *);
extern FILE * yyin;

using namespace std;
astNode* root;      // global variable pointer to root node of AST
%}
%union{
    int ival;
    char *vname;
}

%token <ival> CONST
%token <vname> VAR
%token IF WHILE ELSE INT PRINT RETURN READ
%token EXTERN_P EXTERN_R
%nonassoc IFX
%nonassoc ELSE

%%
program     :   EXTERN_P EXTERN_R func 
func        :   INT VAR '(' INT VAR ')' block_stmt   
            |   INT VAR '(' ')' block_stmt        
block_stmt  :   '{' var_decls stmt_list '}' 
            |   '{' stmt_list '}'          
var_decls   :   var_decls decl   
            |   decl                
decl        :   INT VAR ';'                                                 
stmt_list   :   stmt_list stmt 
            |   stmt   
    /* For stmt and expr types, create appropriate node. Details of nodes found in ast.h */
stmt        :   VAR '=' expr ';'    
            |   WHILE '(' cond ')' block_stmt  
            |   IF  '(' cond ')' stmt  %prec IFX    
            |   IF '(' cond ')' stmt ELSE stmt  %prec ELSE  
            |   PRINT '(' expr ')' ';'  
            |   VAR '=' READ '(' ')' ';'  
            |   RETURN '(' expr ')' ';' 
            |   RETURN expr ';'        
            |   block_stmt           
expr        :   val     
            |   val '+' val 
            |   val '-' val 
            |   val '*' val 
            |   val '/' val 
            |   '-' expr    
cond        :   val '>' val
            |   val '<' val 
            |   val '<' '=' val 
            |   val '>' '=' val 
            |   val '=' '=' val 
            |   val '!' '=' val 
val         :   CONST  
            |   VAR  
%%

int yyerror(const char *s) {
    fprintf(stderr,"%s\n",s);
    return 0;
}