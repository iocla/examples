;A string read program       FUNNYSTR.ASM
;        Objective: To demonstrate the use of BIOS keyboard
;                   functions 0, 1, and 2.
;            Input: Prompts for a string.
;           Output: Displays the input string and its length.

STR_LENGTH  EQU  81
%include "io.mac"
.STACK   100H
.DATA
prompt_msg  db  "Please enter a string (< 81 chars): ",0
string_msg  db  "The string entered is ",0
length_msg  db  " with a length of ",0
end_msg     db  " characters.",0

.UDATA
string      resb  STR_LENGTH

.CODE
        .STARTUP
        PutStr  prompt_msg
        mov     AX,STR_LENGTH-1
        push    AX              ; push max. string length
        mov     AX,string
        push    AX              ; and string pointer parameters
        call    read_string     ; to call read_string procedure
        nwln
        PutStr  string_msg
        PutStr  string
        PutStr  length_msg
        PutInt  AX
        PutStr  end_msg
        nwln
        .EXIT

;-----------------------------------------------------------
; String read procedure using BIOS int 16H. Receives string
; pointer and the length via the stack. Length of the string
; is returned in AX.
;-----------------------------------------------------------
.CODE
read_string:
        push    BP
        mov     BP,SP
        push    BX
        push    CX
        mov     CX,[BP+6]    ; CX = length
        mov     BX,[BP+4]    ; BX = string pointer
read_loop:
        mov     AH,2         ; read keyboard status
        int     16H          ; status returned in AL
        and     AL,3         ; mask off most significant 6 bits
        cmp     AL,3         ; if equal both shift keys depressed
        jz      end_read 
        mov     AH,1         ; otherwise, see if a key has been 
        int     16H          ; struck
        jnz     read_key     ; if so, read the key
        jmp     read_loop
read_key:
        mov     AH,0         ; read the next key from keyboard
        int     16H          ; key returned in AL
        mov     [BX],AL      ; copy to buffer and increment
        inc     BX           ;  buffer pointer
        PutCh   AL           ; display the character
        loop    read_loop
end_read:
        mov     [BX],byte 0  ; append NULL
        sub     BX,[BP+4]    ; find the input string length
        mov     AX,BX        ; return string length in AX
        pop     CX
        pop     BX
        pop     BP
        ret     4



