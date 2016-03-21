# File:		solve.asm
# Author:	Margaret Dorsey
#
# Description:	solve.asm contains the functions directly involved in the
#		backtracking algorithm.
#
# Revisions:	see gitlog.txt
#

#
# CONSTANT DEFINITIONS
#


#
# DATA BLOCK
#
	.data
	.align 2


#
# FUNCTIONS
#

	.data
	.align 2
	
	.globl 	step_back
	.globl	step_forward
	.globl 	solve

#
# Name:		solve
# 
# Description:	solve is the main loop driving the backtracking algorithm
#		it calls auxiliary functions and the stack functions until
#		a solution is found. Square values are changed in this function
#
# Arguments:	a0: pointer to board to solve
#		a1: dimension of the board
#
# Returns:	Nothing
#

solve:



#
# Name:		set_next_square
#
# Description:	Finds the next blank square in the puzzle and returns its index
#		or -1 if all the tiles are filled (and thus puzzle is complete)
#
# Arguments:	a0: pointer to board to solve
#		a1: dimension of the board
#
# Returns:	index of next blank tile or -1 if puzzle has no more blanks
#

set_next_square:


#
# Name: 	check_column
#
# Description:	Checks the nth column of the board for compliance with the rules
#		of the puzzle.
#
# Arguments:	a0: pointer to board to solve
#		a1: dimension of the board
#		a2: index of column to check
#
# Returns:	0 on no error in column, 1 on error
#

check_column:


#
# Name:		check_row
#
# Description:	Checks the nth row of the board for compliance with the rules
#		of the puzzle
#
# Arguments:	a0: pointer to board to solve
#		a1: dimension of the board
#		a2: index of column to check
#
# Returns:	0 on no error in row, 1 on error
#

check_row:


