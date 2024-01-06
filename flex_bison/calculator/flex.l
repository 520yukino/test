%{
#include "h.h"
#include "bison.yac.h"
%}

%option noyywrap yylineno
/* 这2个状态对应普通换行符和块中的换行符，都为include状态以包含无状态模式 */
EXP ([eE][+-]?[0-9]+)

%%
"=" |
"+" |
"-" |
"*" |
"/" |
"," |
";" |
"(" |
")" |
"{" |
"}" { return yytext[0]; }
"&&" {
    yylval.intval = NT_and;
    return LOGIC;
}
"||" {
    yylval.intval = NT_or;
    return LOGIC;
}
">" {
    yylval.intval = NT_greater;
    return CMP;
}
"<" {
    yylval.intval = NT_less;
    return CMP;
}
"==" {
    yylval.intval = NT_equal;
    return CMP;
}
">=" {
    yylval.intval = NT_greater_equal;
    return CMP;
}
"<=" {
    yylval.intval = NT_less_equal;
    return CMP;
}
"abs" {
    yylval.intval = BIF_abs;
    return BIF;
}
"sqrt" {
    yylval.intval = BIF_sqrt;
    return BIF;
}
"exp" {
    yylval.intval = BIF_exp;
    return BIF;
}
"log" {
    yylval.intval = BIF_log;
    return BIF;
}
"print" {
    yylval.intval = BIF_print;
    return BIF;
}
"if" { return IF; }
"else" { return ELSE; }
"while" { return WHILE; }
"let" { return LET; }
[0-9]*\.?[0-9]*{EXP}? {
    yylval.data = atof(yytext);
    return NUMBER;
}
[a-zA-Z_][a-zA-Z_0-9]* {
    yylval.sym = Lookup(yytext);
    return NAME;
}
\n { return EOL; }
\\\n |
"//".* |
[ \t] { }
. { yyerror("Invalid char %c", *yytext); }
%%
