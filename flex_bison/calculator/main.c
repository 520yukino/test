#include "h.h"
#include <stdarg.h> //多参数所需头文件
#include <math.h> //内置函数所需的数学函数

SYMBOL symtab[NSYMBOL] = {0};
int flag_noput = 0;

int main()
{
    printf("> ");
    yyparse();
}

SYMBOL *Lookup(char *name)
{
	unsigned hash = 0;
    char c;
    for (int i = 0; (c = name[i]) != '\0'; i++) //利用符号中的所有字符计算hash值
        hash = hash*10^c;
    hash %= NSYMBOL;
    SYMBOL *sp = symtab+hash;
    for (int i = 0; i < NSYMBOL; i++) //查找symtab，找到就返回sp，有空位就添加sp，全部搜索后都无果则表示满员错误
    {
        if (sp->name && !strcmp(sp->name, name))
            return sp;
        if (!sp->name) {
            sp->name = strdup(name);printf("Lookup: %p, %s\n", sp, sp->name);
            return sp;
        }
        if (++sp >= symtab+NSYMBOL) //超出数组末尾，跳转到开头继续查找
            sp = symtab;
    }
    fputs("symtab overflow!\n", stderr);
    abort();
}

AST *NewAst(int nodetype, AST *l, AST *r)
{
    AST *a = (AST *)malloc(sizeof(AST));
    a->nodetype = nodetype;
    a->l = l;
    a->r = r;
    return a;
}

AST *NewNum(double num)
{
    struct num_ast *a = (struct num_ast *)malloc(sizeof(struct num_ast));
    a->nodetype = NT_num;
    a->num = num;
    return (AST *)a;
}

AST *NewRef(SYMBOL *sym)
{
    struct ref_ast *a = (struct ref_ast *)malloc(sizeof(struct ref_ast));
    a->nodetype = NT_ref;
    a->sym = sym;
    return (AST *)a;
}

AST *NewAsgn(SYMBOL *sym, AST *ast)
{
    struct asgn_ast *a = (struct asgn_ast *)malloc(sizeof(struct asgn_ast));
    a->nodetype = '=';
    a->sym = sym;
    a->ast = ast;
    return (AST *)a;
}

AST *NewBIF(enum build_in_func functype, AST *ast)
{
    struct bif_ast *a = (struct bif_ast *)malloc(sizeof(struct bif_ast));
    a->nodetype = NT_bif;
    a->functype = functype;
    a->ast = ast;
    return (AST *)a;
}

AST *NewUF(SYMBOL *sym, AST *ast)
{
    struct uf_ast *a = (struct uf_ast *)malloc(sizeof(struct uf_ast));
    a->nodetype = NT_uf;
    a->sym = sym;
    a->ast = ast;
    return (AST *)a;
}

AST *NewStmt(int nodetype, AST *cond, AST *first, AST *second)
{
    struct stmt_ast *a = (struct stmt_ast *)malloc(sizeof(struct stmt_ast));
    a->nodetype = nodetype;
    a->cond = cond;
    a->first = first;
    a->second = second;
    return (AST *)a;
}

SYMLIST *NewSymList(SYMBOL *sym, SYMLIST *next)
{
    SYMLIST *sl = (SYMLIST *)malloc(sizeof(SYMLIST));
    sl->sym = sym;
    sl->next = next; //直接将此节点当做新的头节点，这是右递归的链表构造方式
    return sl;
}

void FreeSymList(SYMLIST *sl)
{
    SYMLIST *temp;
    while (sl)
    {
        temp = sl->next;
        free(sl);
        sl = temp;
    }
}

AST *NewStmtList(AST *ast)
{
    struct stmtlist_ast *sa = (struct stmtlist_ast *)malloc(sizeof(struct stmtlist_ast));
    struct stmt_node *node = (struct stmt_node *)malloc(sizeof(struct stmt_node));
    node->ast = ast;
    node->next = NULL;
    sa->nodetype = NT_stmtlist;
    sa->head = sa->tail = node;
    return (AST *)sa;
}

void NewStmtNode(struct stmtlist_ast *sa, AST *ast)
{
    struct stmt_node *node = (struct stmt_node *)malloc(sizeof(struct stmt_node));
    node->ast = ast;
    node->next = NULL;
    sa->tail->next = node;
    sa->tail = node;
}

void FuncDef(SYMBOL *sym, SYMLIST *sl, AST *block)
{
    //先释放可能存在的函数定义的内容再赋值
    if (sym->sl)
        FreeSymList(sym->sl);
    if (sym->ast)
        TreeFree(sym->ast);
    sym->sl = sl;
    sym->ast = block;
    printf("Defined %s\n> ", sym->name);
}

