%{
#include "h.h"
int yylex();
%}

%union {
    int intval; //任意整形数据和枚举
    double data; //计算数据
    AST *ast; //非终结符
    SYMBOL *sym; //符号
    SYMLIST *sl; //符号列表
}

%token <data> NUMBER //计算数据
%token <sym> NAME //变量和函数
%token <intval> BIF CMP LOGIC //内置函数、比较运算符、逻辑运算符
%token IF ELSE WHILE LET //let是函数定义标志
%token EOL
%type <ast> calclist exp exp_asgn explist block stmt stmtlist stmt_block stmtlist_block//分别为总算式、表达式、表达式列表、块、语句、语句列表、块内语句、块内语句列表
%type <sl> symlist //符号列表
%start calclist //标志此符号为起始符号，使其无需放在最前面

%nonassoc PREC_IF //设置ELSE的移进优先于PREC_IF的规约可以解决if-if-else组合的移进-规约冲突，使其总是优先移进ELSE
%nonassoc ELSE
%nonassoc LOGIC //由于数据类型为浮点，所以不提供位运算'&' '|' '~' '^' //逻辑运算符、与、或、非、异或
%nonassoc CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc PREC_MINUS //单独设置此符号为最高优先级，后续用于标识单目负号语法匹配的优先级

%%
exp: NUMBER { $$ = NewNum($1); }
    | exp '+' exp { $$ = NewAst('+', $1, $3); }
    | exp '-' exp { $$ = NewAst('-', $1, $3); }
    | exp '*' exp { $$ = NewAst('*', $1, $3); }
    | exp '/' exp { $$ = NewAst('/', $1, $3); }
    | exp CMP exp { $$ = NewAst($2, $1, $3); }
    | exp LOGIC exp { $$ = NewAst($2, $1, $3); }
    | '-' exp %prec PREC_MINUS { $$ = NewAst(NT_minus, $2, NULL); /* 单目负号 */}
    | '(' exp ')' { $$ = $2; printf("'(' exp ')'\n");}
    | '(' exp_asgn ')' { $$ = $2; printf("'(' exp_asgn ')'\n");}
    | NAME { $$ = NewRef($1); }
    | BIF '(' exp ')' { $$ = NewBIF($1, $3); }
    | NAME '(' ')' { $$ = NewUF($1, NULL); /* 无参函数调用，由于explist采用右递归，无法添加空规则，所以只能在此处添加 */}
    | NAME '(' explist ')' { $$ = NewUF($1, $3); }
    ;
/* 单独列出赋值表达式是为了独立出它，除非使用括号括起赋值表达式，否则无法将其用于其它表达式中，第二个匹配提供了连续赋值 */
exp_asgn: NAME '=' exp { $$ = NewAsgn($1, $3); printf("NAME '=' exp\n");}
    | NAME '=' exp_asgn { $$ = NewAsgn($1, $3); printf("NAME '=' exp_asgn\n");}
    ;
explist: exp
    | exp ',' explist { $$ = NewAst(NT_explist, $1, $3); /* 此为右递归，bison会在读取整个表达式列表后才从最后一个开始规约，所以创建的ast是按输入正序的，但缺点是读取符号过多时会栈溢出，所以在后续的语句列表中不能采用这种规则，而是左递归逆序创建后再重新排序 */}
    ;
symlist: NAME { $$ = NewSymList($1, NULL); }
    | NAME ',' symlist { $$ = NewSymList($1, $3); }
    ;
stmt: exp ';'
    | exp_asgn ';'
    | ';' { $$ = NULL; }
    | IF '(' exp ')' stmt %prec PREC_IF { printf("IF\n");$$ = NewStmt(NT_if, $3, $5, NULL); }
    | IF '(' exp ')' stmt ELSE stmt { printf("IF ELSE\n");$$ = NewStmt(NT_if, $3, $5, $7); }
    | WHILE '(' exp ')' stmt { printf("WHILE\n");$$ = NewStmt(NT_while, $3, $5, NULL); }
    | block
    ;
stmtlist: stmt { printf("stmtlist\n");$$ = NewStmtList($1); }
    | stmtlist stmt { /* 语句列表和参数列表、符号列表有所不同，它可以很长，所以无法使用右递归(会爆栈)，而如果直接使用AST的左递归，则需要在后续使用时倒置树序进而影响运行时长，此处采用链表储存语句节点 */
        printf("stmtlist stmt\n");NewStmtNode((struct stmtlist_ast *)$1, $2);
        $$ = $1;
    }
    ;
stmt_block: stmt /* 块内可以同时读入多行输入，为此专门设定块内语句和列表专用于块内，而普通的语句列表用于总计算 */
    | stmt EOL
    ;
stmtlist_block: stmt_block { $$ = NewStmtList($1); }
    | stmtlist_block stmt_block {
        NewStmtNode((struct stmtlist_ast *)$1, $2);
        $$ = $1;
    }
    ;
block: '{' '}' { $$ = NULL; }
    | '{' stmtlist_block '}' { $$ = $2; }
    | '{' EOL stmtlist_block '}' { $$ = $3; }
    ;
calclist: { }
    | calclist EOL
    | calclist exp EOL { printf("calclist exp EOL\n");ResProc($2); }
    | calclist exp_asgn EOL { printf("calclist exp_asgn EOL\n");ResProc($2); }
    | calclist stmtlist EOL { printf("calclist stmtlist EOL\n");ResProc($2); }
    | calclist error EOL { /* 错误处理，无法匹配时丢弃符号，直到能够匹配到error后面的匹配EOL，这使得bison不会直接退出 */
        yyerrok; //ok可以使bison停止这次错误处理，如果不停止，后续的错误将不会有错误信息，直到遇见正确匹配
        printf("> ");
    }
    | calclist LET NAME '(' symlist ')' block { FuncDef($3, $5, $7); }
    | calclist LET NAME '(' ')' block { FuncDef($3, NULL, $6); } /* 无参函数，由于symlist采用右递归，无法添加空规则，所以只能在此处添加 */
    ;
%%
