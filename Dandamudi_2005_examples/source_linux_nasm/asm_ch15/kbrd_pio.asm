;Keyboard programmed I/O program      KBRD_PIO.ASM
;
;        Objective: To demonstrate programmed I/O using keyboard.
;            Input: Key strokes from the keyboard. 
;                   ESC key terminates the program.
;           Output: Displays the key on the screen.

ESC_KEY      EQU  1BH   ; ASCII code for ESC key
KB_DATA      EQU  60H   ; 8255 port PA

%include "io.mac"
.STACK 100H
.DATA
prompt_msg     db  "Press a key. ESC key terminates the program.",0
; lowercase scan code to ASCII conversion table.
; ASCII code 0 is used for scan codes in which we are not interested.
lcase_table    db  01BH,"1234567890-=",08H,09H
               db  "qwertyuiop[]",0DH,0
               db  "asdfghjkl;",27H,60H,0,'\'
               db  "zxcvbnm,./",0,'*',0,' ',0
               db  0,0,0,0,0,0,0,0,0,0
               db  0,0,0,0,0,0,0,0,0,0
               db  0,0,0,0,0,0,0,0,0,0

.CODE
        .STARTUP        
        PutStr  prompt_msg
        nwln
        ;clear keyboard status
        in      AL,KB_DATA    ; read keyboard status
        or      AL,80H        ; set PA7 = 1
        out     KB_DATA,AL

key_up_loop:
        ; Loops until a key is pressed i.e., until PA7 = 0.
        ; PA7 = 1 if a key is up.
        in      AL,KB_DATA   ; read keyboard status & scan code
        test    AL,80H       ; PA7 = 0?
        jnz     key_up_loop  ; if not, loop back
        and     AL,7FH       ; isolate the scan code
        mov     BX,lcase_table 
        dec     AL           ; index is one less than scan code
        xlat
        mov     DL,AL        ; save ASCII to test for ESC key later
        cmp     AL,0         ; ASCII code of 0 => uninterested key
        je      key_down_loop
        cmp     AL,ESC_KEY
        je      key_down_loop
display_ch:
        PutCh   AL
        PutCh   ' '

key_down_loop:
        in      AL,KB_DATA    ; read keyboard status & scan code
        test    AL,80H        ; PA7 = 1?
        jz      key_down_loop ; if not, loop back

        ; clear keyboard buffer
        mov     AX,0C00H
        int     21H

        cmp     DL,ESC_KEY    ; ESC key---terminate program
        jne     key_up_loop

        .EXIT
