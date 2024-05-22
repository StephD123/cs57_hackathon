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

int editDist(vector<string> v1, vector<string> v2){

}

int main(int argc, char* argv[]){
    if(argc != 3){
        fprintf(stderr, "Usage: %s prog1.c prog2.c\n", argv[0]);
        exit(1);
    }
    processFile(argv[1]);
    vector<string> v1 = tokens; 
    tokens.clear();
    processFile(argv[2]);
    vector<string> v2 = tokens;
    
    for(auto val: v1){
        printf("%s ", val.c_str());
    }
    printf("starting second\n");
    for(auto val: v2){
        printf("%s ", val.c_str());
    }
}