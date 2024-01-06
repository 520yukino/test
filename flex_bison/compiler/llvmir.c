#include "main.h"

/* LLVM IR生成函数集 */
int LLVMIR(AST *ast)
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
                IRGlobalVarDecl((struct var_decl_ast *)unit);
                break;
            case NT_func_decl:
                IRFuncDecl((struct func_decl_ast *)unit);
                break;
            case NT_func_def:
                IRFuncDef((struct func_def_ast *)unit);
                break;
            default:
                break;
        }
    }
}

void IRGlobalVarDecl(struct var_decl_ast *decl)
{
    struct v_symbol *sym;
    for (struct var_def_node *def = decl->list->head; !def; def = def->next)
    {
        sym = (struct v_symbol *)SymtabStackLookup(def->name, STLM_search, NULL);
        fprintf(irfile, "@%s =", sym->name);
        IRGlobalVarPrefix(&sym->type);
        IRTypeStr(&sym->type);
        IRVarInitStr(def->exp);
    }
}

void IRGlobalVarPrefix(struct type_s *type)
{
    if (type->constflag)
        fputs(" constant", irfile);
    else
        fputs(" global", irfile);
}

void IRTypeStr(struct type_s *type)
{

}