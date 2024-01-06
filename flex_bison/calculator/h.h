#ifndef H_H
#define H_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylineno; //给flex以外的文件使用
void yyrestart (FILE *input_file); //供CallUF使用
void yyerror(char *s, ...); //多参数的error报告
int yylex();
int yyparse();

typedef struct symbol { //符号，包含符号名称、符号值、函数参数、函数体，(其中后两者仅用于函数符号)
    char *name;
    double value;
    struct symlist *sl;
    struct ast *ast;
} SYMBOL;
typedef struct symlist { //符号列表，可作为函数参数，包含本节点符号和下一个符号的指针
    struct symbol *sym;
    struct symlist *next;
} SYMLIST;
#define NSYMBOL 1000 //符号表的长度，符号表定义
extern SYMBOL symtab[NSYMBOL];

enum build_in_func { //内置函数的标志
    BIF_abs, //绝对值
    BIF_sqrt, //开根
    BIF_exp, //e的x次方
    BIF_log, //e为底的对数
    BIF_print //打印值并返回值
};
enum node_type { //ast节点的类型标志
    NT_num = 256, //数字
    NT_minus, //单目负号
    NT_greater, //大于
    NT_less, //小于
    NT_equal, //等于
    NT_greater_equal, //大于等于
    NT_less_equal, //小于等于
    NT_and, //逻辑与
    NT_or, //逻辑或
    NT_explist, //表达式列表
    NT_stmtlist, //语句列表
    NT_if, //if
    NT_while, //while
    NT_ref, //符号引用
    NT_bif, //内置函数
    NT_uf //用户函数
};

typedef struct ast { //基本的抽象语法树节点
    int nodetype; //节点类型，可以是字符量或node_type
    struct ast *l, *r; //左右子节点
} AST;
struct num_ast { //数字节点
    int nodetype; //NT_num
    double num; //数字的数值
};
struct ref_ast { //引用节点
    int nodetype; //NT_ref
    SYMBOL *sym; //引用符号
};
struct asgn_ast { //赋值节点
    int nodetype; //'='
    SYMBOL *sym; //被赋值的符号
    AST *ast; //赋值的表达式
};
struct bif_ast { //内置函数节点
    int nodetype; //NT_bif
    enum build_in_func functype; //内置函数类型
    AST *ast; //函数的实参，可以是表达式
};
struct uf_ast { //用户自定义函数节点
    int nodetype; //NT_uf
    SYMBOL *sym; //函数符号
    AST *ast; //函数的实参
};
struct stmt_ast { //语句节点，用于if、while
    int nodetype; //NT_if、NT_while
    AST *cond; //条件表达式
    AST *first; //第一执行块
    AST *second; //else执行块
};
struct stmt_node { //专用于语句列表的语句表节点
    AST *ast; //此节点代表的语句节点
    struct stmt_node *next; //下一节点
};
struct stmtlist_ast { //语句列表
    int nodetype; //NT_stmtlist
    struct stmt_node *head, *tail; //头尾节点
};

SYMBOL *Lookup(char *name); //根据name计算后的hash值查找或添加name对应的symtab元素
AST *NewAst(int nodetype, AST *l, AST *r); //创建各种新节点
AST *NewNum(double num);
AST *NewRef(SYMBOL *sym);
AST *NewAsgn(SYMBOL *sym, AST *ast);
AST *NewBIF(enum build_in_func functype, AST *ast);
AST *NewUF(SYMBOL *sym, AST *ast);
AST *NewStmt(int nodetype, AST *cond, AST *first, AST *second);
SYMLIST *NewSymList(SYMBOL *sym, SYMLIST *next); //创建新的参数列表节点
void FreeSymList(SYMLIST *sl); //释放整个参数列表
AST *NewStmtList(AST *ast); //创建语句列表和第一个语句表节点
void NewStmtNode(struct stmtlist_ast *sa, AST *ast); //创建语句表节点
double CallBIF(struct bif_ast *ast); //调用内置函数
void FuncDef(SYMBOL *sym, SYMLIST *sl, AST *block); //定义函数
double CallUF(struct uf_ast *ast); //调用用户自定义函数
double CalcVal(AST *ast); //计算ast的值
void TreeFree(AST *ast); //销毁ast
void ResProc(AST *ast); //起始符号中调用的总结果处理函数

#endif //H_H