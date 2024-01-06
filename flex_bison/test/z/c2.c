#include <stdio.h>
static void f1(int a, int *b)
{
    static int n = 0; //静态变量的定义中的赋值是一次性的，重复执行函数并不会重复定义赋值
    printf("%d, %d\n", ++n, a);
}
void (*f2())()
{
    return f1; //函数指针的匹配规则十分宽松，并且这里可以通过返回static函数来给其它文件调用f1
}