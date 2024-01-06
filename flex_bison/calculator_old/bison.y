//bison和flex文件的总体形式是类似的
%{ //声明部分，会放在目标文件的开头，这里应该声明两个函数，yylex是flex中的主函数，yyerror是bison中使用的错误执行函数，这两个函数在bison中都有使用，如果不写则会警告隐式声明
#include <stdio.h>
int yylex();
void yyerror(char *s);
extern int hex_flag; //lexer中的16进制标志
%}

%union { int int_val; } //%union定义后续要用的数据类型，这个联合会通用于所有符号，包括yylval这样的自生成变量
%token <int_val> NUM ADD SUB MUL DIV OR AND EOL L_BRACKET R_BRACKET//%token定义终结符，可用于flex文件规则项的执行代码的返回值中，也用于后续的规则中，依次为数字、加、减、乘、除、或(两个则为绝对值)、与、\n、左括号、右括号
%type <int_val> calclist exp factor term //%type定义非终结符，它们用于表示后续的目标符号，由于它们可以被后侧的记号替换，所以是非终结的

%%
/* 最左侧为目标符号(记号)，第一个为语法起始符号，整个输入必须被它匹配
冒号右侧为可替代符号组，|为"这个组也能替代"，;是规则的终止
每行规则中符号的语义值可以用$x来使用，其中目标符号为$$，右侧符号从$1开始
每个记号都有自己的值，如果flex的某个匹配规则的执行代码中对yylval赋值，则记号的语义值&x就为yylval的值
没有即为空规则，在有的时候是必要的，比如程序需要循环计算多个表达式。当然，空规则本身是不合适的(有警告) */
/* 这些规则的会遵守一个原则：先预读，后规约。比如对于3*3*3+3的输入，程序会先将前5个符号都匹配为factor后再将其匹配到exp；反之，如果先将前3个符号规约到exp，那后面的符号将无法匹配 */
calclist: { $$ = 0; puts("test d");}
    | calclist EOL{puts("test e");}
    | calclist exp EOL {puts("test f");
        if (!hex_flag)
            printf("= %d\n", $2);
        else {
            printf("= %d, 0x%x\n", $2, $2);
            hex_flag = 0;
        }
    }
    ;
exp: factor {puts("test a");}//规则如果缺少显示的动作代码，则默认为$$=$1，这是合理的
    | exp ADD factor { $$ = $1+$3; puts("test 1");}
    | exp SUB factor { $$ = $1-$3; puts("test 2");}
    | exp OR factor { $$ = $1|$3; puts("test 3");}
    | exp AND factor { $$ = $1&$3; puts("test 4");}
    ;
factor: term{puts("test b");}
    | factor MUL term { $$ = $1*$3; puts("test 5");}
    | factor DIV term { $$ = $1/$3; puts("test 6");}
    ;
term: NUM{puts("test c");}
    | ADD NUM { $$ = $2; puts("test 7");}
    | SUB NUM { $$ = -$2; puts("test 8");}
    | OR term OR { $$ = ($2 >= 0) ? $2 : -$2; puts("test 9");}
    | L_BRACKET exp R_BRACKET { $$ = $2; puts("test 0");} //规则可以任意包含其它记号，这里的规则很巧妙，它还可以让在括号中使用正负数的输入成为可能，因为exp的子符号中有term
    ;
%%

int main()
{
    yyparse(); //这是bison中的主运行函数，其中会调用yylex
}

void yyerror(char *s) //错误处理函数，bison中直接传入字符串来使用这个函数
{
    fprintf(stderr, "yyerror: %s\n", s);
}