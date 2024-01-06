/* 读取文件并将其中#include包含的文件的内容全部展开，目前只支持可直接识别路径的文件包含，并且不能在命令行指定输出文件，而是需要修改yyout */
/* 默认行为下flex遇见没有设定模式的匹配字符时会直接ECHO此字符，使用nodefault可以将行为转变为输出错误语句并退出 */
%option noyywrap nodefault
/* 将INCL_FILE设定为exclude起始状态，这种独占状态使得进入该状态后的字符匹配只会匹配设定为该状态的模式；相反的是%s，它可以设定include状态，匹配自身状态的同时还匹配所有无状态的模式 */
%x INCL_FILE

%{
    struct bufstack { /* 文件缓存数据栈，分别为：前节点、flex文件缓存区指针、当前文件、文件名、读到的行数 */
        struct bufstack *prev;
        YY_BUFFER_STATE bs;
        FILE *fp;
        char *fname;
        int lineno;
    } *currbs = NULL; /* 当前节点 */
    int newfile(char *fn); /* 根据传入文件名创建文件缓存区，创建节点并切换到新文件，文件创建成功返回1，失败返回0 */
    int popfile(); /* 弹出当前节点并切换到前节点文件，根节点为空或者弹出根节点返回0，其它节点返回1 */
%}

%%
^[ \t]*#[ \t]*include[ \t]*[<\"] { BEGIN INCL_FILE; /* 进入INCL_FILE起始状态 */}
<INCL_FILE>[^ \t\n\">]+ { //匹配文件名
    yylineno++; //因为读取了include行所以加1
    int res_c = input();
    while (res_c != '\n' && res_c != 0) //读取并丢弃行中的剩余字符，input读取尚未被匹配的字符
        res_c = input();
    if (!newfile(yytext)) //打开并转到include中的文件，如果失败则退出
        yyterminate();
    BEGIN INITIAL; //切回常规状态
}
<INCL_FILE>.|\n { //由于正常的文件名匹配了上述模式，而其代码中丢弃了行剩余字符并切回了常规状态，所以匹配这个模式的唯一情况就是文件名不正常
    fprintf(stderr, "line %d include error!\n", yylineno);
    yyterminate();
}
^. { //此处不能使用.*直接匹配所有字符，因为这会将#include一起匹配进去成为最长匹配，进而优先被匹配
    fprintf(yyout, "%4d ", yylineno);
    ECHO;
}
^\n {
    fprintf(yyout, "%4d ", yylineno++);
    ECHO;
}
. { ECHO; }
\n {
    yylineno++;
    ECHO;
}
<<EOF>> { //匹配所有状态的EOF
    putchar('\n');
    if (!popfile()) //弹出之前进入的include文件，如果已经是根文件则退出
        yyterminate();
}
%%

int main(int argc, char *argv[])
{
    if (argc == 1) {
        fprintf(stderr, "Usage: %s FILE...\n", argv[0]);
        return 1;
    }
    else {
        yyout = stdout; //一般来讲运行yylex时如果yyout为空则会赋值yyout为stdout，但由于我们在newfile中提前使用了yyout，所以这里必须初始化
        for (int i = 1; i < argc; i++)
        {
            if (newfile(argv[i])) {
                yyrestart(currbs->fp);
                yylex();
            }
        }
    }
}

int newfile(char *fn)
{
    FILE *f = fopen(fn, "r");
    struct bufstack *bs = (struct bufstack *)malloc(sizeof(struct bufstack));
    if (!f) { //打开文件失败
        perror(fn);
        return 0;
    }
    if (currbs) //根节点不为空时，需要记录当前文件读到的行数，以便后续弹出文件时恢复行数
        currbs->lineno = yylineno;
    bs->prev = currbs;
    bs->bs = yy_create_buffer(f, YY_BUF_SIZE); //创建文件缓存区
    bs->fp = f;
    bs->fname = strdup(fn);
    currbs = bs;
    yylineno = 1; //重置为新文件读到的行数
    yy_switch_to_buffer(currbs->bs); //切换文件缓存区及各个相关变量
    fprintf(yyout, "%s\n", currbs->fname);
    return 1;
}

int popfile()
{
    if (!currbs) //根节点为空
        return 0;
    struct bufstack *prev = currbs->prev;
    yy_delete_buffer(currbs->bs);
    fclose(currbs->fp);
    fprintf(yyout, "EOF %s\n", currbs->fname);
    free(currbs->fname);
    free(currbs);
    currbs = prev; //将当前节点转为前节点
    if (!prev) //前节点为空，即弹出的为根节点，则无需再做后续数据切换
        return 0;
    yylineno = currbs->lineno; //获取前文件的读取行数
    yy_switch_to_buffer(currbs->bs); //这里依旧使用切换缓存区函数而非yyrestart，因为后者会初始化bs
    return 1;
}
