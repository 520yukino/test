%{
#include <stdio.h>
int yylex();
void yyrestart (FILE *input_file);
int yyerror(int a, char *s) { puts(s); }
%}
%union {
    int NAME;
    char EOL;
}
%parse-param { int a } /* 这个设置可以添加yyparse的参数，但注意只能添加一个，因为yydestruct和yyerror在yyparse中的调用只会自动生成添加一个参数的调用。还有注意yyerror的定义以及yyparse在main中的调用格式 */
%token NAME EOL CLEAR
%type<NAME> exp
    <EOL> explist symlist calclist litter
%left '+' '-'
%token A B C
%type a b c d
%%
calclist: {}
    | calclist symlist ' ' explist EOL {puts("t 0");}
    | litter
    | a
    | c
    ;
exp: NAME {puts("t 1");$$=1;}
    | exp '+' exp
    | exp '-' exp
    ;
explist: exp {puts("t 2");$$='a';}
    | exp ',' explist {puts("t 3");}
    ;
symlist: NAME {puts("t 4");}
    | NAME ',' symlist {puts("t 5");}
    | CLEAR { puts("t 6");yyrestart(stdin); }
    ;
litter: '*' '&'

/* a: A ',' A ',' symlist
b: A ','
c: b A symlist */

a: A ',' A ',' symlist
b: c A ',' A
    | A A B
c: b symlist
    | A d C
d:
    | A
%%
int main()
{
    yyparse(114514);
}