# File: three_in_row.asm
# Author: Margaret Dorsey
#
# Description:
#
#
#
# Revisions: see gitlog.txt
#


#
# CONSTANT DEFINITIONS
#

# syscalls
PRINT_STRING =	4
READ_INT = 	5
EXIT =		10

	.globl main		#entry point for program
	.globl board_arr	#our board array
	.globl dimension	#the dimension of our board

	.data
	.align 2
board_arr:
	.space 400		#the maximum size we would need for our
				#board, 10x10x4 bytes
dimension:
	.word 0			#will hold the dimension of the board


	.text
	.align 2	
#
# Name: main
#
# Description:	Handles input, then calls appropriate functions for the 
# 		continuation of the program, and terminates.
#
#		The program itself takes an nxn 3 in a row puzzle and
#		solves it.
#
#

main:
	addi	$sp, $sp, -8 	#make space for return address
	sw	$ra, 0($sp)	
	sw	$s0, 4($sp)
	
	li	$v0, READ_INT	#get the dimension
	syscall

	or	$s0, $v0, $zero	#check value	

	and	$t0, $t0, $zero	#set our loop control variable to 0
board_loop:
	beq	$t0, $v0, board_loop_done
	
	
board_loop_done:




#
# Name: enter_square_value
#
# Description: 	Validates a read in value for a square (i.e. it is 0, 1, or 2)
#		and then enters it in to the allocated array for our board.
#
# Arguments:	$a0 is pointer to next array element
#		$a1 is read number
#
# Returns: 	nothing
#

enter_square_value:


#
# Name: error
#
# Description: 	Prints an error message to the screen, cleans up memory,
#		then exits.
#
# Arguments:	$a0 is the address of the error message to print
#
# Returns:	nothing
#

error:
	
