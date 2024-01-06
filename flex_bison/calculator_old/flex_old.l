%{
enum yytokentype { //定义token的枚举值，从258开始，依次为数字、加、减、乘、除、绝对值、\n
    NUM = 258,
    ADD,
    SUB,
    MUL,
    DIV,
    ABS,
    EOL
};
int yytval; //后续代码需要使用的量，记录token的值
%}

%%
[0-9]+ {
    yytval = atoi(yytext);
    return NUM; //在yylex中将该token作为返回值
}
"+" { return ADD; }
"-" { return SUB; }
"*" { return MUL; }
"/" { return DIV; }
"|" { return ABS; }
\n { return EOL; }
[ \t] { }
. { printf("Invalid char %c\n", *yytext); }
%%

int main(int argc, char *argv[])
{
    int token;
    while (token = yylex())
    {
        if (token == NUM)
            printf("%d = %d\n", token, yytval);
        else
            printf("%d\n", token);
    }
}