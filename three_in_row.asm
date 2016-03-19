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
READ_INT = 		5
EXIT =			10

#PRINT SWITCH LITERALS
INVALID_BOARD_SIZE =	0
INVALID_INPUT_VALUE =	1
IMPOSSIBLE_PUZZLE =	2
PROGRAM_BANNER =	3
INITIAL_PUZZLE =	4
FINAL_PUZZLE =		5
NEWLINE	=		6

#
# DATA BLOCK AND GLOBALS
#
	.globl main		#entry point for program
	.globl print_predef	#for printing

	.data
	.align 2
board_arr:
	.space 400		#the maximum size we would need for our
				#board, 10x10x4 bytes


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
	addi	$sp, $sp, -12 		#make space for return address
	sw	$ra, 0($sp)	
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	
	li	$v0, READ_INT		#get the dimension
	syscall

	or	$s0, $v0, $zero		#check value for evenness
	andi	$t0, $s0, 1		#will be 0 if even, 1 if odd
	beq	$t0, $zero, even
	li	$a0, INVALID_BOARD_SIZE
	jal	print_predef		#print out our error message
	j	main_done		#get out of the program
even:
	slti	$t0, $s0, 2		#less than 2
	slti	$t1, $s0, 11		#less than 11
	add	$t1, $t0, $t1		#if less than 2, will be 2
					#if greater than 10 will be 0
					#if in range will be 1
	li	$t0, 1
	beq	$t1, $t0, dim_valid	#break on within range
	li 	$a0, INVALID_BOARD_SIZE	#print our error message
	jal	print_predef
	j	main_done
dim_valid:	
	and	$t0, $t0, $zero		#set our loop control variable to 0
	la	$s1, board_arr		#get our memory for the board array
board_loop:
#	beq	$t0, $v0, board_loop_done
	

#	j	board_loop		#back to top
board_loop_done:

main_done:
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)		#restore stack
	lw	$ra, 0($sp)
	addi	$sp, $sp, 12	
	jr	$ra			#return
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


	
