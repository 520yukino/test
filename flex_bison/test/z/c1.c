#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include "z1.h"
extern int a1 = 0;
struct z1 {
    struct z2 {} const *z;
} z3[2] = {{(void *)1}, (void *)114514};
int a2[10];
float a3;
char *a4;
void (*f2())();
int main()
{
    char s[2] = "a";
    printf("%d, %d, %f\n", (int)strtol("011", NULL, 0), (int)strtol("0XAa", NULL, 0), (float)21000001);
    printf("%p, %p\n", z3[0].z, z3[1].z);
    printf("%p, %p\n", s, &s);
    s[1] = EOF;
    perror(s);
    puts("test 1");
    f2()(1); f2()();
    puts("test 2");
    for (int i = 0; i < 10; i++)
        printf("%d ", a2[i]);
    putchar('\n');
    printf("%f, %p\n", a3, a4);
    void *v = 0; a4 = v; //C语言void *可以隐式转为任何指针，但C++必须显示转换
    puts("test 3");
    printf("%-10s %s %d\n", __FILE__, __FUNCTION__, __LINE__);
    puts("test 4");
    double f = 114514.751399893;
    printf("%.10f, %.10lf, %.10e, %6.6g\n", f, f, f, f);
    puts("test 5");
    if (1) if (0) putchar('a'); else putchar('b');
    putchar('\n');
    puts("test 6");
    int *p1 = (int *)malloc(sizeof(int));
    printf("%d, %d\n", malloc_usable_size(p1), ((*(p1-2))&(~7))-8); //可以使用malloc_usable_size内置函数查询动态内存块大小，其基本过程为后一个表达式，在块的前4或前8字节处记录了块的大小，由于块字节一定为8的倍数，所以低3位记录其它块信息
    puts("test -1");
    { return 0;}
}
static int *f3(int)
{
    char *s;
    return s;
}
