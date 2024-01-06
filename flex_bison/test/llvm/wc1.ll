; ModuleID = 'c1.c'
source_filename = "c1.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

%struct.C1 = type { i32, ptr }
%struct.C3 = type {}
%struct.C11 = type { ptr }
%struct.C12 = type { ptr }
%struct.C13 = type { i32 }

@a1 = dso_local global i32 0, align 4
@a2 = dso_local global i32 -2, align 4
@c1 = dso_local global [2 x %struct.C1] [%struct.C1 { i32 1, ptr inttoptr (i64 1 to ptr) }, %struct.C1 { i32 2, ptr inttoptr (i64 114514 to ptr) }], align 16
@.str = private unnamed_addr constant [6 x i8] c"test\0A\00", align 1
@a3 = internal global i64 1, align 8
@a8 = dso_local global [5 x [10 x i32]] zeroinitializer, align 16
@f1.d1 = internal constant i32 1, align 4
@a4 = dso_local global float 0.000000e+00, align 4
@a5 = dso_local global double 0.000000e+00, align 8
@.str.1 = private unnamed_addr constant [15 x i8] c"in f1: %d, %p\0A\00", align 1
@aa1 = dso_local global i32 0, align 4
@a6 = dso_local global x86_fp80 0xK00000000000000000000, align 16
@a7 = dso_local constant i32 0, align 4
@p1 = dso_local global [2 x ptr] zeroinitializer, align 16
@p2 = dso_local global ptr null, align 8
@c2 = dso_local global %struct.C3 zeroinitializer, align 1
@cc2 = dso_local global [3 x ptr] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %struct.C1, align 8
  store i32 0, ptr %1, align 4
  %4 = call i32 (ptr, ...) @printf(ptr noundef @.str)
  %5 = load i32, ptr @a1, align 4
  %6 = sext i32 %5 to i64
  %7 = load i32, ptr @a2, align 4
  %8 = sext i32 %7 to i64
  %9 = load i64, ptr @a3, align 8
  %10 = mul nsw i64 %8, %9
  %11 = add nsw i64 %6, %10
  %12 = trunc i64 %11 to i32
  store i32 %12, ptr %2, align 4
  call void @f1(ptr sret(%struct.C1) align 8 %3, ptr noundef @a8)
  ret i32 0
}

declare dso_local i32 @printf(ptr noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @f1(ptr noalias sret(%struct.C1) align 8 %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  %7 = alloca double, align 8
  %8 = alloca %struct.C3, align 1
  store ptr %0, ptr %3, align 8
  store ptr %1, ptr %4, align 8
  store ptr @a8, ptr %4, align 8
  store ptr @a8, ptr %4, align 8
  store double 2.000000e+00, ptr %6, align 8
  %9 = load float, ptr @a4, align 4
  %10 = fpext float %9 to double
  %11 = load double, ptr @a5, align 8
  %12 = fmul double %10, %11
  store double %12, ptr %7, align 8
  %13 = load i32, ptr @c1, align 16
  %14 = load ptr, ptr getelementptr inbounds ([2 x %struct.C1], ptr @c1, i64 0, i64 1, i32 1), align 8
  %15 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, i32 noundef %13, ptr noundef %14)
  call void @llvm.memcpy.p0.p0.i64(ptr align 8 %0, ptr align 16 @c1, i64 16, i1 false)
  ret void
}

; Function Attrs: argmemonly nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @f2() #0 {
  %1 = alloca ptr, align 8
  %2 = load ptr, ptr %1, align 8
  %3 = getelementptr inbounds %struct.C11, ptr %2, i32 0, i32 0
  %4 = load ptr, ptr %3, align 8
  %5 = getelementptr inbounds %struct.C12, ptr %4, i32 0, i32 0
  %6 = load ptr, ptr %5, align 8
  %7 = getelementptr inbounds %struct.C13, ptr %6, i32 0, i32 0
  store i32 0, ptr %7, align 4
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nocallback nofree nounwind willreturn }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"(built by Brecht Sanders) clang version 15.0.7"}
