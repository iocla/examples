# Add individual digits of a number           ADDIGITS.ASM
#
# Objective: To add individual digits of an integer. 
#            The number is read as a string.
#     Input: Requests a number from keyboard.
#    Output: Outputs the sum.
#
#    t0 - points to character string (i.e., input number)
#    t1 - holds a digit for processing
#    t2 - maintains the running total
#
###################### Data segment ##########################

      .data
number_prompt:	
      .asciiz     "Please enter a number (<11 digits): \n"
out_msg:	
      .asciiz     "The sum of individual digits is: "
number:	
      .space      12

###################### Code segment ##########################

      .text
      .globl main
main:
      la    $a0,number_prompt  # prompt user for input
      li    $v0,4
      syscall

      la    $a0,number         # read the input number
      li    $a1,12
      li    $v0,8
      syscall

      la    $a0,out_msg        # write output message
      li    $v0,4
      syscall

      la    $t0,number         # pointer to number
      li    $t2,0              # init sum to zero
loop: 
      lb    $t1,($t0)
      beq   $t1,0xA,exit_loop  # if CR, we are done, or
      beqz  $t1,exit_loop      # if NULL, we are done
      and   $t1,$t1,0x0F       # strip off upper 4 bits
      addu  $t2,$t2,$t1        # add to running total

      addu  $t0,$t0,1          # increment pointer 
      j     loop
exit_loop:
      move  $a0,$t2            # output sum
      li    $v0,1
      syscall
