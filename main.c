#include<stdio.h> 
#include<stdlib.h> 
#include "y.tab.h"
#include<vector>
#include<string>
#include<algorithm>
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

int unorderedSim(vector<string> v1, vector<string> v2) {
    vector<string>::iterator it;
    for (it = v1.begin(); it != v1.end();) {
        vector<string>::iterator it2;
        bool same = false;
        for (it2 = v2.begin(); it2 != v2.end();) {
            if (*it == *it2) {
                same = true;
                auto itr2 = find(v2.begin(), v2.end(), *it2);
                if (itr2 != v2.end()) v2.erase(itr2);
            } else {
                ++it2;
            }
        }
        if (same) {
            auto itr = find(v1.begin(), v1.end(), *it);
            if (itr != v1.end()) v1.erase(itr);
        } else{
            ++it;
        }
    }

    int diff = v1.size() + v2.size();
    printf("NUMBER OF DIFFERENT TOKENS BETWEEN THE TWO: %d\n", diff);
    return diff;
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

    unorderedSim(v1, v2);
}