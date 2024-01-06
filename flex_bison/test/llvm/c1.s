	.text
	.file	"c1.ll"
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	$0, -8(%rbp)
	movabsq	$.L.str, %rdi
	movb	$0, %al
	callq	printf@PLT
	movslq	a1, %rax
	movslq	a2, %rcx
	imulq	a3, %rcx
	addq	%rcx, %rax
	movl	%eax, -4(%rbp)
	movabsq	$a8, %rdi
	callq	f1
	movl	%eax, -24(%rbp)
	movq	%rdx, -16(%rbp)
	xorl	%eax, %eax
	addq	$32, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.globl	f1                              # -- Begin function f1
	.p2align	4, 0x90
	.type	f1,@function
f1:                                     # @f1
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$64, %rsp
	movq	%rdi, -8(%rbp)
	movq	$a8, -8(%rbp)
	movq	$a8, -8(%rbp)
	movabsq	$4611686018427387904, %rax      # imm = 0x4000000000000000
	movq	%rax, -48(%rbp)
	movss	a4(%rip), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	movsd	a5(%rip), %xmm1                 # xmm1 = mem[0],zero
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -40(%rbp)
	movl	c1(%rip), %esi
	movq	c1+24(%rip), %rdx
	movl	$.L.str.1, %edi
	xorl	%eax, %eax
	callq	printf@PLT
	movaps	c1(%rip), %xmm0
	movaps	%xmm0, -32(%rbp)
	movl	-32(%rbp), %eax
	movq	-24(%rbp), %rdx
	addq	$64, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end1:
	.size	f1, .Lfunc_end1-f1
	.cfi_endproc
                                        # -- End function
	.globl	f2                              # -- Begin function f2
	.p2align	4, 0x90
	.type	f2,@function
f2:                                     # @f2
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movl	$0, (%rax)
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end2:
	.size	f2, .Lfunc_end2-f2
	.cfi_endproc
                                        # -- End function
	.type	a1,@object                      # @a1
	.bss
	.globl	a1
	.p2align	2
a1:
	.long	0                               # 0x0
	.size	a1, 4

	.type	a2,@object                      # @a2
	.data
	.globl	a2
	.p2align	2
a2:
	.long	4294967294                      # 0xfffffffe
	.size	a2, 4

	.type	c1,@object                      # @c1
	.globl	c1
	.p2align	4
c1:
	.long	1                               # 0x1
	.zero	4
	.quad	1
	.long	2                               # 0x2
	.zero	4
	.quad	114514
	.size	c1, 32

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"test\n"
	.size	.L.str, 6

	.type	a3,@object                      # @a3
	.data
	.p2align	3
a3:
	.quad	1                               # 0x1
	.size	a3, 8

	.type	a8,@object                      # @a8
	.bss
	.globl	a8
	.p2align	4
a8:
	.zero	200
	.size	a8, 200

	.type	f1.d1,@object                   # @f1.d1
	.section	.rodata,"a",@progbits
	.p2align	3
f1.d1:
	.quad	1                               # 0x1
	.size	f1.d1, 8

	.type	a4,@object                      # @a4
	.bss
	.globl	a4
	.p2align	2
a4:
	.long	0x00000000                      # float 0
	.size	a4, 4

	.type	a5,@object                      # @a5
	.globl	a5
	.p2align	3
a5:
	.quad	0x0000000000000000              # double 0
	.size	a5, 8

	.type	.L.str.1,@object                # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"in f1: %d, %p\n"
	.size	.L.str.1, 15

	.type	aa1,@object                     # @aa1
	.bss
	.globl	aa1
	.p2align	2
aa1:
	.long	0                               # 0x0
	.size	aa1, 4

	.type	a6,@object                      # @a6
	.globl	a6
	.p2align	4
a6:
	.quad	0x0000000000000000              # x86_fp80 0
	.short	0x0000
	.zero	6
	.size	a6, 16

	.type	a7,@object                      # @a7
	.section	.rodata,"a",@progbits
	.globl	a7
	.p2align	2
a7:
	.long	0                               # 0x0
	.size	a7, 4

	.type	p1,@object                      # @p1
	.bss
	.globl	p1
	.p2align	4
p1:
	.zero	16
	.size	p1, 16

	.type	p2,@object                      # @p2
	.globl	p2
	.p2align	3
p2:
	.quad	0
	.size	p2, 8

	.type	c2,@object                      # @c2
	.globl	c2
c2:
	.size	c2, 0

	.type	cc2,@object                     # @cc2
	.globl	cc2
	.p2align	4
cc2:
	.zero	24
	.size	cc2, 24

	.section	".note.GNU-stack","",@progbits
