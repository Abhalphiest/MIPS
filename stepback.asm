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


#
# DATA BLOCK
#

	.data
	.align 2
sqr_stack:
	.space 400	#100 tiles is the maximum amount we'd ever need
			#stack will store index of tile in main board array

stack_ptr:
	.word sqr_stack	#keep track of where the top of our stack is

#
# FUNCTIONS
#
	.data
	.align 2
	.globl stepback


#
# Name: 	step_back
#
# Description:	sets the most recently altered square as blank, and then
#		steps back to the previous square and returns its index. If
#		we try to step back past the start of the puzzle, impossible
#		puzzle is triggered from here.
#
# Arguments:	a0: ptr to our board array
#		a1: dimension of board
#
# Returns:	The index of the square we stepped back to in the board 
#		array.
#

step_back:


	.globl step_forward

#
# Name: 	step_forward
#
# Description: 	pushes the tile we're about to change onto the stack.
#
# Arguments: 	a0: ptr to our board
#		a1: the dimension of the board
#		a2: the index of the square we're setting in the board array
#
# Returns: 	Nothing
#

step_forward:
