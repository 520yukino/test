#include "main.h"

/* 总语义检查函数 */
void CheckProgram(AST *ast)
{
    if (ast->nodetype != NT_comp_unit_list) {
        ErrorPrintf("in LLVMIR: invalid nodetype %d", ast->nodetype);
        exit(-1);
    }
    struct comp_unit_list_ast *list = (struct comp_unit_list_ast *)ast;
    AST *unit;
    for (int i = 0; i < list->size; i++)
    {
        unit = list->list[i].unit;
        switch (unit->nodetype)
        {
            case NT_var_decl:
                CheckGlobalVarDecl((struct var_decl_ast *)unit);
                break;
            case NT_func_decl:
                CheckFuncDecl((struct func_decl_ast *)unit);
                break;
            case NT_func_def:
                CheckFuncDef((struct func_def_ast *)unit);
                break;
            default:
                break;
        }
    }
}

/* 全局变量 */
void CheckGlobalVarDecl(struct var_decl_ast *decl)
{
    struct v_symbol *sym;
    struct type_s *type;
    for (struct var_def_node *def = decl->list->head; !def; def = def->next)
    {
        sym = (struct v_symbol *)SymtabStackLookup(def->name, STLM_add, NULL);
        VarSymbolInit(sym, decl->head, def);
        if (decl->head->def) //声明头只需检查结构定义
            CheckStructDef(decl->head->def);
        CheckVarDef(def);
    }
}

/* 函数声明 */
void CheckFuncDecl(struct func_decl_ast *decl)
{

}

/* 函数定义 */
void CheckFuncDef(struct func_def_ast *def)
{
    struct f_symbol *sym;
    sym = (struct f_symbol *)SymtabLookup(&f_symtab, def->fname, STLM_add);
    FuncSymbolInit(sym, def);
    CheckType(def->type);
    CheckFuncHeadArgList(def->args);
}

/* 结构体定义 */
void CheckStructDef(struct struct_def_s *def)
{

}

/* 变量定义 */
void CheckVarDef(struct var_def_node *def)
{

}

/* 函数头参数列表 */
void CheckFuncHeadArgList(struct func_head_arg_list *list)
{
    while (list)
    {
        CheckType(list->type);
        list = list->next;
    }
}

void CheckType(struct type_s *type)
{
    CheckAppendType(type->append);
    CheckArrayType(type->arr);
}

void CheckAppendType(struct append_type_s *append)
{
    if (append->constflags[0] == true)
        CheckError("const can only limit pointers rather than variables in its definition");
}

void CheckArrayType(struct array_type_s *arr)
{
    
}

void CheckError(char *s, ...)
{
    va_list vl;
    va_start(vl, s);
    fputs("error: ", stderr);
    vfprintf(stderr, s, vl);
    fputc('\n', stderr);
    va_end(vl);
}