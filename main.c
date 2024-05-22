#include<stdio.h> 
#include<stdlib.h> 
#include "y.tab.h"
#include<vector>
#include<string>
using namespace std;
extern int yyparse();
extern int yylex_destroy();
extern FILE *yyin;
extern vector<string> tokens;

void processFile(char* filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Unable to open file");
        exit(0);
    }
    yyin = file;
    yyparse();
    fclose(file);
}

int main(int argc, char* argv[]){
    if(argv != 3){
        fprintf(stderr, "Usage: %s prog1.c prog2.c\n", argv[1]);
        exit(1);
    }
    processFile(argv[1]);
}