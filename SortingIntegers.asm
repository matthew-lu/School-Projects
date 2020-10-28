# This program takes user-inputted hexadecimal numbers, converts them to
# decimal, and sorts them; printing each result.
# INSTRUCTIONS: Open SortingIntegers.asm in MARS 4.5 and run it. Enter a
# valid hexidecimal number.


.data # Array and messages displayed to user

intarray: .space 32

proargmsg: .asciiz "Program arguments:\n"
intvalmsg: .asciiz "Integer values:\n"
sortedmsg: .asciiz "Sorted values:\n"

.text
main:

la $s0, ($a0)          # Load number of arguments into $s0
la $s1, ($a1)          # Load address of program arguments into $s1
subi $s7, $s0, 1       # Number of arguments - 1 = length of array - 1
la $a0, proargmsg      # Print "program arguments"
jal PrintString
li $t0, 1              # Initialize counter to 1

ArgumentLoop:
FirstArg:
lw $a0, ($a1)          # Print first argument                  
jal PrintString
li $a0, ' '            # Print space
jal PrintCharacter   
OtherArgs:
beq $t0, $s0, ExitArgumentLoop  # If counter equals number of arguments, end
add $a1, $a1, 4                 # Increment $a1 by 4 to get addresses of other arguments
lw $a0 ($a1)                    # Print argument
jal PrintString
beq $t0, $s7, Continue1         # If last argument, don't print the space after
li $a0, ' '
jal PrintCharacter
Continue1:
addi $t0, $t0, 1    # Increment counter
j OtherArgs         # Loop back
ExitArgumentLoop:
addi $t0, $zero, 0  # Set counter to 0
la $a1, intarray    # Reload address of program arguments
li $a0, '\n'        # New line
jal PrintCharacter
la $a0, intvalmsg   # Print "integer values"
jal PrintString


IntegerLoop:
beq $t0, $s0, ExitIntegerLoop     # If counter equals number of arguments, exit
lw $a0 ($s1)                      # Load address of argument
addi $a0, $a0, 2                  # Increment $a0 by 2
lb $t1, ($a0)                     # Load last half of argument
addi $t2, $zero, 0                # Initialize $t2
HextoDecimal:
beq $t1, $zero, HextoDecimalExit  # If the program runs out of bytes to look at, end
ble $t1, 0x39, Next               # If the byte is not a letter, skip
Letter:
subi $t1, $t1, 7                  # Subtract $t1 by 7 to make up for places 
Next:                              # separating integers and letters
subi $t1, $t1, 48                 # Subtract by 48 to get integer values from ASCII values
sll $t2, $t2, 4                   # Get decimal number 
add $t2, $t2, $t1                 
addi $a0, $a0, 1                  # Increment $a0
lb $t1, ($a0)                     # Load next byte
j HextoDecimal
HextoDecimalExit:
sw $t2, ($a1)             # Store new decimal number into array
addi $a1, $a1, 4          # Increment $a1 by 4
la $a0, ($t2)             # Print number
jal PrintInteger          
beq $t0, $s7, Continue2   # If last integer, skip
li $a0, ' '               # Print space
jal PrintCharacter
Continue2:
addi $t0, $t0, 1          # Increment counter
addi $s1, $s1, 4          # Increment $s1 by 4
j IntegerLoop
ExitIntegerLoop:
subi $s1, $s1, 12   # Reset address
li $a0, '\n'        # New line
jal PrintCharacter
la $a0, sortedmsg   # Print "sorted values"
jal PrintString


la $t0, intarray          # Load address of first integer
li $s2, 1                 # Initialize boolean variable
addi $t3, $zero, 0        # Initialize $t3 to serve as index
addi $t4, $zero, 0        # Initialize $t4 to serve as counter
SortLoop:
beq $s2, 0, ExitSortLoop  # If boolean variable = 0, end
addi $t4, $t4, 1          # Increment counter
addi $s2, $zero, 0        # Set boolean variable to 0
addi $t3, $zero, 0        # Set index to 0
sub $s3, $s0, $t4         # Subtract counter from length as last
Loop2:                    # variable will definitely be biggest
bge $t3, $s3, Exit    # If index is equal to number of arguments - number of passes, end
lw $t1, 0($t0)        # Loads first integer into $t1
lw $t2, 4($t0)        # Loads second integer into $t2
ble $t1, $t2, NoSort  # If $t1 is less than or equal to $t2, skip
sw $t1, 4($t0)        # Switch
sw $t2, 0($t0)
li $s2, 1          # Set boolean variable = 1 as a switch was made
NoSort:
addi $t3, $t3, 1   # Increment index
sll $t5, $t3, 2    # Multiply index by 4 and store in $t5
la $t0, intarray   # Reload address of first integer
add $t0, $t0, $t5  # Add $t5 to address to get address of next integer
j Loop2            # Jump back
Exit:
la $t0, intarray   # Reload address of first integer
j SortLoop         # Jump back to top to go through list of elements again
ExitSortLoop:

addi $t7, $zero, 0         # Initialize counter                 
PrintSortedLoop:
beq $t7, $s0, ExitProgram  # If counter = number of integers, end
lw $a0, ($t0)              # Print first integer
jal PrintInteger
addi $t0, $t0, 4           # Add 4 to address to get next integer
beq $t7, $s7, Continue3    # If last integer, skip
li $a0, ' '                # Print space
jal PrintCharacter
Continue3:
addi $t7, $t7, 1           # Increment counter
j PrintSortedLoop

ExitProgram: # Exit program
li $v0, 10
syscall

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
