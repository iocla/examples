;Addition of two integers in ASCII form   ASCIIADD.ASM
;
;        Objective: To demonstrate addition of two integers
;                   in the ASCII representation.
;            Input: None.
;           Output: Displays the sum.
%include "io.mac"

.DATA
sum_msg   db  'The sum is: ',0
number1   db  '1234567890'
number2   db  '1098765432'
sum       db  '          ',0 ; add NULL char. to use PutStr

.CODE
      .STARTUP
      ; ESI is used as index into number1, number2, and sum
      mov     ESI,9          ; ESI points to rightmost digit
      mov     ECX,10         ; iteration count (# of digits)
      clc                    ; clear carry (we use ADC not ADD)
add_loop:
      mov     AL,[number1+ESI]         
      adc     AL,[number2+ESI]
      aaa                    ; ASCII adjust
      pushf                  ; save flags because OR
      or      AL,30H         ;  changes CF that we need
      popf                   ;  in the next iteration
      mov     [sum+ESI],AL   ; store the sum byte
      dec     ESI            ; update ESI
      loop    add_loop
      PutStr  sum_msg        ; display sum
      PutStr  sum
      nwln
      .EXIT