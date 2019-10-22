;   A file copy program                             file_copy.asm
;
;         Objective: To copy a file using the int 0x80 services.
;             Input: Requests names of the input and output files.
;            Output: Creates a new output file and copies contents 
;                    of the input file.
	
%include "io.mac"

%define   BUF_SIZE   256
	
.DATA
in_fn_prompt     db  'Please enter the input file name: ',0
out_fn_prompt    db  'Please enter the output file name: ',0
in_file_err_msg  db  'Input file open error.',0
out_file_err_msg db  'Cannot create output file.',0

.UDATA
in_file_name     resb  30
out_file_name    resb  30
fd_in            resd  1
fd_out           resd  1
in_buf           resb  BUF_SIZE

.CODE
        .STARTUP
        PutStr  in_fn_prompt     ; request input file name
        GetStr  in_file_name,30  ; read input file name

        PutStr  out_fn_prompt    ; request output file name
        GetStr  out_file_name,30 ; read output file name

        ;open the input file
        mov     EAX,5            ; file open
        mov     EBX,in_file_name ; pointer to input file name
        mov     ECX,0            ; file access bits (0 = read only)
        mov     EDX,0700         ; file permissions
        int     0x80
        mov     [fd_in],EAX      ; store fd for use in read routine

        cmp     EAX,0            ; open error if fd < 0
        jge     create_file
        PutStr  in_file_err_msg
        nwln
        jmp     done

create_file:
       ;create output file
        mov     EAX,8            ; file create
        mov     EBX,out_file_name; pointer to output file name
        mov     ECX,0700         ; read/write/exe by owner only
        int     0x80
        mov     [fd_out],EAX     ; store fd for use in write routine

        cmp     EAX,0            ; create error if fd < 0
        jge     repeat_read
        PutStr  out_file_err_msg
        nwln
        jmp     close_exit       ; close the input file & exit

repeat_read:
        ; read input file
        mov     EAX,3            ; file read
        mov     EBX,[fd_in]      ; file descriptor
        mov     ECX,in_buf       ; input buffer
        mov     EDX,BUF_SIZE     ; size
        int     0x80

        ; write to output file
        mov     EDX,EAX          ; byte count
        mov     EAX,4            ; file write
        mov     EBX,[fd_out]     ; file descriptor
        mov     ECX,in_buf       ; input buffer
        int     0x80

        cmp     EDX,BUF_SIZE     ; EDX = # bytes read 
        jl      copy_done        ; EDX < BUF_SIZE
                                 ; indicates end-of-file
        jmp     repeat_read
copy_done:
        mov     EAX,6            ; close output file
        mov     EBX,[fd_out]
close_exit:
        mov     EAX,6            ; close input file
        mov     EBX,[fd_in]
done:
        .EXIT