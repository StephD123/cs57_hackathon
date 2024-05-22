filename = lexer

all: lexer parser main

lexer: lexer.l
	lex lexer.l

parser: parser.y	
	yacc -d parser.y

main: main.c y.tab.c lex.yy.c
	g++ $^ -o $@
clean:
	rm -f lex.yy.c
	rm -f y.tab.c
	rm -f y.tab.h
	rm -rf main