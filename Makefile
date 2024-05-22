filename = lexer

all: lexer parser 

lexer: lexer.l
	lex lexer.l

parser: parser.y	
	yacc -d parser.y

clean:
	rm -f lex.yy.c
	rm -f y.tab.c
	rm -f y.tab.h