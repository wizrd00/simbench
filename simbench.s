	.data
msg :
	.ascii "\nScore -> "
err :
	.ascii "\nError on sys_time"
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
	mov $0xc9, %rax
	xor %rdi, %rdi
	syscall
	cmp $-0x1, %rax
	je error
	mov %rax, %rbx
	mov $0xfffffffff, %rcx
	jmp loop0
loop0 :
	cmp $0x00, %rcx
	je out
	sub $0x01, %rcx
	jmp loop0
out :
	mov $0xc9, %rax
	xor %rdi, %rdi
	syscall
	cmp $-0x01, %rax
	je error
	sub %rbx, %rax
	mov $buf, %rsi
	xor %rcx, %rcx
	jmp print
print :
	xor %rdx, %rdx
	mov $0x0a, %rbx
	divq %rbx
	add $'0', %dl
	movb %dl, (%rsi, %rcx, 1)
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
	jle inact
	movb (%rsi, %rcx, 1), %al
	movb (%rsi, %rdx, 1), %bl
	movb %al, (%rsi, %rdx, 1)
	movb %bl, (%rsi, %rcx, 1)
	add $0x01, %rcx
	sub $0x01, %rdx
	jmp loop1
inact :
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
	jmp exit
error :
	mov $0x01, %rax
	mov $0x01, %rdi
	mov $err, %rsi
	mov $0xf2, %rdx
	syscall
	jmp exit
exit :
	mov $0x3c, %rax
	mov $0x00, %rdi
	syscall
