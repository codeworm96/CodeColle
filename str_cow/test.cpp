#include "string.h"
#include <iostream>

int main()
{
    String a("hello");
    String b = a;
    a.p();
    b.p();
    char c = a[0];
    std::cout<<c<<std::endl;
    a.p();
    b.p();
    b[0] = 'j';
    a.p();
    b.p();
    return 0;
}

