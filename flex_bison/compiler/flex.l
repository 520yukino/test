%{
#include "h.h"
#include "bison.yac.h"
%}

/* 这2个状态对应普通换行符和块中的换行符，都为include状态以包含无状态模式 */
%option noyywrap
/* 专用于double的科学计数法指数部分 */
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

"void" {
    yylval.intval = VT_void;
    return TYPE_KEY;
}
"char" {
    yylval.intval = VT_char;
    return TYPE_KEY;
}
"short" {
    yylval.intval = VT_short;
    return TYPE_KEY;
}
"int" {
    yylval.intval = VT_int;
    return TYPE_KEY;
}
"long" {
    yylval.intval = VT_long;
    return TYPE_KEY;
}
"float" {
    yylval.intval = VT_float;
    return TYPE_KEY;
}
"double" {
    yylval.intval = VT_double;
    return TYPE_KEY;
}

"if" { return IF; }
"else" { return ELSE; }
"while" { return WHILE; }
"return" { return RETURN; }

0[0-7]* { //8进制整数(0也在其中)，被当做int
    yylval.intval = (int)strtol(yytext, NULL, 0);
    return INT_NUM;
}
0[xX][0-9a-fA-F]+ { //16进制整数，被当做int
    yylval.intval = (int)strtol(yytext, NULL, 0);
    return INT_NUM;
}
[1-9][0-9]* { //10进制整数，被当做int
    yylval.intval = (int)strtol(yytext, NULL, 0);
    return INT_NUM;
}
(([0-9]+".")|("."[0-9]+)|([0-9]+"."[0-9]+)){EXP}? { //十进制小数(包含指数)，被当做double
    yylval.doubleval = atof(yytext);
    return DOUBLE_NUM;
}
[a-zA-Z_][a-zA-Z_0-9]* { //标识符
    yylval.name = strdup(yytext);
    return NAME;
}

\n { return EOL; }
\\\n |
"//".* |
[ \t] { }
. { ErrorPrintf("Invalid char %c", *yytext); }
%%
