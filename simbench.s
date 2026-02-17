	.data
msg :
	.ascii "\nScore -> "
lnf :
	.ascii "\n\n"

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
	mov $0x5ffffffff, %rcx
	jmp loop0
loop0 :
	cmp $0x00, %rcx
	je out
	sub $0x01, %rcx
	jmp loop0
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
	add $'0', %rdx
	mov %rdx, (%rsi, %rcx, 1)
	cmp $0x00, %rax
	je revbuf
	add $0x01, %rcx
	jmp print
revbuf :
	mov %rcx, %rdx
	xor %rcx, %rcx
	jmp loop1
loop1 :
	cmp %rcx, %rdx
	jle exit
	mov (%rsi, %rcx, 1), %rax
	mov (%rsi, %rdx, 1), %rbx
	mov %rax, (%rsi, %rdx, 1)
	mov %rbx, (%rsi, %rcx, 1)
	add 0x01, %rcx
	sub 0x01, %rdx
	jmp loop1
exit :
	mov $0x01, %rax
	mov $0x01, %rdi
	mov $msg, %rsi
	mov $0x0a, %rdx
	syscall
	mov $0x01, %rax
	mov $buf, %rsi
	mov $0x14, %rdx
	syscall
	mov $0x01, %rax
	mov $lnf, %rsi
	mov $0x02, %rdx
	syscall
	mov $0x3c, %rax
	mov $0x00, %rdi
	syscall
