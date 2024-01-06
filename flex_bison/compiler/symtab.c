#include "main.h"

struct symtab v_symtab, s_symtab, f_symtab; //分别为变量、结构类型、函数的符号表
struct symtab_stack tab_stack; //符号表栈

void SymtabInit(struct symtab *tab, int capacity, int type)
{
    tab->type = type;
    switch (tab->type) //不同符号表类型需要不同的内存分配格式，注意这里分配的符号表的内存应初始化为0，以便后续lookup里的判断式成立
    {
        case ST_var:
            tab->list = (SYMBOL *)calloc(capacity, sizeof(struct v_symbol));
            break;
        case ST_struct:
            tab->list = (SYMBOL *)calloc(capacity, sizeof(struct s_symbol));
            break;
        case ST_func:
            tab->list = (SYMBOL *)calloc(capacity, sizeof(struct f_symbol));
            break;
    }
    tab->size = 0;
    tab->capacity = capacity;
}

void SymtabExpansion(struct symtab *tab)
{
    struct symtab temp; //临时符号表，将原符号表转移到此表，而后删除原表并将临时表赋给原表
    if (tab->capacity < 1000) //根据容量决定扩容大小
        temp.capacity *= EXPANSION_TIMES;
    else
        temp.capacity += 1000;
    temp.size = tab->size;
    switch (tab->type) //不同符号表类型需要不同的类型格式
    {
        case ST_var: {
            temp.list = (SYMBOL *)malloc(temp.capacity*sizeof(struct v_symbol));
            struct v_symbol *sym;
            for (int i = 0; i < tab->size; i++) //将原表的符号依次转移到临时表
            {
                sym = SymtabLookup(&temp, tab->list[i].name, STLM_expansion);
                *sym = ((struct v_symbol *)(tab->list))[i];
            }
            break;
        }
        case ST_struct: {
            temp.list = (SYMBOL *)malloc(temp.capacity*sizeof(struct s_symbol));
            struct s_symbol *sym;
            for (int i = 0; i < tab->size; i++) //将原表的符号依次转移到临时表
            {
                sym = SymtabLookup(&temp, tab->list[i].name, STLM_expansion);
                *sym = ((struct s_symbol *)(tab->list))[i];
            }
            break;
        }
        case ST_func: {
            temp.list = (SYMBOL *)malloc(temp.capacity*sizeof(struct f_symbol));
            struct f_symbol *sym;
            for (int i = 0; i < tab->size; i++) //将原表的符号依次转移到临时表
            {
                sym = SymtabLookup(&temp, tab->list[i].name, STLM_expansion);
                *sym = ((struct f_symbol *)(tab->list))[i];
            }
            break;
        }
    }
    free(tab->list);
    *tab = temp;
}

SYMBOL *SymtabLookup(struct symtab *tab, char *name, int mode)
{
	unsigned hash = 0;
    char c;
    for (int i = 0; (c = name[i]) != '\0'; i++) //利用符号中的所有字符计算hash值
        hash = hash*10^c;
    hash %= tab->capacity;
    SYMBOL *sp = tab->list+hash, *tail = tab->list+tab->capacity;
    //查找tab，有多种模式。查找：找到就返回sp，有空位则返回NULL表示没找到。添加：找到就返回NULL表示无法添加，有空位就添加sp并返回。扩容：有空位就返回sp，没空位不动作(事实上不可能查找到对应符号，因为符号表中的符号是唯一的，但这里依旧判断一下模式标志)
    for (int i = 0; i < tab->capacity; i++)
    {
        if (!sp->name) { //有空位
            if (mode == STLM_search)
                return NULL;
            if (mode == STLM_add) {
                sp->name = name;
                tab->size++;
                if (tab->size == tab->capacity) { //添加符号后符号表已满，扩充容量
                    SymtabExpansion(tab);
                    DebugPrintf("symtab expansion\n", stderr);
                }
            }
            return sp;
        }
        else if (mode != STLM_expansion && !strcmp(sp->name, name)) { //找到了相同符号
            if (mode == STLM_search)
                return sp;
            if (mode == STLM_add)
                return NULL;
        }
        if (++sp == tail) //如果前进时超出数组末尾，则跳转到开头继续查找
            sp = tab->list;
    }
}

void SymtabStackInit(int capacity)
{
    tab_stack.stack = (struct symtab *)malloc(capacity*sizeof(struct symtab));
    tab_stack.size = 0;
    tab_stack.capacity = capacity;
    SymtabStackPush(100);
}

void SymtabStackPush(int capacity)
{
    if (tab_stack.size == tab_stack.capacity) {
        if (tab_stack.capacity < 100)
            tab_stack.capacity *= EXPANSION_TIMES;
        else
            tab_stack.capacity += 100;
        tab_stack.stack = (struct symtab *)realloc(tab_stack.stack, tab_stack.capacity*sizeof(struct symtab));
    }
    SymtabInit(tab_stack.stack+tab_stack.size-1, capacity, ST_var);
    tab_stack.size++;
}

void SymtabStackPop()
{
    if (tab_stack.size == 1)
        ErrorPrintf("in SymtabStackRemove: can't pop global variable");
    free(tab_stack.stack[tab_stack.size-1].list);
    tab_stack.size--;
}

SYMBOL *SymtabStackLookup(char *name, int mode, int *level)
{
    SYMBOL *sym;
    switch (mode) //分情况讨论
    {
        case STLM_search:
            for (int i = tab_stack.size-1; i >= 0; i--)
            {
                sym = SymtabLookup(tab_stack.stack+i, name, mode);
                if (sym) {
                    if (level)
                        *level = i;
                    break;
                }
            }
            break;
        case STLM_add:
            sym = SymtabLookup(tab_stack.stack+tab_stack.size-1, name, mode);
            break;
        case STLM_expansion:
            ErrorPrintf("can't use STLM_expansion");
            exit(-1);
        default:
            ErrorPrintf("invalid symtab_lookup_mode");
            exit(-1);
    }
    return sym;
}

void VarSymbolInit(struct v_symbol *sym, struct var_decl_head_s *head, struct var_def_node *def)
{
    sym->type.constflag = head->constflag;
    sym->type.bt = head->bt;
    sym->type.sname = head->sname;
    sym->type.append = def->append;
    sym->type.arr = def->arr;
}

void StructSymbolInit(struct s_symbol *sym, struct var_uninit_decl_node *decl)
{

}

void FuncSymbolInit(struct f_symbol *sym, struct func_def_ast *def)
{
    sym->type = def->type;
    sym->args = def->args;
}
