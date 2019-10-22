# Sum of variable number of integers         VAR_PARA.ASM
#
# Objective: Finds sum of variable number of integers. 
#            Stack is used to pass variable number of integers.
#            To demonstrate stack-based parameter passing.
#     Input: Requests integers from the user; 
#            terminated by entering a zero.
#    Output: Outputs the sum of input numbers.
#
#    a0 - number of integers passed via the stack
#
###################### Data segment ##########################
      .data
prompt:	
      .ascii     "Please enter integers. \n"
      .asciiz    "Entering zero terminates the input. \n"
sum_msg:	
      .asciiz     "The sum is: "
newline:
      .asciiz     "\n"

###################### Code segment ##########################

      .text
      .globl main
main:
      la    $a0,prompt         # prompt user for input
      li    $v0,4
      syscall

      li    $a0,0
read_more:
      li    $v0,5              # read a number
      syscall
      beqz  $v0,exit_read
      subu  $sp,$sp,4          # reserve 4 bytes on stack
      sw    $v0,($sp)          # store the number on stack
      addu  $a0,$a0,1
      b     read_more
exit_read:
      jal   sum                # sum is returned in $v0
      move  $s0,$v0

      la    $a0,sum_msg        # write output message
      li    $v0,4
      syscall

      move  $a0,$s0            # output sum
      li    $v0,1             
      syscall

      la    $a0,newline        # write newline
      li    $v0,4
      syscall

      li    $v0,10             # exit
      syscall

#-----------------------------------------------------------
# SUM receives the number of integers passed in $a0 and the
# actual numbers via the stack. It returns the sum in $v0.
#-----------------------------------------------------------
sum:
      li    $v0,0
sum_loop:
      beqz  $a0,done
      lw    $t0,($sp)
      addu  $sp,$sp,4
      addu  $v0,$v0,$t0
      subu  $a0,$a0,1
      b     sum_loop
done:
      jr    $ra
