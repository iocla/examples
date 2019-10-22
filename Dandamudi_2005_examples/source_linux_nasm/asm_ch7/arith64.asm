; Arithmetic operations on 64 bit numbers   ARITH64.ASM
;
;	Objective: To write procedures for 64 bit arithmetic.
;		     Procedures are given for addition, 
;                subtraction, multiplication, and division.
%include  "io.mac"
.CODE
global   add64, sub64, mult64, mult64w, div64
;-----------------------------------------------------------
;Adds two 64-bit numbers received in EBX:EAX and EDX:ECX.
;The result is returned in EBX:EAX. Overflow/underflow 
;conditions are indicated by setting the carry flag. 
;Other registers are not disturbed.
;-----------------------------------------------------------
add64:
      add    EAX,ECX
      adc    EBX,EDX
      ret

;-----------------------------------------------------------
;Subtracts two 64-bit signed numbers (A-B).
;A is received in EBX:EAX and B in EDX:ECX.
;The result is returned in EBX:EAX. Overflow/underflow
;conditions are indicated by setting the carry flag. 
;Other registers are not disturbed.
;-----------------------------------------------------------
sub64:
      sub    EAX,ECX
      sbb    EBX,EDX
      ret

;-----------------------------------------------------------
;Multiplies two 64-bit unsigned numbers A and B. The input
;number A is received in EBX:EAX and B in EDX:ECX registers.
;The 128-bit result is returned in EDX:ECX:EBX:EAX registers.
;This procedure uses longhand multiplication algorithm.
;Preserves all registers except EAX, EBX, ECX, and EDX.
;-----------------------------------------------------------
%define  COUNT   word[EBP-2] ; local variable 

mult64:
      enter   2,0            ; 2-byte local variable space
      push    ESI
      push    EDI
      mov     ESI,EDX        ; ESI:EDI = B
      mov     EDI,ECX
      sub     EDX,EDX        ; P = 0
      sub     ECX,ECX
      mov     COUNT,64       ; count = 64 (64-bit number)
step:
      test    EAX,1          ; LSB of A is 1?
      jz      shift1         ; if not, skip add
      add     ECX,EDI        ; Otherwise, P = P+B
      adc     EDX,ESI
shift1:                      ; shift right P and A
      rcr     EDX,1
      rcr     ECX,1
      rcr     EBX,1
      rcr     EAX,1

      dec     COUNT          ; if COUNT is not zero
      jnz     step           ;  repeat the process
      ; restore registers      
      pop     EDI
      pop     ESI
      leave                  ; clears local variable space
      ret

;-----------------------------------------------------------
;Multiplies two 64-bit unsigned numbers A and B. The input
;number A is received in EBX:EAX and B in EDX:ECX registers.
;The 64-bit result is returned in EDX:ECX:EBX:EAX registers.
;It uses mul instruction to multiply 32-bit numbers.
;Preserves all registers except EAX, EBX, ECX, and EDX.
;-----------------------------------------------------------
; local variables
%define  RESULT3  dword[EBP-4] ; most significant 32 bits of result
%define  RESULT2  dword[EBP-8]
%define  RESULT1  dword[EBP-12]
%define  RESULT0  dword[EBP-16]; least significant 32 bits of result

mult64w:
      enter   16,0           ; 16-byte local variable space for RESULT
      push    ESI
      push    EDI
      mov     EDI,EAX        ; ESI:EDI = A
      mov     ESI,EBX
      mov     EBX,EDX        ; EBX:ECX = B
      ; multiply A0 and B0
      mov     EAX,ECX
      mul     EDI
      mov     RESULT0,EAX
      mov     RESULT1,EDX
      ; multiply A1 and B0
      mov     EAX,ECX
      mul     ESI
      add     RESULT1,EAX
      adc     EDX,0
      mov     RESULT2,EDX
      sub     EAX,EAX        ; store 1 in RESULT3 if a carry
      rcl     EAX,1          ;  was generated
      mov     RESULT3,EAX
      ; multiply A0 and B1
      mov     EAX,EBX
      mul     EDI
      add     RESULT1,EAX
      adc     RESULT2,EDX
      adc     RESULT3,0
      ; multiply A1 and B1
      mov     EAX,EBX
      mul     ESI
      add     RESULT2,EAX
      adc     RESULT3,EDX
      ; copy result to the registers
      mov     EAX,RESULT0
      mov     EBX,RESULT1
      mov     ECX,RESULT2
      mov     EDX,RESULT3
      ; restore registers
      pop     EDI            
      pop     ESI
      leave                 ; clears local variable space
      ret

;-----------------------------------------------------------
;Divides two 64-bit unsigned numbers A and B (i.e., A/B).
;The number A is received in EBX:EAX and B in EDX:ECX registers.
;The 64-bit quotient is returned in EBX:EAX registers and
;the remainder is retuned in EDX:ECX registers. 
;Divide-by-zero error is indicated by setting
;the carry flag; carry flag is cleared otherwise.
;Preserves all registers except EAX, EBX, ECX, and EDX.
;-----------------------------------------------------------
; local variables
%define  SIGN       byte[EBP-1]
%define  BIT_COUNT  byte[EBP-2]
div64:
      enter   2,0            ; 2-byte local variable space
      push    ESI
      push    EDI
      ; check for zero divisor in EDX:ECX
      cmp     ECX,0
      jne     non_zero
      cmp     EDX,0
      jne     non_zero
      stc                    ; if zero, set carry flag 
      jmp     SHORT skip     ; to indicate error and return
non_zero:
      mov     ESI,EDX        ; ESI:EDI = B
      mov     EDI,ECX
      sub     EDX,EDX        ; P = 0
      sub     ECX,ECX
      mov     SIGN,0
      mov     BIT_COUNT,64   ; BIT_COUNT = # of bits 
next_pass:    ; ****** main loop iterates 64 times ******          
      test    SIGN,1         ; if P is positive
      jz      P_positive     ; jump to P_positive
P_negative:
      rcl     EAX,1          ; right-shift P and A 
      rcl     EBX,1
      rcl     ECX,1
      rcl     EDX,1
      rcl     SIGN,1
      add     ECX,EDI        ; P = P + B
      adc     EDX,ESI
      adc     SIGN,0
      jmp     test_sign
P_positive:
      rcl     EAX,1          ; right-shift P and A 
      rcl     EBX,1
      rcl     ECX,1
      rcl     EDX,1
      rcl     SIGN,1
      sub     ECX,EDI        ; P = P + B
      sbb     EDX,ESI
      sbb     SIGN,0
test_sign:
      test    SIGN,1         ; if P is negative
      jnz     bit0           ; set lower bit of A to 0
bit1:                        ; else, set it to 1
      or      AL,1
      jmp     one_pass_done  ; set lower bit of A to 0
bit0:
      and     AL,0FEH        ; set lower bit of A to 1
      jmp     one_pass_done
one_pass_done:
      dec     BIT_COUNT      ; iterate for 32 times
      jnz     next_pass
div_done:                    ; division completed
      test    SIGN,1         ; if P is positive
      jz      div_wrap_up    ; we are done
      add     ECX,EDI        ; otherwise, P = P + B
      adc     EDX,ESI
div_wrap_up:
      clc                    ; clear carry to indicate no error
skip:         
      pop     EDI            ; restore registers
      pop     ESI
      leave                  ; clears local variable space
      ret