/* 语法分析中的BIF只有接受一个实参的规则匹配，所以此处无需判断实参个数，这种做法使得BIF速度更快 */
double CallBIF(struct bif_ast *ast)
{
    double res = CalcVal(ast->ast); //计算实参
    switch (ast->functype) //根据调用的BIF类型来调用相应的函数
    {
    case BIF_abs:
        res = (res < 0) ? -res : res;
        break;
    case BIF_sqrt:
        res = sqrt(res);
        break;
    case BIF_exp:
        res = exp(res);
        break;
    case BIF_log:
        res = log(res);
        break;
    case BIF_print:
        printf("%lf\n", res);
        break;
    default:
        yyerror("in CallBIF: invalid functype %d", ast->functype);
    }
    return res;
}

/* 由于统一使用一个符号表，所以函数的形参也会被保存在此，这样形参的名称可能和其它变量相同，为了正常使用形参并保护同名变量的值，先保存形参值，而后将实参值赋给形参参与函数体的计算，最后恢复形参原来的值 */
double CallUF(struct uf_ast *ast)
{
    SYMBOL *sym = ast->sym; //函数符号
    if (!sym->ast) { //调用了没有定义的函数，将flag置1表示不输出结果，由于bison中的空block也使用NULL，所以会被当做无定义处理
        yyerror("in CallUF: function %s undefined", sym->name);
        flag_noput = 1;
        return 0;
    }
    if (!sym->sl) //函数没有形参，则直接计算值即可
        return CalcVal(sym->ast);
    double res; //计算结果
    SYMLIST *sl = sym->sl; //形参列表
    AST *arg = ast->ast; //函数实参
    int argc = 0; //实参数目
    while (sl) //计算形参数量
    {
        argc++;
        sl = sl->next;
    }printf("argc = %d, arg: %p\n", argc, arg);

    double *oldval, *newval; //形参以前的值和现在实参的值
    oldval = (double *)malloc(sizeof(double)*argc);
    newval = (double *)malloc(sizeof(double)*argc);
    int i;
    for (i = 0; i < argc; i++) //计算实参的值
    {
        if (!arg) { //后续代码会在最后一个节点时赋值NULL，所以这里代表实参太少
            yyerror("in CallUF: too few args in %s", sym->name);
            flag_noput = 1;
            free(oldval);
            free(newval);
            return 0;
        }
        if (arg->nodetype == NT_explist) { //检测是否还是树节点，如果是则计算左子树，不是则说明是最右侧的叶子节点，直接计算
            newval[i] = CalcVal(arg->l);printf("t 1\n");
            arg = arg->r;
        }
        else {printf("t 2\n");
            newval[i] = CalcVal(arg);
            arg = NULL;
        }
    }
    if (arg) { //最后一个会赋值NULL，不是NULL而且参数不少，则证明实参太多
        yyerror("in CallUF: too many args in %s", sym->name);
        flag_noput = 1;
        free(oldval);
        free(newval);
        return 0;
    }
    sl = sym->sl;
    for (i = 0; i < argc; i++) //保存形参的旧值并赋予实参值
    {
        oldval[i] = sl->sym->value;
        sl->sym->value = newval[i];
        sl = sl->next;
    }
    
    res = CalcVal(sym->ast); //计算函数体
    sl = sym->sl;
    for (i = 0; i < argc; i++)
    {
        sl->sym->value = oldval[i];
        sl = sl->next;
    }
    free(oldval);
    free(newval);
    return res;
}

