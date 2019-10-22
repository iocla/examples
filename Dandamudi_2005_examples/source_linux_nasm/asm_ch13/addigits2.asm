# Add individual digits of a number     ADDIGITS2.ASM
#
# Objective: To add individual digits of an integer. 
#            To demonstrate DIV instruction.
#     Input: Requests a number from keyboard.
#    Output: Outputs the sum.
#
#    t0 - holds the quotient
#    t1 - holds constant 10
#    t2 - maintains the running sum
#    t3 - holds the remainder
#
################### Data segment #####################

      .data
number_prompt:	
      .asciiz 	"Please enter an integer: \n"
out_msg:	
      .asciiz 	"The sum of individual digits is: "

################### Code segment #####################

      .text
      .globl main
main:
      la    $a0,number_prompt  # prompt user for input
      li    $v0,4
      syscall

      li    $v0,5              # read the input number
      syscall                  # input number in $v0
      move  $t0,$v0
      abs   $t0,$t0            # get absolute value

      la    $a0,out_msg        # write output message
      li    $v0,4
      syscall

      li    $t1,10             # $t1 holds divisor 10
      li    $t2,0              # init sum to zero
loop:
      divu  $t0,$t1            # $t0/$t1
      # leaves quotient in LO and remainder in HI
      mflo  $t0                # move quotient to $t0
      mfhi  $t3                # move remainder to $t3
      addu  $t2,$t2,$t3        # add to running total
      beqz  $t0,exit_loop      # exit loop if quotient is 0
      j     loop
exit_loop:
      move  $a0,$t2            # output sum
      li    $v0,1
      syscall
