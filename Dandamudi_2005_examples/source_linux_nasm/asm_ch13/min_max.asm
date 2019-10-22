# Find min and max of three numbers         MIN_MAX.ASM
#
# Objective: Finds min and max of three integers. 
#            To demonstrate register-based parameter passing.
#     Input: Requests three numbers from keyboard.
#    Output: Outputs the minimum and maximum.
#
#    a1, a2, a3 - three numbers are passed via these registers
#
###################### Data segment ##########################
      .data
prompt:	
      .asciiz     "Please enter three numbers: \n"
min_msg:	
      .asciiz     "The minimun is: "
max_msg:	
      .asciiz     "\nThe maximum is: "
newline:
      .asciiz     "\n"

###################### Code segment ##########################

      .text
      .globl main
main:
      la    $a0,prompt         # prompt user for input
      li    $v0,4
      syscall

      li    $v0,5              # read the first number into $a1
      syscall
      move  $a1,$v0

      li    $v0,5              # read the second number into $a2
      syscall
      move  $a2,$v0

      li    $v0,5              # read the third number into $a3
      syscall
      move  $a3,$v0

      jal   find_min
      move  $s0,$v0

      jal   find_max
      move  $s1,$v0

      la    $a0,min_msg        # write minimum message
      li    $v0,4
      syscall

      move  $a0,$s0            # output minimum
      li    $v0,1             
      syscall

      la    $a0,max_msg        # write maximum message
      li    $v0,4
      syscall

      move  $a0,$s1            # output maximum
      li    $v0,1             
      syscall

      la    $a0,newline        # write newline
      li    $v0,4
      syscall

      li    $v0,10             # exit
      syscall

#-----------------------------------------------------------
# FIND_MIN receives three integers in $a0, $a1, and $a2 and
# returns the minimum of the three in $v0
#-----------------------------------------------------------
find_min:
      move  $v0,$a1
      ble   $v0,$a2,min_skip_a2
      move  $v0,$a2
min_skip_a2:
      ble   $v0,$a3,min_skip_a3
      move  $v0,$a3
min_skip_a3:
      jr    $ra

#-----------------------------------------------------------
# FIND_MAX receives three integers in $a0, $a1, and $a2 and
# returns the maximum of the three in $v0
#-----------------------------------------------------------
find_max:
      move  $v0,$a1
      bge   $v0,$a2,max_skip_a2
      move  $v0,$a2
max_skip_a2:
      bge   $v0,$a3,max_skip_a3
      move  $v0,$a3
max_skip_a3:
      jr    $ra
