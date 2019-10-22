;   Char and string I/O program                      chstr.asm
;
;         Objective: To demonstrate character and string I/O 
;                    using the int 0x80 services.
;             Input: As prompted.
;            Output: Outputs a string. 
%include "io.mac"

BUF_SIZE  EQU   50
LF        EQU   10

.DATA
out_prompt   db  "Please enter the a name: ",0
name_msg     db  "Name you entered is: ",0

.UDATA
in_name      resb  BUF_SIZE
temp_char    resb  1

.CODE
        .STARTUP
        PutStr  out_prompt
        ; getstr expects buffer size in ESI and 
        ; the input buffer pointer in EDI       
        mov     ESI,BUF_SIZE
        mov     EDI,in_name
        call    getstr
        
        ; To test putch procedure, we use a loop to display
        ; the name read by getstr procedure
        mov     EBX,in_name
repeat1:
        mov     AL,[EBX]      ; putch expects char in AL
        cmp     AL,0          ; done if NULL
        je      done
        call    putch
        inc     EBX
        jmp     repeat1   
done:
        nwln          
        .EXIT

;------------------------------------------------------------
; Put character procedure receives the character in AL.
;------------------------------------------------------------
putch:
      pusha
      mov    [temp_char],AL
      mov    EAX,4            ; 4 = write
      mov    EBX,1            ; 1 = std output (display)
      mov    ECX,temp_char    ; pointer to char buffer
      mov    EDX,1            ; # bytes = 1
      int    0x80
      popa
      ret

;------------------------------------------------------------
; Get string procedure receives input buffer pointer in EDI
; and the buffer size in ESI.
;------------------------------------------------------------
getstr:
      pusha
      pushf
      mov    EAX,3            ; file read service
      mov    EBX,0            ; 0 = std input (keyboard)
      mov    ECX,EDI          ; pointer to input buffer
      mov    EDX,ESI          ; input buffer size
      int    0x80
      dec    EAX
done_getstr:	
      mov    byte[EDI+EAX],0  ; append NULL character
      popf
      popa
      ret
