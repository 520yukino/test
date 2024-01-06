%{
#include <bison.tab.h>
%}
%option noyywrap
%%
(([0-9]+".")|("."[0-9]+)|([0-9]+"."[0-9]+))a? {printf("test\n");}
[a-zA-Z]+ { return NAME; }
"," { return yytext[0]; }
[ ] /* 匹配空格只能用[ ]或者"\ " */{ return yytext[0]; }
\n { return EOL; }
"cls;" { return CLEAR; }
. { printf("invalid char %c\n", yytext[0]); }
%%