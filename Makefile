filename = part1

$(filename).out: $(filename).l $(filename).y semantic_analysis.c main.c
	yacc -d --debug -Wcounterexamples $(filename).y
	lex $(filename).l
	g++ -g lex.yy.c y.tab.c ast.c semantic_analysis.c main.c -o $(filename).out

clean:
	rm -f lex.yy.c
	rm -f y.tab.c
	rm -f y.tab.h
	rm -f part1.out