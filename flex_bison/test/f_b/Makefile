main: flex bison #计算器可执行文件编译
	gcc lex.yy.c bison.tab.c -I .
flex: flex.l #flex编译
	flex flex.l
bison: bison.y #bison编译，-d表示同时生成bison.h头文件
	bison -d bison.y