	.bss
buf :
	.skip 0x14

	.text
	.globl _start

_start :
	xor %rax, %rax
	xor %rcx, %rcx
	xor %rdi, %rdi
	mov $0xc9, %rax
	syscall
	mov %rax, %rbx
	mov $0xfffffffff, %rcx
	jmp loop
loop :
	cmp $0x00, %rcx
	je out
	sub $0x01, %rcx
	jmp loop
out :
	mov $0xc9, %rax
	syscall
	sub %rbx, %rax
	mov $buf, %rsi
	mov $0x00, %rcx
	jmp print
print :
	xor %rdx, %rdx
	mov $0x0a, %rbx
	divq %rbx
	add $'0', %rbx
	mov %rdx, (%rsi, %rcx, 1)
	sub $0x01, %rcx
	cmp $0x00, %rax
	je exit
	jmp revbuf
revbuf :
	
exit :
	mov $0x01, %rax
	mov $0x01, %rdi
	mov buf, %rsi
	mov $0x14, %rdx
	syscall
	mov $0x3c, %rax
	mov $0x00, %rdi
	syscall
