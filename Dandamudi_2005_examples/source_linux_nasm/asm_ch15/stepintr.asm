;Single-step program      STEPINTR.ASM
;
;        Objective: To demonstrate how ISRs can be defined
;                   and installed.
;            Input: None. 
;           Output: Displays AX and BX values for 
;                   the single-step code.

%include "io.mac"
.STACK 100H
.DATA
start_msg   db  "Starts single-stepping process.",0
AXequ       db  "AX = ",0
BXequ       db  " BX = ",0

.UDATA
old_offset  resw  1    ; for old ISR offset
old_seg     resw  1    ;   and segment values

.CODE
        .STARTUP        
        PutStr  start_msg
        nwln

        ; get current interrupt vector for int 1H
        mov     AX,3501H         ; AH = 35H and AL = 01H
        int     21H              ; returns the offset in BX
        mov     [old_offset],BX  ;   and the segment in ES  
        mov     [old_seg],ES

        ;set up interrupt vector to our ISR
        push    DS           ; DS is used by function 25H
        mov     AX,CS        ; copy current segment to DS
        mov     DS,AX
        mov     DX,sstep_ISR ; ISR offset in DX
        mov     AX,2501H     ; AH = 25H and AL = 1H
        int     21H
        pop     DS           ; restore DS
        
        ; set trap flag to start single-stepping
        pushf
        pop     AX           ; copy flags into AX
        or      AX,100H      ; set trap flag bit (TF = 1)
        push    AX           ; copy modified flag bits
        popf                 ;   back to flags register
        
        ; from now on int 1 is generated after executing
        ;  each instruction. Some test instructions follow.
        mov     AX,100
        mov     BX,20
        add     AX,BX
        
        ; clear trap flag to end single-stepping
        pushf
        pop     AX           ; copy flags into AX
        and     AX,0FEFFH    ; clear trap flag bit (TF = 0)
        push    AX           ; copy modified flag bits
        popf                 ;   back to flags register
        
        ; restore the original ISR
        mov     DX,[old_offset]
        push    DS
        mov     AX,[old_seg]
        mov     DS,AX
        mov     AX,2501H
        int     21H
        pop     DS
        
        .EXIT
;-----------------------------------------------------------
;Single-step interrupt service routine replaces int 01H.
;-----------------------------------------------------------
.CODE
sstep_ISR:
        sti                  ; enable interrupt
        PutStr  AXequ        ; display AX contents
        PutInt  AX
        PutStr  BXequ        ; display BX contents
        PutInt  BX
        nwln
        iret

