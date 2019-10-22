
;;; macro to use printf with 32bit parameters: 
;;; - 1st parameter MUST be an immediate in backquotes `EAX=%d ECX=%x \n\x0`
;;; 	escape \n and \x0 only work with backquotes
;;; - rest of parameters MUST be 32bit
;;; - gen purpose and flags are preserved  
;;; - stack is cleaned 
%macro PRINTF32 1-*
	pushf
	pushad
 	jmp     %%endstr 
%%str:       db      %1 
%%endstr:
%rep  %0 - 1
%rotate -1
        push    dword %1 
%endrep
 	push %%str	
	call printf
	add esp, 4*%0
	popad
	popf
%endmacro	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;; example print debugging session
	
section .data
	numere 	dw 1,2,-3,5,-12, 56, 57, -101, 1002, -2
	nn dd ($ - numere)/2
	impare dd 0
	negative dd 0
	
section .text

	global main
	extern printf
main:
	mov ecx, 0         
	mov eax, 0
for:	
	movsx eax, word [numere + 2*ecx]
	test ax, 1
	jz pare
	PRINTF32 `EAX impar = %d\n\x0`, eax
	inc dword [impare]
pare:
	test ax, 0x8000
	jz pozitive
	PRINTF32 `EAX negativ = %d\n\x0`, eax 
	inc dword [negative]
pozitive:
	inc ecx
	cmp ecx, [nn]
	PRINTF32 `EAX=0x%x ECX=%d nn=%d\n\x0`, eax, ecx, [nn]	
	jnz for
	
print:
	PRINTF32 `impare: %d\n\x0`, [impare]
	PRINTF32 `negative: %d\n\x0`, [negative]
	PRINTF32 `Done.\n\x0`
    ret
