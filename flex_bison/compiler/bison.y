%{
#include "h.h"
%}

%parse-param { AST *ast }

%union {
    int intval; //任意整形数据和枚举
    double doubleval; //浮点数
    AST *ast; //非终结符
    char *name; //符号
    /* 建立AST所需的结构体 */
    struct type_s *type_s;
    struct append_type_s *append_type_s;
    struct array_type_s *array_type_s;
    struct var_decl_head_s *var_decl_head_s;
    struct var_def_list *var_def_list;
    struct var_def_node *var_def_node;
    struct struct_def_s *struct_def_s;
    struct var_uninit_decl_list *var_uninit_decl_list;
    struct func_head_arg_list *func_head_arg_list;
}

%token <intval> INT_NUM //整形字面量
%token <doubleval> DOUBLE_NUM //浮点型字面量
%token <name> IDENT //标识符
%token <intval> TYPE_KEY BIF CMP LOGIC //基础类型关键字、内置函数、比较运算符、逻辑运算符
%token STRUCT CONST
%token IF ELSE WHILE
%token RETURN //退出关键字
%token EOL

/* 总程序和基本组件，同组类符号放在一起 */
%type <ast> Program CompUnit
/* 通用类型、附加类型(const和指针)、数组后缀、变量声明头 */
%type <type_s> Type
    <append_type_s> AppendType
    <array_type_s> ArrayType
    <var_decl_head_s> VarDeclHead
/* 变量声明、无初始化声明、变量定义、初始化定义、无初始化定义、定义列表、无初始化定义列表、结构定义、无初始化声明列表 */
%type <ast> VarDecl VarUninitDecl
    <var_def_list> VarDefList VarUninitDefList
    <var_def_node> VarDef VarInitDef VarUninitDef
    <struct_def_s> StructDef
    <var_uninit_decl_list> VarUninitDeclList
/* 函数声明和定义中使用的参数列表 */
%type <ast> FuncDecl FuncDef
    <func_head_arg_list> FuncHeadArgList FuncDefArg
/* 分别为表达式、表达式列表、块、语句、语句列表、块内语句、块内语句列表 */
%type <ast> Exp AsgnExp ExpList Block Stmt StmtList

%start Program //标志此符号为起始符号，使其无需放在最前面

%nonassoc PREC_IF //设置ELSE的移进优先于PREC_IF的规约可以解决if-if-else组合的移进-规约冲突，使其总是优先移进ELSE
%nonassoc ELSE
%nonassoc LOGIC //由于数据类型为浮点，所以不提供位运算'&' '|' '~' '^' //逻辑运算符、与、或、非、异或
%nonassoc CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc PREC_MINUS //单独设置此符号为最高优先级，后续用于标识单目负号语法匹配的优先级

%%
/* 总程序 */
Program:
    | Program StmtList EOL { printf("calclist stmtlist EOL\n");ResProc($2); }
    | Program error EOL { /* 错误处理，无法匹配时丢弃符号，直到能够匹配到error后面的匹配EOL，这使得bison不会直接退出 */
        yyerrok; //ok可以使bison停止这次错误处理，如果不停止，后续的错误将不会有错误信息，直到遇见正确匹配
        printf("> ");
    }
    | Program CompUnit { ast = $2; }
    ;
CompUnit: { $$ = NewCompUnitList(100); }
    | CompUnit VarDecl { NewCompUnitNode($1, $2); }
    | CompUnit FuncDecl { NewCompUnitNode($1, $2); }
    | CompUnit FuncDef { NewCompUnitNode($1, $2); }
    | CompUnit ';'
    ; /* 组成单元，有变量声明、函数声明、函数定义 */

/* 类型，类型之间存在组合关系，且各种类型的适用范围不同 */
Type: TYPE_KEY AppendType ArrayType { $$ = NewType($1, NULL, $2, $3); }
    | STRUCT IDENT AppendType ArrayType { $$ = NewType(0, $2, $3, $4); }
    | CONST Type { $$ = AddConstType1($2); }
    ; /* 通用类型，用于函数头、类型转换。将const单独提出是为了让最开头的多个const合法化 */
