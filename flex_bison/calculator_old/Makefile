calc.out: flex.c bison.c #计算器可执行文件编译
	gcc flex.c bison.c -o $@
flex.c: flex.l #flex编译
	flex -o $@ flex.l
bison.c: bison.y #bison编译，-d表示同时生成bison.h头文件
	bison -d -o $@ bison.y