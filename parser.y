/*  Yacc file for compiler frontend. Constructs AST and makes a global variable pointing to root node. */

%{
#include "ast.h"
#include <stdio.h>
#include <vector>
#include "semantic_analysis.h"
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
    vector<astNode*> *slist;
    astNode* node;
}

%token <ival> CONST
%token <vname> VAR
%token IF WHILE ELSE INT PRINT RETURN READ
%token EXTERN_P EXTERN_R
%type <slist> stmt_list var_decls
%type <node> stmt expr val program func block_stmt decl cond
%nonassoc IFX
%nonassoc ELSE

%%
program     :   EXTERN_P EXTERN_R func  {   // create program node
                                            $$ = createProg(createExtern("print"), createExtern("read"), $3);
                                            root = $$;
                                        }
func        :   INT VAR '(' INT VAR ')' block_stmt   {          // create function node
                                                                $$ = createFunc($2, createVar($5), $7);
                                                                free($2);
                                                                free($5);
                                                            }
            |   INT VAR '(' ')' block_stmt           {          // create function node
                                                                $$ = createFunc($2, NULL, $5);
                                                                free($2);
                                                            }
block_stmt  :   '{' var_decls stmt_list '}' {   // create block statement node out of vars and stmt vectors
                                                vector<astNode*>* new_vec = new vector<astNode*> ();
                                                new_vec->insert(new_vec->end(), $2->begin(), $2->end());
                                                new_vec->insert(new_vec->end(), $3->begin(), $3->end());
                                                $$ = createBlock(new_vec);
                                                delete($2);
                                                delete($3);
                                            }
            |   '{' stmt_list '}'           { $$ = createBlock($2); }
var_decls   :   var_decls decl              {   // create var_decls vector
                                                $$ = $1;
                                                $$->push_back($2);
                                            }
            |   decl                        {   // create var_decls vector
                                                $$ = new vector<astNode*> ();
                                                $$->push_back($1);
                                            }
decl        :   INT VAR ';'                 { $$ = createDecl($2);  // create variable declaration node
                                              free($2); }                                      
stmt_list   :   stmt_list stmt  {   // create stmt_list vector
                            $$ = $1;
                            $$->push_back($2); }
            |   stmt    {       // create stmt node
                            $$ = new vector<astNode*> ();
                            $$->push_back($1);
                        }
    /* For stmt and expr types, create appropriate node. Details of nodes found in ast.h */
stmt        :   VAR '=' expr ';'    { 
                                        $$ = createAsgn(createVar($1), $3); 
                                        free($1);
                                    }
            |   WHILE '(' cond ')' block_stmt    { $$ = createWhile($3, $5); }
            |   IF  '(' cond ')' stmt  %prec IFX    { $$ = createIf($3, $5, NULL); }
            |   IF '(' cond ')' stmt ELSE stmt  %prec ELSE  { $$ = createIf($3, $5, $7); }
            |   PRINT '(' expr ')' ';'  { $$ = createCall("print", $3); }
            |   VAR '=' READ '(' ')' ';'    { 
                                                $$ = createAsgn(createVar($1), createCall("read", NULL));
                                                free($1);
                                            }
            |   RETURN '(' expr ')' ';' { $$ = createRet($3); }
            |   RETURN expr ';'         { $$ = createRet($2); }
            |   block_stmt              { $$ = $1; }
expr        :   val     { $$ = $1; }
            |   val '+' val { $$ = createBExpr($1, $3, add); }
            |   val '-' val { $$ = createBExpr($1, $3, sub); }
            |   val '*' val { $$ = createBExpr($1, $3, mul); }
            |   val '/' val { $$ = createBExpr($1, $3, divide); }
            |   '-' expr    { $$ = createUExpr($2, uminus); }
cond        :   val '>' val { $$ = createRExpr($1, $3, gt); }
            |   val '<' val { $$ = createRExpr($1, $3, lt); }
            |   val '<' '=' val { $$ = createRExpr($1, $4, le); }
            |   val '>' '=' val { $$ = createRExpr($1, $4, ge); }
            |   val '=' '=' val { $$ = createRExpr($1, $4, eq); }
            |   val '!' '=' val { $$ = createRExpr($1, $4, neq); }
val         :   CONST   {
                            $$ = createCnst($1);        // create constant node
                        }
            |   VAR     {
                            $$ = createVar($1);         // create variable node
                            free($1);
                        }
%%

int yyerror(const char *s) {
    fprintf(stderr,"%s\n",s);
    return 0;
}