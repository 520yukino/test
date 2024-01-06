#include <iostream>
using namespace std;
class C1
{
private:
    int a;
public:
    C1(int a = 1): a(a) { cout << "constructor" << endl; }
    ~C1() { cout << "destructor" << endl; }
};

class C1 c1(C1);
class C1 c2(1);

int main()
{
    for (size_t i = 0; i < 3; i++)
    {
        class C1 C1; //块中的变量会被反复定义
    }

    int C1; //类和变量的名称可以重叠
    class C1 c1(C1); //函数c1和对象c1的形式完全相同，语法分析中的唯一不同点仅仅只是作用域
}