double CalcVal(AST *ast)
{
    double res = 0;printf("nt1=%d\n", ast->nodetype);
    switch (ast->nodetype)
    {
        case NT_num:
            res = ((struct num_ast *)ast)->num;
            break;
        case '=': {
            struct asgn_ast *a = (struct asgn_ast *)ast;
            res = a->sym->value = CalcVal(a->ast);
            break;
        }
        case '+':
            res = CalcVal(ast->l)+CalcVal(ast->r);
            break;
        case '-':
            res = CalcVal(ast->l)-CalcVal(ast->r);
            break;
        case '*':
            res = CalcVal(ast->l)*CalcVal(ast->r);
            break;
        case '/':
            res = CalcVal(ast->l)/CalcVal(ast->r);
            break;
        case NT_minus:
            res = -CalcVal(ast->l);
            break;
        case NT_greater:
            res = CalcVal(ast->l) > CalcVal(ast->r);
            break;
        case NT_less:
            res = CalcVal(ast->l) < CalcVal(ast->r);
            break;
        case NT_equal:
            res = CalcVal(ast->l) == CalcVal(ast->r);
            break;
        case NT_greater_equal:
            res = CalcVal(ast->l) >= CalcVal(ast->r);
            break;
        case NT_less_equal:
            res = CalcVal(ast->l) <= CalcVal(ast->r);
            break;
        case NT_and:
            res = CalcVal(ast->l) && CalcVal(ast->r);
            break;
        case NT_or:
            res = CalcVal(ast->l) || CalcVal(ast->r);
            break;
        case NT_ref:
            res = ((struct ref_ast *)ast)->sym->value;
            break;
        case NT_bif:
            res = CallBIF((struct bif_ast *)ast);
            break;
        case NT_uf:
            res = CallUF((struct uf_ast *)ast);
            break;
        // case NT_explist: //explist专用于函数调用中，它的值直接在计算函数值的函数中被计算，这里永远不会用到
        case NT_stmtlist: {
            struct stmt_node *node = ((struct stmtlist_ast *)ast)->head;
            while (node) //循环计算所有节点
            {
                if (node->ast)
                    res = CalcVal(node->ast);
                node = node->next;
            }
            break;
        }
        case NT_if: {
            struct stmt_ast *sa = (struct stmt_ast *)ast;
            if (CalcVal(sa->cond)) { //条件成立则执行if语句，否则执行else语句
                if (sa->first)
                    res = CalcVal(sa->first);
                else
                    res = 0;
            }
            else {
                if (sa->second)
                    res = CalcVal(sa->second);
                else
                    res = 0;
            }
            break;
        }
        case NT_while: {
            struct stmt_ast *sa = (struct stmt_ast *)ast;
            if (sa->first) //执行块存在
                while (CalcVal(sa->cond))
                    res = CalcVal(sa->first);
            break;
        }
        default:
            yyerror("in CalcVal: invalid nodetype %d", ast->nodetype);
    }
    return res;
}

void TreeFree(AST *ast)
{
    if (!ast) {
        fputs("in TreeFree: NULL pointer", stderr);
        return;
    }printf("nt2=%d\n", ast->nodetype);
    switch (ast->nodetype)
    {
        case NT_num: //无释放
        case NT_ref:
            break;
        case '+': //释放左右节点
        case '-':
        case '*':
        case '/':
        case NT_greater:
        case NT_less:
        case NT_equal:
        case NT_greater_equal:
        case NT_less_equal:
        case NT_and:
        case NT_or:
        case NT_explist:
            TreeFree(ast->r);
        case NT_minus: //只释放左节点
            TreeFree(ast->l);
            break;
        case '=': //释放同名子树，注意这里不能直接写在一起，因为各个结构大小不同导致其中的ast字段的地址位置不同
            TreeFree(((struct asgn_ast *)ast)->ast);
            break;
        case NT_bif:
            TreeFree(((struct bif_ast *)ast)->ast);
            break;
        case NT_uf: {
            AST *a = ((struct uf_ast *)ast)->ast;
            if (a)
                TreeFree(a);
            break;
        }
        case NT_stmtlist: { //释放语句列表
            struct stmt_node *node = ((struct stmtlist_ast *)ast)->head, *temp;
            while (node) //循环释放直到空节点
            {
                if (node->ast) //释放语句节点
                    TreeFree(node->ast);
                temp = node;
                node = node->next;
                free(temp); //释放语句表节点本身
            }
            break;
        }
        case NT_if: //释放语句的3个节点，条件一定有，语句需要判空
        case NT_while: {
            struct stmt_ast *sa = (struct stmt_ast *)ast;
            TreeFree(sa->cond);
            if (sa->first)
                TreeFree(sa->first);
            if (sa->second)
                TreeFree(sa->second);
            break;
        }
        default:
            yyerror("in TreeFree: invalid nodetype %d", ast->nodetype);
    }
    free(ast); //最后释放自身
}

void ResProc(AST *ast)
{
    double res = CalcVal(ast);
    if (!flag_noput) //不输出标志为0则输出
        printf("= %lf\n", res);
    else
        flag_noput = 0;
    TreeFree(ast);
    printf("> ");
}

void yyerror(char *s, ...)
{
    va_list vl;
    va_start(vl, s);
    fprintf(stderr, "yyerror: %d: ", yylineno);
    vfprintf(stderr, s, vl);
    fputc('\n', stderr);
    va_end(vl);
}