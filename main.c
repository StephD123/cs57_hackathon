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

int min(int x, int y, int z) {
    return min({x, y, z});
}

int editDist(vector<string>& v1, vector<string>& v2){
    int len1 = v1.size();
    int len2 = v2.size();
    vector<vector<int>> dp(len1 + 1, vector<int>(len2 + 1));
    for(int i = 0; i < len1; i++){
        dp[i][0] = i; 
    }

    for (int j = 0; j <= len2; j++) {
        dp[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
        for (int j = 1; j <= len2; j++) {
            if (v1[i - 1] == v2[j - 1])
                dp[i][j] = dp[i - 1][j - 1];  
            else
                dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + 1); // Insert, Delete, Replace
        }
    }

    return dp[len1][len2];

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
    printf("%d", v2.size());
    printf("%d", editDist(v1, v2));
}