AppendType: { $$ = NULL; }
    | AppendType CONST { NewAppendType($1, 'c'); }
    | AppendType '*' { NewAppendType($1, '*'); }
    ; /* 附加类型必须组合于其它类型中或变量中，包含const和指针，但并非解引用 */
ArrayType: { $$ = NULL; }
    | ArrayType '[' Exp ']' { NewArrayType($1, $3); }
    ; /* 数组类型必须组合于其它类型中或变量中 */
VarDeclHead: TYPE_KEY { $$ = NewDeclHead($1, NULL, NULL); }
    | STRUCT IDENT { $$ = NewDeclHead(0, $2, NULL); }
    | StructDef { $$ = NewDeclHead(0, NULL, $1); }
    | CONST VarDeclHead { $$ = AddConstType2($2); }
    ; /* 声明头专用于变量声明，为方便一个声明中可包含多个定义，这里单独将声明头类型分离出来 */

/* 变量声明，包含结构、定义、初始化 */
VarDecl: VarDeclHead ';' { $$ = NewVarDecl($1, NULL); }
    | VarDeclHead VarDefList ';' { $$ = NewVarDecl($1, $2); }
    ; /* 通用变量声明，包含所有 */
VarUninitDecl: VarDeclHead ';' { $$ = NewVarDecl($1, NULL); }
    | VarDeclHead VarUninitDefList ';' { $$ = NewVarDecl($1, $2); }
    ; /* 无初始化的变量声明专用于结构体定义中 */
VarDefList: VarDef { $$ = NewVarDefList($1); }
    | VarDefList ',' VarDef { NewVarDefNode($1, $3); }
    ; /* 通用定义列表 */
VarUninitDefList: VarUninitDef { $$ = NewVarDefList($1); }
    | VarUninitDefList ',' VarUninitDef { NewVarDefNode($1, $3); }
    ; /* 无初始化定义列表，存在于无初始化声明中 */
VarDef: VarUninitDef
    | VarInitDef
    ; /* 整合为通用定义 */
VarInitDef: AppendType IDENT ArrayType '=' Exp { $$ = NewVarDef($1, $2, $3, $5); }
    | AppendType IDENT ArrayType '=' '{' ExpList '}' { $$ = NewVarDef($1, $2, $3, $6); }
    ; /* 由于数组可以为空，所以第一条规则无法去掉数组(语义上不允许非初始化列表来初始化数组) */
VarUninitDef: AppendType IDENT ArrayType { $$ = NewVarDef($1, $2, $3, NULL); }
    ; /* 单独提出两种定义是为了区分是否初始化，在结构定义中只使用无初始化定义 */
StructDef: STRUCT IDENT '{' VarUninitDeclList '}' { $$ = NewStructDef($2, $4); }
    | STRUCT '{' VarUninitDeclList '}' { $$ = NewStructDef(NULL, $3); }
    ; /* 结构定义直接被归纳为变量声明头，这样在声明变量的地方都能定义结构，且结构变量声明的格式和普通变量声明一致 */
VarUninitDeclList: VarUninitDecl { $$ = NewVarUninitDeclList($1); }
    | VarUninitDeclList VarUninitDecl { NewVarUninitDeclNode($1, $2); }
    ; /* 专用于结构定义中的无初始化声明列表 */

/* 函数声明与定义 */
FuncDecl: Type IDENT '(' ')' ';' { $$ = NewFuncDecl($1, $2, NULL); }
    | Type IDENT '(' FuncHeadArgList ')' ';' { $$ = NewFuncDec;($1, $2, $4); }
    ; 
FuncDef: Type IDENT '(' ')' Block { $$ = NewFuncDef($1, $2, NULL, $5); }
    | Type IDENT '(' FuncHeadArgList ')' Block { $$ = NewFuncDef($1, $2, $4, $6); }
    ; /* Block虽然可以为空，但它的规则中一定有一对大括号，所以这里不会与声明规则冲突 */
