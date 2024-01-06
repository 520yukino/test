	.file	"z1.c"
	.text
	.globl	a1
	.data
	.align 4
	.type	a1, @object
	.size	a1, 4
a1:
	.long	1
	.text
	.type	f, @function
f:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$2, a1(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	f, .-f
	.globl	a2
	.bss
	.align 32
	.type	a2, @object
	.size	a2, 40
a2:
	.zero	40
	.globl	a3
	.align 4
	.type	a3, @object
	.size	a3, 4
a3:
	.zero	4
	.globl	a4
	.align 8
	.type	a4, @object
	.size	a4, 8
a4:
	.zero	8
	.section	.rodata
.LC0:
	.string	"t 1"
.LC1:
	.string	"%d\n"
.LC2:
	.string	"t 2"
.LC3:
	.string	"%d "
.LC4:
	.string	"%f, %p\n"
.LC5:
	.string	"t 3"
.LC6:
	.string	"z1.c"
.LC7:
	.string	"%s %s %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movw	$97, -10(%rbp)
	movb	$-1, -9(%rbp)
	leaq	-10(%rbp), %rax
	movq	%rax, %rdi
	call	perror@PLT
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, %eax
	call	f
	movl	a1(%rip), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$0, -28(%rbp)
	jmp	.L3
.L4:
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,4), %rdx
	leaq	a2(%rip), %rax
	movl	(%rdx,%rax), %eax
	movl	%eax, %esi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	addl	$1, -28(%rbp)
.L3:
	cmpl	$9, -28(%rbp)
	jle	.L4
	movl	$10, %edi
	call	putchar@PLT
	movq	a4(%rip), %rdx
	movss	a3(%rip), %xmm0
	pxor	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm1
	movq	%xmm1, %rax
	movq	%rdx, %rsi
	movq	%rax, %xmm0
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	movq	$0, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, a4(%rip)
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$29, %ecx
	leaq	__FUNCTION__.0(%rip), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L6
	call	__stack_chk_fail@PLT
.L6:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.section	.rodata
	.type	__FUNCTION__.0, @object
	.size	__FUNCTION__.0, 5
__FUNCTION__.0:
	.string	"main"
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04.1) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
