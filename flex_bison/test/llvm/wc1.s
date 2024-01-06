	.text
	.def	@feat.00;
	.scl	3;
	.type	0;
	.endef
	.globl	@feat.00
.set @feat.00, 0
	.file	"c1.c"
	.def	main;
	.scl	2;
	.type	32;
	.endef
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
main:                                   # @main
.seh_proc main
# %bb.0:
	pushq	%rbp
	.seh_pushreg %rbp
	subq	$64, %rsp
	.seh_stackalloc 64
	leaq	64(%rsp), %rbp
	.seh_setframe %rbp, 64
	.seh_endprologue
	callq	__main
	movl	$0, -8(%rbp)
	leaq	.L.str(%rip), %rcx
	callq	printf
	movslq	a1(%rip), %rax
	movslq	a2(%rip), %rcx
	imulq	a3(%rip), %rcx
	addq	%rcx, %rax
	movl	%eax, -4(%rbp)
	leaq	-24(%rbp), %rcx
	leaq	a8(%rip), %rdx
	callq	f1
	xorl	%eax, %eax
	addq	$64, %rsp
	popq	%rbp
	retq
	.seh_endproc
                                        # -- End function
	.def	f1;
	.scl	2;
	.type	32;
	.endef
	.section	.rdata,"dr"
	.p2align	3                               # -- Begin function f1
.LCPI1_0:
	.quad	0x4000000000000000              # double 2
	.text
	.globl	f1
	.p2align	4, 0x90
f1:                                     # @f1
.seh_proc f1
# %bb.0:
	pushq	%rsi
	.seh_pushreg %rsi
	subq	$80, %rsp
	.seh_stackalloc 80
	.seh_endprologue
	movq	%rcx, %rsi
	movq	%rsi, 56(%rsp)
	movq	%rdx, 32(%rsp)
	leaq	a8(%rip), %rax
	movq	%rax, 32(%rsp)
	leaq	a8(%rip), %rax
	movq	%rax, 32(%rsp)
	movsd	.LCPI1_0(%rip), %xmm0           # xmm0 = mem[0],zero
	movsd	%xmm0, 48(%rsp)
	movss	a4(%rip), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	mulsd	a5(%rip), %xmm0
	movsd	%xmm0, 40(%rsp)
	movl	c1(%rip), %edx
	movq	c1+24(%rip), %r8
	leaq	.L.str.1(%rip), %rcx
	callq	printf
	movq	c1(%rip), %rax
	movq	%rax, (%rsi)
	movq	c1+8(%rip), %rax
	movq	%rax, 8(%rsi)
	movq	%rsi, %rax
	addq	$80, %rsp
	popq	%rsi
	retq
	.seh_endproc
                                        # -- End function
	.def	f2;
	.scl	2;
	.type	32;
	.endef
	.globl	f2                              # -- Begin function f2
	.p2align	4, 0x90
f2:                                     # @f2
.seh_proc f2
# %bb.0:
	pushq	%rax
	.seh_stackalloc 8
	.seh_endprologue
	movq	(%rsp), %rax
	movq	(%rax), %rax
	movq	(%rax), %rax
	movl	$0, (%rax)
	popq	%rax
	retq
	.seh_endproc
                                        # -- End function
	.bss
	.globl	a1                              # @a1
	.p2align	2
a1:
	.long	0                               # 0x0

	.data
	.globl	a2                              # @a2
	.p2align	2
a2:
	.long	4294967294                      # 0xfffffffe

	.globl	c1                              # @c1
	.p2align	4
c1:
	.long	1                               # 0x1
	.zero	4
	.quad	1
	.long	2                               # 0x2
	.zero	4
	.quad	114514

	.section	.rdata,"dr"
.L.str:                                 # @.str
	.asciz	"test\n"

	.data
	.p2align	3                               # @a3
a3:
	.quad	1                               # 0x1

	.bss
	.globl	a8                              # @a8
	.p2align	4
a8:
	.zero	200

	.section	.rdata,"dr"
	.p2align	2                               # @f1.d1
f1.d1:
	.long	1                               # 0x1

	.bss
	.globl	a4                              # @a4
	.p2align	2
a4:
	.long	0x00000000                      # float 0

	.globl	a5                              # @a5
	.p2align	3
a5:
	.quad	0x0000000000000000              # double 0

	.section	.rdata,"dr"
.L.str.1:                               # @.str.1
	.asciz	"in f1: %d, %p\n"

	.bss
	.globl	aa1                             # @aa1
	.p2align	2
aa1:
	.long	0                               # 0x0

	.globl	a6                              # @a6
	.p2align	4
a6:
	.quad	0x0000000000000000              # x86_fp80 0
	.short	0x0000
	.zero	6

	.section	.rdata,"dr"
	.globl	a7                              # @a7
	.p2align	2
a7:
	.long	0                               # 0x0

	.bss
	.globl	p1                              # @p1
	.p2align	4
p1:
	.zero	16

	.globl	p2                              # @p2
	.p2align	3
p2:
	.quad	0

	.globl	c2                              # @c2
c2:

	.globl	cc2                             # @cc2
	.p2align	4
cc2:
	.zero	24

