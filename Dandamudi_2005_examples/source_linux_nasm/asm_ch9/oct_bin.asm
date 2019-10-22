;Octal-to-binary conversion using shifts   OCT_BIN.ASM
;
;        Objective: To convert an 8-bit octal number to the
;                   binary equivalent using shift instruction.
;            Input: Requests an 8-bit octal number from user.
;           Output: Prints the decimal equivalent of the input
;                   octal number.
%include "io.mac"

.DATA
input_prompt   db  'Please input an octal number: ',0
out_msg1       db  'The decimal value is: ',0
query_msg      db  'Do you want to quit (Y/N): ',0

.UDATA
octal_number   resb  4        ; to store octal number

.CODE
      .STARTUP
read_input:
      PutStr  input_prompt    ; request an octal number
      GetStr  octal_number,4  ; read input number
      mov     EBX,octal_number ; pass octal # pointer
      call    to_binary    ; returns binary value in AX
      PutStr  out_msg1
      PutInt  AX           ; display the result
      nwln
      PutStr  query_msg    ; query user whether to terminate
      GetCh   AL           ; read response
      cmp     AL,'Y'       ; if response is not 'Y'
      jne     read_input   ; read another number
done:                      ; otherwise, terminate program
      .EXIT

;-----------------------------------------------------------
; to_binary receives a pointer to an octal number string in
; EBX register and returns the binary equivalent in AL (AH is
; set to zero). Uses SHL for multiplication by 8. Preserves
; all registers, except AX.
;-----------------------------------------------------------
to_binary:
      push    EBX          ; save registers
      push    CX
      push    DX
      xor     EAX,EAX      ; result = 0
      mov     CX,3         ; max. number of octal digits
repeat1:
      ; loop iterates a maximum of 3 times;
      ; but a NULL can terminate it early
      mov     DL,[EBX]     ; read the octal digit
      cmp     DL,0         ; is it NULL?
      je      finished     ; if so, terminate loop
      and     DL,0FH       ; else, convert char. to numeric
      shl     AL,3         ; multiply by 8 and add to binary
      add     AL,DL        
      inc     EBX          ; move to next octal digit 
      dec     CX           ; and repeat
      jnz     repeat1
finished:
      pop     DX           ; restore registers
      pop     CX
      pop     EBX
      ret