FuncHeadArgList: Type { $$ = NewFuncHeadArgList($1, NULL, NULL, NULL); }
    | FuncDefArg
    | Type ',' FuncHeadArgList { $$ = NewFuncHeadArgList($1, NULL, NULL, $3); }
    | FuncDefArg ',' FuncHeadArgList { $$ = NewFuncHeadArgList(NULL, $1, NULL, $3); }
    ; /* 1、3条无名参数规则和2、4条有名参数规则对于函数的声明和定义都可用 */
FuncDefArg: TYPE_KEY AppendType IDENT ArrayType { $$ = NewFuncHeadArgList(NewType($1, NULL, $2, $4), NULL, $3, NULL); }
    | STRUCT IDENT AppendType IDENT ArrayType { $$ = NewFuncHeadArgList(NewType(NULL, $2, $3, $5), NULL, $4, NULL); }
    | CONST FuncDefArg { $$ = AddConstType3($2); }
    ; /* 专用于函数定义中的有名参数，与通用类型的唯一区别是添加了参数的标识符 */

/* 块和语句 */
Block: '{' '}' { $$ = NewBlock(NULL); }
    | '{' StmtList '}' { $$ = NewBlock($2); }
    ;
StmtList: Stmt { printf("stmt\n");$$ = NewStmtList($1); }
    | StmtList Stmt { printf("stmtlist\n");NewStmtNode($1, $2); }
    ; /* 语句列表和参数列表、符号列表有所不同，它可以很长，所以无法使用右递归(会爆栈)，而如果直接使用AST的左递归，则需要在后续使用时倒置树序进而影响运行时长，此处采用链表储存语句节点 */
Stmt: Exp ';'
    | AsgnExp ';'
    | ';' { $$ = NULL; }
    | IF '(' Exp ')' Stmt %prec PREC_IF { printf("IF\n");$$ = NewStmt(NT_if, $3, $5, NULL); }
    | IF '(' Exp ')' Stmt ELSE Stmt { printf("IF ELSE\n");$$ = NewStmt(NT_if, $3, $5, $7); }
    | WHILE '(' Exp ')' Stmt { printf("WHILE\n");$$ = NewStmt(NT_while, $3, $5, NULL); }
    | Block
    | RETURN Exp ';' { $$ = NewReturn($2); }
    | VarDecl
    | FuncDecl
    ;

/* 表达式 */
Exp: INT_NUM { $$ = NewNum(NT_int_num, $1, 0); }
    | DOUBLE_NUM { $$ = NewNum(NT_double_num, 0, $1); }
    | Exp '+' Exp { $$ = NewAst('+', $1, $3); }
    | Exp '-' Exp { $$ = NewAst('-', $1, $3); }
    | Exp '*' Exp { $$ = NewAst('*', $1, $3); }
    | Exp '/' Exp { $$ = NewAst('/', $1, $3); }
    | Exp CMP Exp { $$ = NewAst($2, $1, $3); }
    | Exp LOGIC Exp { $$ = NewAst($2, $1, $3); }
    | '-' Exp %prec PREC_MINUS { $$ = NewAst(NT_minus, $2, NULL); /* 单目负号 */}
    | '(' Exp ')' { $$ = $2; printf("'(' exp ')'\n");}
    | '(' AsgnExp ')' { $$ = $2; printf("'(' exp_asgn ')'\n");}
    | IDENT { $$ = NewRef($1); }
    | BIF '(' Exp ')' { $$ = NewBIF($1, $3); }
    | IDENT '(' ')' { $$ = NewUF($1, NULL); /* 无参函数调用，由于explist采用右递归，无法添加空规则，所以只能在此处添加 */}
    | IDENT '(' ExpList ')' { $$ = NewUF($1, $3); }
    ;
AsgnExp: IDENT '=' Exp { $$ = NewAsgnExp($1, $3); }
    | IDENT '=' AsgnExp { $$ = NewAsgnExp($1, $3); }
    ; /* 单独列出赋值表达式是为了独立出它，除非使用括号括起赋值表达式，否则无法将其用于其它表达式中，第二个匹配提供了连续赋值 */
ExpList: Exp
    | Exp ',' ExpList { $$ = NewAst(NT_exp_list, $1, $3); }
    ;
%%
