# In this lab, the user enters a number and an ASCII diamond of asterisks embedded in numbers whose size depends on the user-inputted "height" is generated
# INSTRUCTIONS: Open AsteriskDiamond.asm in MARS 4.5 and run it. Enter a valid number to generate your diamond.

.data  # Messages displayed to user
prompt: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
errormessage: .asciiz "Invalid Entry!\n"
	
.text 
main:

la $a0, prompt                 # Ask for height
jal PrintString

li $v0, 5                      # Get height from user
syscall
move $s0, $v0                  # Initialize $s0 with the height given by user
blez $s0, DisplayErrorMessage  # If height is less than or equal to 0,
li $a0, '\n'                   # jumps to DisplayErrorMessage label
jal PrintCharacter

li $s1, 1              # Initialize $s1 with number of integers to print
li $s2, 1              # Initialize $s2 with integer
subi $s3,$s0, 1        
add $s3, $s3, $s3      # Initialize $s3 with number of asterisks to print

addi $t0, $zero, 0     # Initialize $t0 as the counter for BigLoop
addi $t1, $zero, 0     # Initialize $t1 as the counter for the smaller loops

BigLoop:
bge $t0, $s0, ExitProgram # If the counter is equal to height, exit 

ForwardIntegers:
bge $t1, $s1, ExitForwardIntegers # If counter equal to number of integers, exit
la $a0,($s2)
jal PrintInteger    # Print integer
li $a0, '\t'        
jal PrintCharacter  # Print tab
addi $s2, $s2, 1    # Increment $s2
addi $t1, $t1, 1    # Increment $t1
j ForwardIntegers   # Loop
ExitForwardIntegers:
addi $t1, $zero, 0  # Set counter back to 0

Asterisks:
bge $t1, $s3, ExitAsterisks # If counter equal to number of asterisks, exit
li $a0, '*'
jal PrintCharacter  # Print asterisk
li $a0, '\t'
jal PrintCharacter  # Print tab
addi $t1, $t1, 1    # Increment $t1
j Asterisks         # Loop
ExitAsterisks:
addi $t1, $zero, 0  # Set counter back to 0

BackwardIntegers:
bge $t1, $s1, ExitBackwardIntegers # If counter equal to number of integers, exit
subi $t2, $s2, 1 
la $a0,($t2)
jal PrintInteger         # Print integer
subi $t3, $s1, 1
beq $t1, $t3, continue   # If integer is last integer, skip printing a tab
li $a0, '\t'
jal PrintCharacter       # Print tab
continue:
subi $s2, $s2, 1         # Decrement $s2
addi $t1, $t1, 1         # Increment $t1
j BackwardIntegers       # Loop
ExitBackwardIntegers:
addi $t1, $zero, 0       # Set counter back to 0

addi $t0, $t0, 1   # Increment $t0
addi $s1, $s1, 1   # Increment $s1
subi $s4, $s1, 1   
add $s2, $s2, $s4  # Add the number to the number of integers - 1
subi $s3, $s3, 2   # Subtract $s3 by 2

li $a0, '\n'
jal PrintCharacter # New line

j BigLoop # Loop back 

ExitProgram: # Exit program
li $v0, 10
syscall

DisplayErrorMessage: # Displays error message and asks for a height again
li $v0, 4
la $a0, errormessage
syscall
j main

PrintInteger: # Helps to print integers
li $v0, 1
syscall
jr $ra
PrintCharacter: # Helps to print characters
li $v0, 11
syscall
jr $ra
PrintString: # Helps to print strings
li $v0, 4
syscall
jr $ra
