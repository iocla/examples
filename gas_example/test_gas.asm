.intel_syntax noprefix

.section .rodata
hello: .string "Hello, World!\n"
len = . - hello

.section .data
hola: .string "Hola!\n"
	
.section .text
.globl _start

_start:
   mov eax, 4
   mov ebx, 1
   mov ecx, OFFSET FLAT:hello
   mov edx, len
   int 0x80

   mov eax, 1
   mov ebx, 2
   int 0x80

	
