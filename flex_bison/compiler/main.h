#include "h.h"
#include <stdarg.h> //多参数函数所需头文件

#define EXPANSION_TIMES 2 /* 各种变长数组表添加元素时可能需要使用到的扩容倍数 */
enum symtab_type { //符号表类型
    ST_var, //变量符号表
    ST_struct, //结构类型符号表
    ST_func //函数符号表
};
enum symtab_lookup_mode { //符号表查询模式，用于SymtabLookup函数
    STLM_search, //查找模式
    STLM_add, //添加模式
    STLM_expansion //扩展模式，专用与SymtabExpansion函数
};

typedef struct symbol { //符号，包含符号名称、符号值、函数参数、函数体，(其中后两者仅用于函数符号)
    char *name;
    double value;
    struct symlist *sl;
    struct ast *ast;
} SYMBOL;
struct v_symbol { //变量符号
    char *name; //变量名
    struct type_s type; //变量类型，注意这不是指针
};
struct s_symbol { //结构类型符号
    char *name; //结构名
    struct var_uninit_decl_list *list; //无定义变量声明列表
};
struct f_symbol { //函数符号
    char *name; //函数名
    struct type_s *type; //函数返回值类型
    struct func_head_arg_list *args; //参数列表
};
typedef struct symlist { //符号列表，可作为函数参数，包含本节点符号和下一个符号的指针
    struct symbol *sym;
    struct symlist *next;
} SYMLIST;
struct symtab { //泛型符号表，可储存任一符号类型中的一种符号
    int type; //符号表类型
    SYMBOL *list; //符号表
    int size; //符号个数
    int capacity; //符号表容量
};
struct symtab_stack{ //符号表栈
    struct symtab *stack;
    int size;
    int capacity;
};

extern struct symtab v_symtab, s_symtab, f_symtab; //分别为变量、结构类型、函数的符号表
extern int block_level = 0; //块的层数，用于作用域分析
extern FILE *irfile; //IR存放的文件

void DebugPrintf(char *s, ...);

void SymtabInit(struct symtab *tab, int capacity, int type);
void SymtabExpansion(struct symtab *tab);
SYMBOL *SymtabLookup(struct symtab *tab, char *name, int mode);
SYMBOL *SymtabStackLookup(char *name, int mode, int *level);

void GlobalVarInit();