/* 与bison联合编译时，需要包含bison生成的头文件(如果生成了的)；
另外也需要删除第三部分的main主函数，因为bison中有main的定义；
bison的主函数yyparse会调用flex的主函数yylex
这里还可以在包含bison头文件之前使用宏定义YYSTYPE(这是bison中所有记号的类型，包括yylval)的类型，否则默认为bison中的union类型，当然，通常不需要这么做 */
%{
#include "bison.h"
int hex_flag = 0; //16进制标志
%}

%option noyywrap

%%
[0-9]+ {
    yylval.int_val = atoi(yytext); //这两个量非常重要，lval可以像parser传递这个匹配规则所代表的值，bison会赋给对应的符号；而text是lexer目前匹配的字符串指针
    return NUM;
}
0x[0-9a-f]+ { //16进制的匹配，需要使用strtol并设标志
    hex_flag = 1;
    yylval.int_val = strtol(yytext, NULL, 16);
    return NUM;
}
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"|" { return OR; }
"&" { return AND; }
"(" { return L_BRACKET; }
")" { return R_BRACKET; }
"//".* { }
\n { return EOL; }
[ \t] { }
. { printf("Invalid char %c\n", *yytext); }
%%
