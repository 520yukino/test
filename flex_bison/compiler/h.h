#ifndef H_H
#define H_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

extern FILE *yyin;
int yylex();
int yyparse(AST *ast);

enum build_in_func { //内置函数的标志
    BIF_abs, //绝对值
    BIF_sqrt, //开根
    BIF_exp, //e的x次方
    BIF_log, //e为底的对数
    BIF_print //打印值并返回值
};
enum node_type { //ast节点的类型标志
    NT_minus = 256, //单目负号
    NT_greater, //大于
    NT_less, //小于
    NT_equal, //等于
    NT_greater_equal, //大于等于
    NT_less_equal, //小于等于
    NT_and, //逻辑与
    NT_or, //逻辑或
    NT_exp_list, //表达式列表
    NT_if, //if
    NT_while, //while
    NT_ref, //符号引用
    NT_bif, //内置函数
    NT_uf, //用户函数

    NT_comp_unit_list, //程序单元列表
    NT_var_decl, //变量声明，包含了定义
    NT_func_decl, //函数声明
    NT_func_def, //函数定义
    NT_block, //块
    NT_return, //返回语句
    NT_int_num, //整形数据
    NT_double_num //浮点数据
};
enum base_type { //变量类型
    VT_void,
    VT_char,
    VT_short,
    VT_int,
    VT_long,
    VT_longlong,
    VT_float,
    VT_double,
    VT_longdouble
};

typedef struct ast { //基本的抽象语法树节点
    int nodetype; //节点类型，可以是字符量或枚举
    struct ast *l, *r; //左右子节点
} AST;
struct ref_ast { //引用节点
    int nodetype; //NT_ref
    char *sym; //引用符号
};
struct asgn_ast { //赋值节点
    int nodetype; //'='
    char *sym; //被赋值的符号
    AST *ast; //赋值的表达式
};
struct bif_ast { //内置函数节点
    int nodetype; //NT_bif
    enum build_in_func functype; //内置函数类型
    AST *ast; //函数的实参，可以是表达式
};
struct uf_ast { //用户自定义函数节点
    int nodetype; //NT_uf
    char *sym; //函数符号
    AST *ast; //函数的实参
};
struct stmt_ast { //语句节点，用于if、while
    int nodetype; //NT_if、NT_while
    AST *cond; //条件表达式
    AST *first; //第一执行块
    AST *second; //else执行块
};

/* 总程序节点 */
struct comp_unit_list_ast { //程序的基本组成单元列表
    int nodetype; //NT_comp_unit_list
    struct comp_unit_node *list; //单元数组
    int size; //节点数量
    int capacity; //数组容量
};
struct comp_unit_node { //程序的基本组成单元，包含变量声明、函数声明和定义
    AST *unit; //组成单元
};

/* 各种类型节点，类型之间可能存在包含关系 */
struct type_s { //通用类型
    bool constflag; //是否为const，仅标识裸类型，const指针在附加类型中
    enum base_type bt; //基础类型
    char *sname; //结构类型
    struct append_type_s *append; //附加类型
    struct array_type_s *arr; //数组
};
struct append_type_s { //附加类型，有const、指针
    int ptrlevel; //指针层数，即多重指针
    bool *constflags; //const标识，采用动态内存，记录类型自身及其各层级指针的const标识
};
struct array_type_s { //数组信息，存在于变量定义、函数头、数组调用中，由于数组写在标识符后面，所以不能与其它类型相提并论
    int level; //层级
    int *nums; //各层级的元素个数
};
struct var_decl_head_s { //专用于变量声明中开头的无附件类型，可以有const，可以是基础类型、结构类型、结构定义
    bool constflag; //是否为const变量，此标志不同于附加类型中的const指针，它通用于整个类型或声明
    enum base_type bt; //基础类型
    char *sname; //结构类型
    struct struct_def_s *def; //结构定义，包含结构定义和结构变量声明头
};

/* 变量声明和结构体定义，基础变量和结构体变量均可声明。结构体需要单独定义，且内部需要无定义声明，声明中可有多个变量定义，它们共用声明头类型，自身可单独定义附加类型和数组 */
struct var_decl_ast { //变量声明，包含了变量定义链表
    int nodetype; //NT_var_decl
    struct var_decl_head_s *head; //声明头的类型
    struct var_def_list *list; //变量定义表
};
struct var_def_list { //变量定义表
    struct var_def_node *head, *tail; //变量定义的头尾指针，可以连续定义，使其成为定义链表
};
struct var_def_node { //变量定义，可以连接为连续定义的链表，其中只有符号字段是必须存在的
    struct append_type_s *append; //附加类型
    char *name; //所定义变量的符号
    struct array_type_s *arr; //数组
    AST *exp; //初始化表达式
    struct var_def_node *next; //下一个定义
};
struct struct_def_s { //结构定义，两个字段都可为空。被包含在声明头中作为声明的一部分
    char *sname; //结构名称
    struct var_uninit_decl_list *list; //无定义变量声明列表
};
struct var_uninit_decl_list { //专用于结构定义中的无定义变量声明列表
    struct var_uninit_decl_node *head, *tail; //声明节点的头尾指针
};
struct var_uninit_decl_node { //无定义变量声明节点，无定义和有定义的变量声明都使用同一结构
    struct var_decl_ast *decl; //变量声明
    struct var_uninit_decl_node *next; //下一个节点
};

