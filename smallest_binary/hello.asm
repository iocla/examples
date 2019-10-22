 
SECTION .data
msg     db      `hello world\n`  
len     equ $ - msg
 
SECTION .text
global  _start  
 
_start:
    mov     edx, len    
    mov     ecx, msg   
    mov     ebx, 1     
    mov     eax, 4    
    int     0x80
exit:
    mov     ebx, 0    
    mov     eax, 1   
    int     0x80
