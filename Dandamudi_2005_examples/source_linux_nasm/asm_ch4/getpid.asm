;assemble with:
; nasm -g -f elf32  getpid.asm 
; gcc -m32 -o getpid getpid.o
extern  printf

SECTION .data
  msg: db "PID= %d",10,0    ; 10 for \n, 0 and of the string, require for printf

SECTION .text
global main
main:

  push ebp                  ; save ebp
  mov ebp, esp              ; put the old top of the stack to the bottom
  sub esp, 100              ; increase the stack of 100 byte

  xor eax, eax              ; set eax to 0
  mov al, 20                ; syscall getpid
  int 0x80                  ; execute

  push eax                  ; put the return of the getpid on the stack
  push dword msg            ; put the string on the stack
  call printf
  add esp, 8                ; decrease esp of 8, 2 push

  leave                     ; destroy the stack

  xor eax, eax              ;
  xor ebx, ebx              ; for exit (0)
  mov al, 1                 ; syscall for exit
  int 0x80                  ; execute
