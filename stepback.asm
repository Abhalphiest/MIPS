# File: 	stepback.asm
# Author: 	Margaret Dorsey
#
# Description:	Implements a stack structure and uses it to handle stepping 
# 		back during the backtracking algorithm
#
# Revisions: 	see gitlog.txt

#
# CONSTANT DEFINTIONS
#

#syscall
EXIT = 10

#for printing
IMPOSSIBLE_PUZZLE = 2

#
# DATA BLOCK
#

	.data
	.align 2
sqr_stack:
	.space 400	#100 tiles is the maximum amount we'd ever need
			#stack will store address of tile in board array

stack_ptr:
	.word sqr_stack	#keep track of where the top of our stack is

#
# FUNCTIONS
#
	.text
	.align 2
	.globl stepback
	.globl print_predef

#
# Name: 	step_back
#
# Description:	Pops the most recently changed tile off the top of the
#		stack and returns its address.
#		If we try to step back past the start of the puzzle, 
#		impossible puzzle is triggered from here.
#
# Arguments:	None
#		
#
# Returns:	The address of the square we stepped back to in the board 
#		array.
#

step_back:
	la	$t0, stack_ptr
	lw 	$t1, 0($t0)		#get ptr to the top of our stack
	la	$t2, sqr_stack
	slt	$t3, $t1, $t2		#if we're past the bottom of our stack
	beq	$t3, $zero, sb_ok
	ori	$a0, $zero, IMPOSSIBLE_PUZZLE
	jal	print_predef
	ori	$v0, $zero, EXIT	#exit the program after printing
	syscall		
sb_ok:
	addi	$t1, $t1, -4	#move the top of the stack down
	lw	$v0, 0($t1)	#get the top of our stack
	sw	$t1, 0($t0)
	jr	$ra
	.globl step_forward

#
# Name: 	step_forward
#
# Description: 	pushes the tile we're about to change onto the stack.
#
# Arguments: 	a0: the address of the square we're setting in the board array
#
# Returns: 	Nothing
#

step_forward:
	la	$t0, stack_ptr	#get address of stack ptr
	lw	$t1, 0($t0)	#get address of top of stack
	sw	$a0, 0($t1)	#store the new address
	addi	$t1, $t1, 4	#move the top of our stack
	sw	$t1, 0($t0)
	jr	$ra		#return
