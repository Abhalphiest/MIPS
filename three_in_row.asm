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
	.globl print_board
	.globl solve

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
	addi	$sp, $sp, -16 		#make space for return address
	sw	$ra, 0($sp)	
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	ori	$v0, $zero, READ_INT	#get the dimension
	syscall

	or	$s0, $v0, $zero		#check value for evenness
	andi	$t0, $s0, 1		#will be 0 if even, 1 if odd
	beq	$t0, $zero, even
	ori	$a0, $zero, INVALID_BOARD_SIZE
	jal	print_predef		#print out our error message
	j	main_done		#get out of the program
even:
	slti	$t0, $s0, 2		#less than 2
	slti	$t1, $s0, 11		#less than 11
	add	$t1, $t0, $t1		#if less than 2, will be 2
					#if greater than 10 will be 0
					#if in range will be 1

	xori	$t1, $t1, 1		#if in range will be 0
	beq	$t1, $zero, dim_valid	#break on within range
	ori 	$a0, $zero, INVALID_BOARD_SIZE	
	jal	print_predef		#print our error message
	j	main_done
dim_valid:	
	and	$s2, $t0, $zero		#set our loop control variable to 0
	la	$a0, board_arr		#get our memory for the board array
	mult	$s0, $s0
	mflo	$s1			#s1 is now n^2
	
board_loop:
	beq	$s2, $s1, board_loop_done
	ori	$v0, $zero, READ_INT	#get our next square
	syscall	
	or	$a1, $zero, $v0		#get ready to pass it to be checked
	jal	enter_square_value
	addi	$s2, $s2, 1
	addi	$a0, $a0, 4		#integer is a byte
	j	board_loop		#back to top
board_loop_done:




	ori	$a0, $zero, PROGRAM_BANNER	#print our banner
	jal	print_predef


	ori	$a0, $zero, INITIAL_PUZZLE	#print header
	jal	print_predef
					# print board
	la	$a0, board_arr
	or	$a1, $s0, $zero		#load args for board printing
	jal	print_board
	
	la	$a0, board_arr		#solve
	or	$a1, $s1, $zero
	jal	solve

						
					#solution is over, so output
	ori	$a0, $zero, FINAL_PUZZLE
	jal	print_predef		

	la 	$a0, board_arr
	or	$a1, $s0, $zero
	jal	print_board

main_done:
	lw	$s2, 12($sp)
	lw	$s1, 8($sp)
	lw	$s0, 4($sp)		#restore stack
	lw	$ra, 0($sp)
	addi	$sp, $sp, 16	
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
	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)		#main will want this to persist

	slt	$t0, $a1, $zero		#check if below zero
	slti	$t1, $a1, 3		#check if below 3
	add	$t1, $t1, $t0		#will be 1 if within range, else 0 or 2
	xori	$t1, $t1, 1		#will be 0 if within range, else 1 or 2
	
	beq	$t1, $zero, valid	#break on valid
	ori	$a0, $zero, INVALID_INPUT_VALUE
	jal	print_predef		#give error message
	ori	$v0, $zero, EXIT
	syscall				#forcibly exit the program
valid:
	sw	$a1, 0($a0)		#a0 will have never been touched
					#if we get this far
	
	lw	$a0, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 8
	jr	$ra



