;Keyboard interrupt service program             KEYBOARD.ASM
;
;        Objective: To demonstrate how the keyboard works.
;            Input: Key strokes from the keyboard. Only left- and
;                   right-shift keys are recognized.
;                   ESC key restores the original keyboard ISR
;                   and terminates the program.
;           Output: Displays the key on the screen.

ESC_KEY      EQU  1BH   ; ASCII code for ESC key
CR           EQU  0DH   ; ASCII code for carriage return
KB_DATA      EQU  60H   ; 8255 port PA
KB_CTRL      EQU  61H   ; 8255 port PB
LEFT_SHIFT   EQU  2AH   ; left-shift scan code
RIGHT_SHIFT  EQU  36H   ; right-shift scan code
EOI          EQU  20H   ; end-of-interrupt byte for 8259 PIC
PIC_CMD_PORT EQU  20H   ; 8259 PIC command port

%include "io.mac"
.STACK 100H                                        
.DATA
install_msg    db  "New keyboard ISR installed.",0
keyboard_data  db  -1   ; keyboard buffer
keyboard_flag  db  0    ; keyboard shift status
; lowercase scan code to ASCII conversion table.
; ASCII code 0 is used for unnecessary scan codes.
lcase_table    db  01BH,"1234567890-=",08H,09H
               db  "qwertyuiop[]",CR,0
               db  "asdfghjkl;",27H,60H,0,'\'
               db  "zxcvbnm,./",0,'*',0,' ',0
               db  0,0,0,0,0,0,0,0,0,0
               db  0,0,0,0,0,0,0,0,0,0
               db  0,0,0,0,0,0,0,0,0,0
; uppercase scan code to ASCII conversion table.
ucase_table    db  01BH,"!@#$%^&*()_+",08H,09H
               db  "QWERTYUIOP{}",0DH,0
               db  "ASDFGHJKL:",'"','~',0,'|'
               db  "ZXCVBNM<>?",0,'*',0,' '                    
               db  0,0,0,0,0,0,0,0,0,0
               db  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.UDATA
old_offset     resw  1    ; storage for old int 09H vector
old_segment    resw  1

.CODE
        .STARTUP        
        PutStr  install_msg
        nwln

        ; save int 09H vector for later restoration
        mov     AX,3509H     ; AH = 35H and AL = 09H
        int     21H          ; DOS function 35H returns 
        mov     [old_offset],BX   ; offset in BX and
        mov     [old_segment],ES  ; segment in ES

        ;set up interrupt vector to our keyboard ISR
        push    DS           ; DS is used by function 25H
        mov     AX,CS        ; copy current segment to DS
        mov     DS,AX
        mov     DX,kbrd_ISR  ; ISR offset in DX
        mov     AX,2509H     ; AH = 25H and AL = 09H
        int     21H
        pop     DS           ; restore DS
        
repeat1:        
        call    read_kb_key  ; read a key
        cmp     AL,ESC_KEY   ; if ESC key           
        je      done         ; then done
        cmp     AL,CR        ; if carriage return
        je      newline      ; then display new line
        PutCh   AL           ; else display character
        jmp     repeat1
newline:
        nwln
        jmp     repeat1
done:
        ; restore original keyboard interrupt int 09H vector
        mov     DX,old_offset       
        push    DS
        mov     AX,old_segment
        mov     DS,AX
        mov     AX,2509H
        int     21H
        pop     DS
       
        .EXIT
;-----------------------------------------------------------
;This procedure waits until a valid key is entered at the 
; keyboard. The ASCII value of the key is returned in AL.
;-----------------------------------------------------------
.CODE
read_kb_key:
        cmp     byte [keyboard_data],-1  ; -1 is an invalid entry
        je      read_kb_key
        mov     AL,[keyboard_data]
        mov     byte [keyboard_data],-1
        ret
;-----------------------------------------------------------
;This keyboard ISR replaces the original int 09H ISR.
;-----------------------------------------------------------
.CODE
kbrd_ISR:
        sti                  ; enable interrupt
        push    AX           ; save registers used by ISR
        push    BX
        in      AL,KB_DATA   ; read keyboard scan code and the
        mov     BL,AL        ;  key status (down or released)
        ; send keyboard acknowledge signal by momentarily
        ;  setting and clearing PB7 bit
        in      AL,KB_CTRL
        mov     AH,AL
        or      AL,80H       
        out     KB_CTRL,AL   ; set PB7 bit
        xchg    AL,AH
        out     KB_CTRL,AL   ; clear PB7 bit
        
        mov     AL,BL        ; AL = scan code + key status
        and     BL,7FH       ; isolate scan code
        cmp     BL,LEFT_SHIFT   ; left- or right-shift key
        je      left_shift_key  ;  changed status?
        cmp     BL,RIGHT_SHIFT
        je      right_shift_key
        test    AL,80H          ; if not, check status bit
        jnz     EOI_to_8259     ; if key released, do nothing
        mov     AH,[keyboard_flag] ; AH = shift key status
        and     AH,1         ; AH = 1 if left/right shift is ON
        jnz     shift_key_on
        ; no shift key is pressed
        mov     BX,lcase_table ; shift OFF, use lowercase
        jmp     SHORT get_ASCII       ;  conversion table
shift_key_on:
        mov     BX,ucase_table ; shift key ON, use uppercase
get_ASCII:                            ;  conversion table
        dec     AL           ; index is one less than scan code
        xlat
        cmp     AL,0         ; ASCII code of 0 => uninterested key
        je      EOI_to_8259
        mov     [keyboard_data],AL  ; save ASCII code in keyboard buffer
        jmp     SHORT EOI_to_8259

left_shift_key:
right_shift_key:
        test    AL,80H       ; test key status bit (0=down, 1=up)
        jnz     shift_off
shift_on:
        or      byte [keyboard_flag],1     ; shift bit (i.e., LSB) := 1
        jmp     SHORT EOI_to_8259
shift_off:
        and     byte [keyboard_flag],0FEH  ; shift bit (i.e., LSB) := 0
        jmp     SHORT EOI_to_8259

EOI_to_8259:
        mov     AL,EOI              ; send EOI to 8259 PIC
        out     PIC_CMD_PORT,AL     ; indicating end of ISR
        pop     BX                  ; restore registers
        pop     AX
        iret
