target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-Ubuntu22.04.1"

define i32 @main() {
    %stack_variable = alloca i32
    %1 = add i32 1, 2
    store i32 %1, i32* %stack_variable
    %2 = add i32 3, 4 ; llvm采用SSA策略，同一个虚拟寄存器只能被赋值一次
    store i32 %2, i32* %stack_variable
    
    %x = alloca i32 ; %x is of type i32*, which is the address of variable x
    %y = alloca i32 ; %y is of type i32*, which is the address of variable y
    %address_of_x = ptrtoint i32* %x to i64
    %address_of_y = sub i64 %address_of_x, 4
    %also_y = inttoptr i64 %address_of_y to i32* ; %also_y is of type i32*, which is the address of variable y

    ret i32 %2
}