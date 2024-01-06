; ModuleID = 'c1.c'
source_filename = "c1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.z1 = type { %struct.z2* }
%struct.z2 = type {}
%struct.z5 = type opaque

@a1 = dso_local global i32 0, align 4
@z3 = dso_local global [2 x %struct.z1] [%struct.z1 { %struct.z2* inttoptr (i64 1 to %struct.z2*) }, %struct.z1 { %struct.z2* inttoptr (i64 114514 to %struct.z2*) }], align 16
@zz = dso_local global %struct.z5* null, align 8
@__const.main.s = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str = private unnamed_addr constant [12 x i8] c"%d, %d, %f\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"011\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"0XAa\00", align 1
@.str.3 = private unnamed_addr constant [8 x i8] c"%p, %p\0A\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"test 1\00", align 1
@.str.5 = private unnamed_addr constant [7 x i8] c"test 2\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@a2 = dso_local global [10 x i32] zeroinitializer, align 16
@.str.7 = private unnamed_addr constant [8 x i8] c"%f, %p\0A\00", align 1
@a3 = dso_local global float 0.000000e+00, align 4
@a4 = dso_local global i8* null, align 8
@.str.8 = private unnamed_addr constant [7 x i8] c"test 3\00", align 1
@.str.9 = private unnamed_addr constant [13 x i8] c"%-10s %s %d\0A\00", align 1
@.str.10 = private unnamed_addr constant [5 x i8] c"c1.c\00", align 1
@__FUNCTION__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.11 = private unnamed_addr constant [7 x i8] c"test 4\00", align 1
@.str.12 = private unnamed_addr constant [29 x i8] c"%.10f, %.10lf, %.10e, %6.6g\0A\00", align 1
@.str.13 = private unnamed_addr constant [7 x i8] c"test 5\00", align 1
@.str.14 = private unnamed_addr constant [7 x i8] c"test 6\00", align 1
@.str.15 = private unnamed_addr constant [8 x i8] c"%d, %d\0A\00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c"test -1\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i8], align 1
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca double, align 8
  %6 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  %7 = bitcast [2 x i8]* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %7, i8* align 1 getelementptr inbounds ([2 x i8], [2 x i8]* @__const.main.s, i32 0, i32 0), i64 2, i1 false)
  %8 = call i64 @strtol(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i8** noundef null, i32 noundef 0) #4
  %9 = trunc i64 %8 to i32
  %10 = call i64 @strtol(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i64 0, i64 0), i8** noundef null, i32 noundef 0) #4
  %11 = trunc i64 %10 to i32
  %12 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i64 0, i64 0), i32 noundef %9, i32 noundef %11, double noundef 2.100000e+07)
  %13 = load %struct.z2*, %struct.z2** getelementptr inbounds ([2 x %struct.z1], [2 x %struct.z1]* @z3, i64 0, i64 0, i32 0), align 16
  %14 = load %struct.z2*, %struct.z2** getelementptr inbounds ([2 x %struct.z1], [2 x %struct.z1]* @z3, i64 0, i64 1, i32 0), align 8
  %15 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), %struct.z2* noundef %13, %struct.z2* noundef %14)
  %16 = getelementptr inbounds [2 x i8], [2 x i8]* %2, i64 0, i64 0
  %17 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.3, i64 0, i64 0), i8* noundef %16, [2 x i8]* noundef %2)
  %18 = getelementptr inbounds [2 x i8], [2 x i8]* %2, i64 0, i64 1
  store i8 -1, i8* %18, align 1
  %19 = getelementptr inbounds [2 x i8], [2 x i8]* %2, i64 0, i64 0
  call void @perror(i8* noundef %19)
  %20 = call i32 @puts(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0))
  %21 = call void (...)* (...) @f2()
  %22 = bitcast void (...)* %21 to void (i32, ...)*
  call void (i32, ...) %22(i32 noundef 1)
  %23 = call void (...)* (...) @f2()
  call void (...) %23()
  %24 = call i32 @puts(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.5, i64 0, i64 0))
  store i32 0, i32* %3, align 4
  br label %25

25:                                               ; preds = %34, %0
  %26 = load i32, i32* %3, align 4
  %27 = icmp slt i32 %26, 10
  br i1 %27, label %28, label %37

28:                                               ; preds = %25
  %29 = load i32, i32* %3, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [10 x i32], [10 x i32]* @a2, i64 0, i64 %30
  %32 = load i32, i32* %31, align 4
  %33 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i64 0, i64 0), i32 noundef %32)
  br label %34

34:                                               ; preds = %28
  %35 = load i32, i32* %3, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, i32* %3, align 4
  br label %25, !llvm.loop !6

37:                                               ; preds = %25
  %38 = call i32 @putchar(i32 noundef 10)
  %39 = load float, float* @a3, align 4
  %40 = fpext float %39 to double
  %41 = load i8*, i8** @a4, align 8
  %42 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.7, i64 0, i64 0), double noundef %40, i8* noundef %41)
  store i8* null, i8** %4, align 8
  %43 = load i8*, i8** %4, align 8
  store i8* %43, i8** @a4, align 8
  %44 = call i32 @puts(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.8, i64 0, i64 0))
  %45 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.10, i64 0, i64 0), i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @__FUNCTION__.main, i64 0, i64 0), i32 noundef 30)
  %46 = call i32 @puts(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.11, i64 0, i64 0))
  store double 0x40FBF52C05BBE4EA, double* %5, align 8
  %47 = load double, double* %5, align 8
  %48 = load double, double* %5, align 8
  %49 = load double, double* %5, align 8
  %50 = load double, double* %5, align 8
  %51 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.12, i64 0, i64 0), double noundef %47, double noundef %48, double noundef %49, double noundef %50)
  %52 = call i32 @puts(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.13, i64 0, i64 0))
  %53 = call i32 @putchar(i32 noundef 98)
  %54 = call i32 @putchar(i32 noundef 10)
  %55 = call i32 @puts(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.14, i64 0, i64 0))
  %56 = call noalias i8* @malloc(i64 noundef 4) #4
  %57 = bitcast i8* %56 to i32*
  store i32* %57, i32** %6, align 8
  %58 = load i32*, i32** %6, align 8
  %59 = call i32 (i32*, ...) bitcast (i32 (...)* @malloc_usable_size to i32 (i32*, ...)*)(i32* noundef %58)
  %60 = load i32*, i32** %6, align 8
  %61 = getelementptr inbounds i32, i32* %60, i64 -2
  %62 = load i32, i32* %61, align 4
  %63 = and i32 %62, -8
  %64 = sub nsw i32 %63, 8
  %65 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.15, i64 0, i64 0), i32 noundef %59, i32 noundef %64)
  %66 = call i32 @puts(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.16, i64 0, i64 0))
  call void (...) @f4()
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: nounwind
declare i64 @strtol(i8* noundef, i8** noundef, i32 noundef) #3

declare void @perror(i8* noundef) #2

declare i32 @puts(i8* noundef) #2

declare void (...)* @f2(...) #2

declare i32 @putchar(i32 noundef) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

declare i32 @malloc_usable_size(...) #2

declare void @f4(...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
