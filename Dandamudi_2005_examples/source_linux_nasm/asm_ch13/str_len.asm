# Finds string length                            STR_LEN.ASM
#
# Objective: Finds length of a string. 
#            To demonstrate register-based pointer passing.
#     Input: Requests a string from keyboard.
#    Output: Outputs the string length.
#
#    a0 - string pointer
#    v0 - procedure returns string length
#
###################### Data segment ##########################
      .data
prompt:	
      .asciiz     "Please enter a string: \n"
out_msg:	
      .asciiz     "\nString length is: "
newline:
      .asciiz     "\n"
in_string:
      .space      31

###################### Code segment ##########################

      .text
      .globl main
main:
      la    $a0,prompt         # prompt user for input
      li    $v0,4
      syscall

      la    $a0,in_string      # read input string
      li    $a1,31             # buffer length in $a1
      li    $v0,8
      syscall

      la    $a0,in_string      # call string length proc.
      jal   string_len
      move  $t0,$v0            # string length in $v0

      la    $a0,out_msg        # write output message
      li    $v0,4
      syscall

      move  $a0,$t0            # output string length
      li    $v0,1             
      syscall

      la    $a0,newline        # write newline
      li    $v0,4
      syscall

      li    $v0,10             # exit
      syscall

#-----------------------------------------------------------
# STRING_LEN receives a pointer to a string in $a0 and
# returns the string length in $v0
#-----------------------------------------------------------
string_len:
      li    $v0,0              # init $v0 (string length)
loop:
      lb    $t0,($a0)
      beq   $t0,0xA,done       # if CR 
      beqz  $t0,done           # or NULL, we are done 
      addu  $a0,$a0,1
      addu  $v0,$v0,1
      b     loop
done:
      jr    $ra
