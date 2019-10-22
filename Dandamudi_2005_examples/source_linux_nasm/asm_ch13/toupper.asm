# Uppercase conversion of characters    TOUPPER.ASM
#
# Objective: To convert lowercase letters to 
#            corresponding uppercase letters.
#     Input: Requests a character string from keyboard.
#    Output: Prints the input string in uppercase.
#
#	t0 - points to character string
#	t1 - used for character conversion
#
################### Data segment #####################

      .data
name_prompt:	
      .asciiz     "Please type your name: \n"
out_msg:	
      .asciiz     "Your name in capitals is: "
in_name:	
      .space      31

################### Code segment #####################

      .text
      .globl main
main:
      la    $a0,name_prompt  # prompt user for input
      li    $v0,4
      syscall

      la    $a0,in_name      # read user input string
      li    $a1,31
      li    $v0,8
      syscall

      la    $a0,out_msg      # write output message
      li    $v0,4
      syscall

      la    $t0,in_name
loop:
      lb    $t1,($t0)
      beqz  $t1,exit_loop    # if NULL, we are done
      blt   $t1,'a',no_change
      bgt   $t1,'z',no_change
      addu  $t1,$t1,-32      # convert to uppercase
                             # 'A'-'a' = -32
no_change:
      sb    $t1,($t0)
      addu  $t0,$t0,1        # increment pointer 
      j     loop
exit_loop:
      la    $a0,in_name
      li    $v0,4
      syscall
