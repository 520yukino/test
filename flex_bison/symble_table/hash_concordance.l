/* 重要词语索引生成器，读入文件的单词，而后使用hash法创建索引表，并打印各个单词的文件信息 */
/* case-insensitive选项可以使模式忽略大小写 */
%option noyywrap nodefault yylineno case-insensitive

%{
struct symbol { //符号结构，包含符号名称和符号引用表的头尾指针
    char *name;
    struct ref *head, *tail;
};
struct ref { //符号引用表节点，包含下一节点指针、符号出现的文件名称、行数、符号标志值
    struct ref *next;
    char *fname;
    int line;
    int flag;
};
#define NSYMBOL 10000 //符号表的长度，符号表定义，当前读取的文件名称
struct symbol symtab[NSYMBOL];
char *currfname;

static unsigned SymHash(char *name); //返回name对应的hash值，后续处理后作为访问name对应的symtab元素的下标
static struct symbol *lookup(char *name); //根据SymHash的结果查找name对应的symtab元素
void AddRef(char *name, char *fn, int line, int flag); //添加name的符号引用

static int SymCompare(const void *sa, const void *sb); //qsort中使用的比较函数，比较symbol中name的大小，
void PrintSymtab(); //顺序打印符号表
%}

%%
if |
else |
for |
while |
unsigned |
int |
long |
float |
double |
char |
struct |
class |
this
switch |
case |
default |
void { } /* 移除这些关键字 */
[a-z]+('(s|t|ll))? { AddRef(yytext, currfname, yylineno, 0); }
.|\n { }
%%

int main(int argc, char *argv[])
{
    if (argc == 1) {
        fprintf(stderr, "Usage: %s FILE...\n", __FILE__);
        return -1;
    }
    for (int i = 1; i < argc; i++) //将所有文件中的单词装填到符号表
    {
        FILE *f = fopen(argv[i], "r");
        if (!f) {
            perror(argv[i]);
            return -1;
        }
        currfname = argv[i];
        yyrestart(f);
        yylineno = 1; //重置行数
        yylex();
        fclose(f);
    }
    PrintSymtab();
}

static unsigned SymHash(char *name)
{
	unsigned hash = 0;
    char c;
    while ((c = *name++) != '\0') //利用符号中的所有字符计算hash值
        hash = hash*10^c;
    return hash;
}

static struct symbol *lookup(char *name)
{
    struct symbol *sp = symtab+SymHash(name)%NSYMBOL; //获取name对应hash值并将其作为数组偏移量
    for (int i = 0; i < NSYMBOL; i++) //查找symtab，找到就返回sp，有空位就添加sp，全部搜索后都无果则表示满员错误
    {
        if (sp->name && !strcmp(sp->name, name))
            return sp;
        if (!sp->name) {
            sp->name = strdup(name);
            sp->head = sp->tail = NULL;
            return sp;
        }
        if (++sp >= symtab+NSYMBOL) //到了数组末尾，跳转到开头继续查找
            sp = symtab;
    }
    fputs("symtab overflow!\n", stderr);
    abort();
}

void AddRef(char *name, char *fn, int line, int flag)
{
	struct ref *rp = NULL;
    struct symbol *sp = lookup(name);
    if (sp->head && sp->tail->fname == fn && sp->tail->line == line)
        return; //为减少符号表的打印内容，不引用在同文件同行的词语
    rp = (struct ref *)malloc(sizeof(struct ref));
    rp->next = NULL;
    rp->fname = fn;
    rp->line = line;
    rp->flag = flag;
    if (!sp->head)
        sp->head = rp;
    else
        sp->tail->next = rp;
    sp->tail = rp;
}

static int SymCompare(const void *sa, const void *sb)
{
	const struct symbol *a = (const struct symbol *)sa, *b = (const struct symbol *)sb;
    if (!a->name) {
        if (!b->name)
            return 0;
        else
            return 1;
    }
    else if (!b->name)
        return -1;
    return strcmp(a->name, b->name);
}

void PrintSymtab()
{
	struct symbol *sp;
    struct ref *rp;
    char *prevfn; //相同文件名就无需重复打印了
    qsort(symtab, NSYMBOL, sizeof(struct symbol), SymCompare);
    for (sp = symtab; sp->name && sp < symtab+NSYMBOL; sp++)
    {
        prevfn = NULL;
        printf("%s -> ", sp->name);
        for (rp = sp->head; rp; rp = rp->next) //循环符号表中的每条引用链并打印
        {
            if (rp->fname == prevfn)
                printf(" %d", rp->line);
            else {
                printf("%s: %d", rp->fname, rp->line);
                prevfn = rp->fname;
            }
        }
        putchar('\n');
    }
}