/* 函数声明和定义中使用的参数列表 */
struct func_decl_ast { //函数声明
    int nodetype; //NT_func_decl
    struct type_s *type; //函数返回值类型
    char *fname; //函数名
    struct func_head_arg_list *args; //参数列表
};
struct func_def_ast { //函数定义
    int nodetype; //NT_func_def
    struct type_s *type; //函数返回值类型
    char *fname; //函数名
    struct func_head_arg_list *args; //参数列表
    struct block_ast *block; //块
};
struct func_head_arg_list { //函数头中的参数列表，bison中为右递归。此参数列表包含参数名称，通用于函数声明和定义
    struct type_s *type; //参数类型
    char *name; //参数名称
    struct func_head_arg_list *next; //下一参数
};

/* 块和语句 */
struct block_ast { //块
    int nodetype; //NT_block
    struct stmt_list *list; //语句列表
};
struct stmt_list { //语句列表
    struct stmt_node *head, *tail; //头尾节点
};
struct stmt_node { //专用于语句列表的语句表节点
    AST *ast; //此节点代表的语句节点
    struct stmt_node *next; //下一节点
};
struct ret_stmt_ast { //return语句
    int nodetype; //NT_return
    AST *exp; //返回语句中的表达式
};

/* 各种表达式 */
struct num_ast { //数字字面量节点
    int nodetype; //NT_xxx_num
    union { //具体数值
        int intnum;
        double doublenum;
    };
};

//多参数的error报告
void ErrorPrintf(char *s, ...);

/* 总程序 */
//创建组成单元列表
AST *NewCompUnitList(int capacity);
//创建组成单元并添加到列表
void NewCompUnitNode(struct comp_unit_list_ast *list, AST *unit);

/* 类型 */
//创建通用类型
struct type_s *NewType(int type, char *sname, struct append_type_s *append, struct array_type_s *arr);
//创建附加类型(const、指针)，或者在已有节点上添加附加类型信息
void NewAppendType(struct append_type_s *append, int ch);
//创建数组后缀，或者在已有节点上更新数组
void NewArrayType(struct array_type_s *arr, AST *exp);
//创建变量声明头
struct var_decl_head_s *NewDeclHead(int type, char *sname, struct struct_def_s *def);
//对类型添加const(专用于写在类型前面的const)，有多个版本，用于修改不同结构中的constflag字段
struct type_s *AddConstType1(struct type_s *type);
struct type_s *AddConstType2(struct var_decl_head_s *type);
struct type_s *AddConstType3(struct func_head_arg_list *type);

/* 变量声明 */
//创建变量声明
AST *NewVarDecl(struct var_decl_head_s *head, struct var_def_list *list);
//创建定义列表并添加第一个定义节点
struct var_def_list *NewVarDefList(struct var_def_node *def);
//创建定义节点并添加到列表
void NewVarDefNode(AST *list, struct var_def_node *def);
//创建变量定义
struct var_def_node *NewVarDef(struct append_type_s *append, char *name, struct array_type_s *arr, AST *exp);
//创建结构定义
struct struct_def_s *NewStructDef(char *sname, struct var_uninit_decl_list *list);
//创建无初始化变量声明列表
struct var_uninit_decl_list *NewVarUninitDeclList(AST *decl);
//创建无初始化变量声明节点并添加到列表
void NewVarUninitDeclNode(struct var_uninit_decl_list *list, AST *decl);

/* 函数 */
//创建函数声明节点
AST *NewFuncDecl(struct type_s *type, char *fname, struct func_head_arg_list *list);
//创建函数定义节点
AST *NewFuncDef(struct type_s *type, char *fname, struct func_head_arg_list *list, AST *block);
//创建函数头参数列表节点，节点自成链表
struct func_head_arg_list *NewFuncHeadArgList(struct type_s *type, struct func_head_arg_list *arg, char *name, struct func_head_arg_list *list);

/* 块和语句 */
//创建块节点
AST *NewBlock(AST *list);
//创建语句列表和第一个语句表节点
AST *NewStmtList(AST *stmt);
//创建语句表节点
void NewStmtNode(struct stmt_list *list, AST *stmt);
//创建return语句
AST *NewReturn(AST *exp);

/* 表达式 */
//创建原始ast节点，普通二叉树
AST *NewAst(int nodetype, AST *l, AST *r);
//创建数字字面量节点
AST *NewNum(int nodetype, int intnum, double doublenum);
AST *NewRef(char *sym);
//创建赋值表达式
AST *NewAsgnExp(char *sym, AST *ast);
AST *NewBIF(enum build_in_func functype, AST *ast);
AST *NewUF(char *sym, AST *ast);
AST *NewStmt(int nodetype, AST *cond, AST *first, AST *second);


//创建新的参数列表节点
SYMLIST *NewSymList(char *sym, SYMLIST *next);
//释放整个参数列表
void FreeSymList(SYMLIST *sl);

//调用内置函数
double CallBIF(struct bif_ast *ast);
//定义函数
void FuncDef(char *sym, SYMLIST *sl, AST *block);
//调用用户自定义函数
double CallUF(struct uf_ast *ast);
//计算ast的值
double CalcVal(AST *ast);
//销毁ast
void TreeFree(AST *ast);
//起始符号中调用的总结果处理函数
void ResProc(AST *ast);

#endif //H_H