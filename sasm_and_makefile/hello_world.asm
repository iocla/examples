%include "io.inc"



	
section .data
	myString: db "Hello, World!",10, 0
	format_int:	 db "%d %d", 10, 0
	text_impare db "impare:",0
	text_negative db "negative:",0
	
	numere 	dw 1,2,-3,5,-12, 56, 57, -101, 1002, -2
	nn dd ($ - numere)/2
	impare db 0
	negative db 0
	
section .text
	global CMAIN
	extern printf
CMAIN:
	mov ecx, 0                 ; N = valoarea registrului ecx
	mov eax, 0
for:	
	mov ax, word [numere + 2*ecx]
	test ax, 1
	jz pare
	inc byte [impare]
pare:
	test ax, 0x8000
	jz pozitive
	inc byte [negative]
pozitive:
	inc ecx
	cmp ecx, [nn]
	jnz for
	
print:
	PRINT_STRING text_impare
	PRINT_UDEC 1, [impare]
	NEWLINE
	PRINT_STRING text_negative
	PRINT_UDEC 1, [negative]
	NEWLINE
	
    ret
