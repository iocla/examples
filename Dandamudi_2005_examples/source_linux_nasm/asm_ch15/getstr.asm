;A string read program                        GETSTR.ASM
;        Objective: To demonstrate the use of DOS keyboard
;                   functions.
;            Input: Prompts for a string.
;           Output: Displays the input string.

STR_LENGTH  EQU  81
%include "io.mac"
.STACK   100H
.DATA
prompt_msg1  db  "Please enter maximum string length: ",0
prompt_msg2  db  "Please enter a string: ",0
string_msg   db  "The string entered is: ",0
error_msg    db  "No string read. Buffer size must be at least 1.",0

.UDATA
temp_buf     resb  STR_LENGTH+2
in_string    resb  STR_LENGTH

.CODE
        .STARTUP
        PutStr  prompt_msg1
        GetInt  CX              ; max. string length
        nwln
        PutStr  prompt_msg2
        mov     BX,in_string    ; BX = pinter to input buffer 
        call    read_string     ; to call read_string procedure
        nwln
        PutStr  string_msg
        PutStr  in_string
        nwln
        .EXIT

;-----------------------------------------------------------
; Get string (of maximum length 80) from keyboard.
;     BX <-- pointer to a buffer to store the input string
;     CX <-- buffer size = string length + 1 for NULL
; If CX <2, reports error and terminates.
; If CX > 81, CX = 81 is used to read at most 80 characters.
;-----------------------------------------------------------
read_string:
        pusha
        ; ES = DS for use by the string instruction--movsb        
        mov     DX,DS          
        mov     ES,DX           
        mov     DI,BX           ; DI = buffer pointer
        inc     CX              ; space for NULL
        ; check CX value
        cmp     CX,2
        jl      bailout
        cmp     CX,81
        jle     read_str
        mov     CX,81
read_str:
        ; use temporary buffer temp_buf to read the string
        ; using functin 0AH of int  21H
        mov     DX,temp_buf
        mov     SI,DX
        mov     [SI],CL         ; first byte = # chars. to read
        mov     AH,0AH
        int     21H
        inc     SI              ; second byte = # chars. read
        mov     CL,[SI]         ; CX = # bytes to copy
        inc     SI              ; SI = input string first char.
        cld                     ; forward direction for copy
        rep     movsb
        mov     byte[DI],0      ; append NULL
        jmp     done
bailout:
        nwln
        PutStr  error_msg
done:
        popa
        ret

