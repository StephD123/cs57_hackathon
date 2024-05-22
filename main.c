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

double normalizedEditDist(vector<string>& v1, vector<string>& v2){
    float len1 = v1.size();
    float len2 = v2.size();
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

    return 1 - dp[len1][len2] / max(len1, len2);

}

/********************* unorderedSim ********************/
/*
* Find similarity score of two miniC programs, unordered
* Programs which share no tokens will have similarity score of 0.
* Programs which share all same tokens will have similarity score of 1.0.
*
* Returns float similarity score (0.0-1.0).
*/
float unorderedSim(vector<string> v1, vector<string> v2) {
    int tot_tokens = v1.size() + v2.size();

    vector<string>::iterator it;
    for (it = v1.begin(); it != v1.end();) {
        vector<string>::iterator it2;
        bool same = false;
        for (it2 = v2.begin(); it2 != v2.end();) {
            if (*it == *it2) {
                same = true;
                auto itr2 = find(v2.begin(), v2.end(), *it2);
                if (itr2 != v2.end()) v2.erase(itr2);
                break;
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
    float per_same = (float) (tot_tokens - diff) / (float) tot_tokens;
    return per_same;
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
    float score = (unorderedSim(v1, v2) + normalizedEditDist(v1, v2)) / 2;
    printf("Score: %f\n", score);
}