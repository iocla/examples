# Convert a character to ASCII                      BINCH.ASM
#
# Objective: To convert a character to its binary equivalent. 
#            The character is read as a string.
#     Input: Requests a character from keyboard.
#    Output: Outputs the ASCII value.
#
#    t0 - holds the input character
#    t1 - points to output ASCII string
#    t2 - holds the mask byte
#
###################### Data segment ##########################

      .data
ch_prompt:	
      .asciiz     "Please enter a character: \n"
out_msg:	
      .asciiz     "\nThe ASCII value is: "
newline:	
      .asciiz     "\n"
ch:	
      .space      2
ascii_string:
      .space      9

###################### Code segment ##########################

      .text
      .globl main
main:
      la    $a0,ch_prompt      # prompt user for a character
      li    $v0,4
      syscall

      la    $a0,ch             # read the input character
      li    $a1,2
      li    $v0,8
      syscall

      la    $a0,out_msg        # write output message
      li    $v0,4
      syscall

      lb    $t0,ch             # t0 holds the character
      la    $t1,ascii_string   # t1 points to output string
      li    $t2,0x80           # t2 holds the mask byte
      li    $t4,'0'
      li    $t5,'1'

loop: 
      and   $t3,$t0,$t2
      beqz  $t3,zero
      sb    $t5,($t1)           # store 1
      b     rotate
zero:
      sb    $t4,($t1)           # store 0
rotate:
      srl   $t2,$t2,1           # shift mask byte
      addu  $t1,$t1,1
      bnez  $t2,loop            # exit loop if mask byte is 0
      
      sb    $0,($t1)            # append NULL
      la    $a0,ascii_string    # output ASCII value
      li    $v0,4
      syscall

      la    $a0,newline         # output newline
      li    $v0,4
      syscall
