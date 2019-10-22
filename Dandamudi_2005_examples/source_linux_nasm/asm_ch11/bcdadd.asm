;Addition of integers in packed BCD form   BCDADD.ASM
;
;        Objective: To demonstrate addition of two integers
;                   in the packed BCD representation.
;            Input: None.
;          Output: Displays the sum.

%define SUM_LENGTH    10

%include "io.mac"

.DATA
sum_msg   db  'The sum is: ',0
number1   db  12H,34H,56H,78H,90H
number2   db  10H,98H,76H,54H,32H
ASCIIsum  db  '          ',0    ; add NULL char. 

.UDATA
BCDsum    resb   5

.CODE
      .STARTUP
      mov     ESI,4
      mov     ECX,5             ; loop iteration count
      clc                       ; clear carry (we use ADC)
add_loop: 
      mov     AL,[number1+ESI]
      adc     AL,[number2+ESI]
      daa                       ; ASCII adjust
      mov     [BCDsum+ESI],AL   ; store the sum byte
      dec     ESI               ; update index
      loop    add_loop
      call    ASCII_convert
      PutStr  sum_msg           ; display sum
      PutStr  ASCIIsum
nwln
      .EXIT

;-----------------------------------------------------------
; Converts the packed decimal number (5 digits) in BCDsum 
; to ASCII represenation and stores it in ASCIIsum.
; All registers are preserved.
;-----------------------------------------------------------
ASCII_convert:
      pushad                    ; save registers
      ; ESI is used as index into ASCIIsum
      mov     ESI,SUM_LENGTH-1
      ; EDI is used as index into BCDsum
      mov     EDI,4
      mov     ECX,5             ; loop count (# of BCD digits)
cnv_loop:
      mov     AL,[BCDsum+EDI]   ; AL = BCD digit
      mov     AH,AL             ; save the BCD digit
      ; convert right digit to ASCII & store in ASCIIsum
      and     AL,0FH         
      or      AL,30H
      mov     [ASCIIsum+ESI],AL
      dec     ESI
      mov     AL,AH             ; restore the BCD digit
      ; convert left digit to ASCII & store in ASCIIsum
      shr     AL,4              ; right-shift by 4 positions
      or      AL,30H
      mov     [ASCIIsum+ESI],AL
      dec     ESI
      dec     EDI               ; update EDI
      loop    cnv_loop
      popad                     ; restore registers
      ret