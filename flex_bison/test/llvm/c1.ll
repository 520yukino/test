%struct.C1 = type { i32, %struct.C2* }
%struct.C2 = type {}
%struct.C3 = type {}
%struct.C11 = type { %struct.C12* }
%struct.C12 = type { %struct.C13* }
%struct.C13 = type { i32 }

@a1 = dso_local global i32 0, align 4
@a2 = dso_local global i32 -2, align 4
@c1 = dso_local global [2 x %struct.C1] [%struct.C1 { i32 1, %struct.C2* inttoptr (i64 1 to %struct.C2*) }, %struct.C1 { i32 2, %struct.C2* inttoptr (i64 114514 to %struct.C2*) }], align 16
@.str = private unnamed_addr constant [6 x i8] c"test\0A\00", align 1
@a3 = internal global i64 1, align 8
@a8 = dso_local global [5 x [10 x i32]] zeroinitializer, align 16
@f1.d1 = internal constant i64 1, align 8
@a4 = dso_local global float 0.000000e+00, align 4
@a5 = dso_local global double 0.000000e+00, align 8
@.str.1 = private unnamed_addr constant [15 x i8] c"in f1: %d, %p\0A\00", align 1
@aa1 = dso_local global i32 0, align 4
@a6 = dso_local global x86_fp80 0xK00000000000000000000, align 16
@a7 = dso_local constant i32 0, align 4
@p1 = dso_local global [2 x i8*] zeroinitializer, align 16
@p2 = dso_local global i32** null, align 8
@c2 = dso_local global %struct.C3 zeroinitializer, align 1
@cc2 = dso_local global [3 x %struct.C3*] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %struct.C1, align 8
  store i32 0, i32* %1, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0))
  %5 = load i32, i32* @a1, align 4
  %6 = sext i32 %5 to i64
  %7 = load i32, i32* @a2, align 4
  %8 = sext i32 %7 to i64
  %9 = load i64, i64* @a3, align 8
  %10 = mul nsw i64 %8, %9
  %11 = add nsw i64 %6, %10
  %12 = trunc i64 %11 to i32
  store i32 %12, i32* %2, align 4
  %13 = call { i32, %struct.C2* } @f1([10 x i32]* noundef getelementptr inbounds ([5 x [10 x i32]], [5 x [10 x i32]]* @a8, i64 0, i64 0))
  %14 = bitcast %struct.C1* %3 to { i32, %struct.C2* }*
  %15 = getelementptr inbounds { i32, %struct.C2* }, { i32, %struct.C2* }* %14, i32 0, i32 0
  %16 = extractvalue { i32, %struct.C2* } %13, 0
  store i32 %16, i32* %15, align 8
  %17 = getelementptr inbounds { i32, %struct.C2* }, { i32, %struct.C2* }* %14, i32 0, i32 1
  %18 = extractvalue { i32, %struct.C2* } %13, 1
  store %struct.C2* %18, %struct.C2** %17, align 8
  ret i32 0
}

declare i32 @printf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local { i32, %struct.C2* } @f1([10 x i32]* noundef %0) #0 {
  %2 = alloca %struct.C1, align 8
  %3 = alloca [10 x i32]*, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  %6 = alloca double, align 8
  %7 = alloca %struct.C3, align 1
  store [10 x i32]* %0, [10 x i32]** %3, align 8
  store [10 x i32]* getelementptr inbounds ([5 x [10 x i32]], [5 x [10 x i32]]* @a8, i64 0, i64 0), [10 x i32]** %3, align 8
  store [10 x i32]* getelementptr inbounds ([5 x [10 x i32]], [5 x [10 x i32]]* @a8, i64 0, i64 0), [10 x i32]** %3, align 8
  store double 2.000000e+00, double* %5, align 8
  %8 = load float, float* @a4, align 4
  %9 = fpext float %8 to double
  %10 = load double, double* @a5, align 8
  %11 = fmul double %9, %10
  store double %11, double* %6, align 8
  %12 = load i32, i32* getelementptr inbounds ([2 x %struct.C1], [2 x %struct.C1]* @c1, i64 0, i64 0, i32 0), align 16
  %13 = load %struct.C2*, %struct.C2** getelementptr inbounds ([2 x %struct.C1], [2 x %struct.C1]* @c1, i64 0, i64 1, i32 1), align 8
  %14 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0), i32 noundef %12, %struct.C2* noundef %13)
  %15 = bitcast %struct.C1* %2 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %15, i8* align 16 bitcast ([2 x %struct.C1]* @c1 to i8*), i64 16, i1 false)
  %16 = bitcast %struct.C1* %2 to { i32, %struct.C2* }*
  %17 = load { i32, %struct.C2* }, { i32, %struct.C2* }* %16, align 8
  ret { i32, %struct.C2* } %17
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @f2() #0 {
  %1 = alloca %struct.C11*, align 8
  %2 = load %struct.C11*, %struct.C11** %1, align 8
  %3 = getelementptr inbounds %struct.C11, %struct.C11* %2, i32 0, i32 0
  %4 = load %struct.C12*, %struct.C12** %3, align 8
  %5 = getelementptr inbounds %struct.C12, %struct.C12* %4, i32 0, i32 0
  %6 = load %struct.C13*, %struct.C13** %5, align 8
  %7 = getelementptr inbounds %struct.C13, %struct.C13* %6, i32 0, i32 0
  store i32 0, i32* %7, align 4
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nounwind willreturn }

