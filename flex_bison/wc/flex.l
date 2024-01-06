/* 一个类似Linux wc命令的程序，输出给定输入的字符数、单词数、行数，可以指定多文件输入 */

/* 这里是各种定义和声明的地方，在使用flex不指定生成文件名的模式下生成的lex.yy.c文件中会被放在前面的全局变量定义处 */
%{
    int chars = 0;
    int words = 0;
    int lines = 0;
%}

/* flex生成的C程序在编译时需要链接-lfl的原因是这个库中定义了默认的main主函数以及flex中历史遗留问题使用的yywrap函数，所以只需自定义main并且设置下面选项即可无需链接库 */
%option noyywrap
/* yylineno是flex中的记录当前所读文件行数的全局变量，默认不进行维护，这里可以设置了开启。注意flex生成的维护只能适用于单文件，如果是多文件分析就必须手动维护 */
/* %option yylineno */

/* %}后到第二个%%前都是匹配输入字符流中各种字符串的地方，每行顶头使用正则表达式来匹配字符串，匹配后会执行后面块中的代码。
这些块中的代码全部放在生成文件中的主功能函数yylex中的switch-case语句中，匹配后执行 
每个字符只会匹配一次，但有两条规则，并且先满足第一条：1、对于一个规则有多重匹配形式的，会选择最长的匹配；2、对于匹配到多个同长规则的，flex会选择第一个；
对于没有的匹配，flex会打印"Invalid char"，而后继续匹配下一个字符 */
%%
[a-zA-Z]+ {
    words++;
    chars += strlen(yytext); //yytext总是指向本次匹配的文本
}
\n {
    chars++;
    lines++;
}
. { chars++; } /* .号不会匹配换行符\n和退格\r */
<<EOF>> { yyterminate(); } /* EOF是个特殊的模式，对应于所有状态的EOF，flex读到文件末尾时会匹配的模式，默认情况就是执行yyterminate */
%%

/* 后面的代码会被放在生成文件的最后，也就是main主函数，如果想要生成文件能单独作为C文件执行，则必须在此定义main，并在其中调用主功能函数yylex */
int main(int argc, char *argv[])
{
    int totalchars = 0; //所有文件的总统计数
    int totalwords = 0;
    int totallines = 0;
    if (argc == 1) { //无文件指定，直接读取stdin(也就是不指定yyin)
        yylex();
        printf("l = %d, w = %d, c = %d\n", lines, words, chars);
        return 0;
    }
    else { //读取多文件而非stdin
        for (int i = 1; i < argc; i++)
        {
            FILE *fp = fopen(argv[i], "r");
            if (!fp) {
                perror("fopen()");
                return -1;
            }
            yyrestart(fp); //此函数可以设置flex的输入为fp，一条龙服务；还可以直接设置yyin(之前版本还需调用YY_NEW_FILE)
            yylex();
            fclose(fp);
            printf("%s: l = %d, w = %d, c = %d\n", argv[i], lines, words, chars);
            totalchars += chars;
            totalwords += words;
            totallines += lines;
            chars = 0;
            words = 0;
            lines = 0;
        }
        if (argc > 2)
            printf("total: l = %d, w = %d, c = %d\n", totallines, totalwords, totalchars);
    }
}