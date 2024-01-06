#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int a1 = 0, aa1;
extern int a2 = -2;
static long long a3 = 1;
float a4;
double a5;
long double a6;
const int a7;
int a8[5][10];
char *p1[2];
int **p2;

struct C1
{
    int a;
    struct C2 {} const *z;
} c1[2] = {{1, (void *)1}, {2, (void *)114514}};
struct C3{} c2, *cc2[3];

struct C1 f1(int a[][10]);

int main()
{
    printf("test\n");
    int b1 = a1+a2*a3;
    f1(a8);
    return 0;
}

struct C1 f1(int a[][10])
{
    static const long d1 = 1;
    a = &a8[0];
    a = a8;
    double b1, b2 = 2, b3 = a4*a5;
    const struct C3 c;
    printf("in f1: %d, %p\n", c1[0].a, c1[1].z);
    return c1[0];
}

void f2()
{
    struct C11 {
        struct C12 *c;
    };
    struct C12 {
        struct C13 *c;
    };
    struct C13 {
        int a;
    };
    struct C11 *c;
    c->c->c->a = 0;
    // c->c = 0;
}
