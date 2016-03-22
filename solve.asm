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

	.text
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
					#no stack for leaf function
	
	add	$a0, $a2, $a0		#set up at our first tile to check
	mult	$a1, $a1
	mflo	$t0			#get nxn or length of array
	sll	$t0, 2			#multiply by 4 for bytes
	add	$t0, $a0, $t0		#get end boundary of the array

	or	$t1, $zero, $zero	#set up our black counter
	or	$t2, $zero, $zero	#set up our white counter
	or	$t3, $zero, $zero	#set up our consecutive counter
	ori	$t4, $zero, -1		#set up our previous color for
					#checking consecutivity

	ori	$t7, $zero, 1		#for comparison
	ori	$t8, $zero, 2		

col_loop:
	slt	$t5, $a0, $t0		#are we still on the board?
	beq	$t5, $zero, col_loop_done
	
	lw	$t6, 0($a0)		#get our tile

	beq	$t6, $t4, col_consec	#check for consecutivity
	or	$t3, $zero, $zero
col_consec:
	beq	$t6, $zero, col_cmp_1	#blank tiles don't count
	addi	$t3, $t3, 1
col_cmp_1:
	bne	$t6, $t7, col_cmp_2	#is it white?
	addi	$t1, $t1, 1
	j	col_next
col_cmp_2:
	bne	$t6, $t8, col_next	#is it black?
	addi	$t2, $t2, 1
col_next:
	slti	$t5, $t3, 3		#do we have 3 in a row?
	beq	$t5, $zero, col_return_false
	add	$a0, $a0, $a1		#go to same column in next row
	j 	col_loop		#back to top of loop
col_loop_done:	
	slti	$t5, $t1, 4		#do we have too many whites?
	beq	$t5, $zero, col_return_false

	slti	$t5, $t2, 4		#too many blacks?
	beq	$t5, $zero, col_return_false
	
	or	$v0, $zero, $zero	
	jr 	$ra			#return	true
col_return_false:
	ori	$v0, $zero, 1
	jr	$ra			#return false

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

					#no stack for leaf function
	mult	$a1, $a2		#get a ptr to the beginning of our row
	mflo	$t0
	sll	$t0, 2			#bytes
	add	$a0, $t0, $a0	
	
	add	$t0, $t0, $a1		#get boundary of our row
	
	or	$t1, $zero, $zero	#set up our black counter
	or	$t2, $zero, $zero	#set up our white counter
	or	$t3, $zero, $zero	#set up our consecutive counter
	ori	$t4, $zero, -1		#set up our previous color for checking
					#consecutivity
	
	ori	$t7, $zero, 1		#for comparison
	ori	$t8, $zero, 2

row_loop:
	slt	$t5, $a0, $t0		#are we still in our row?
	beq	$t5, $zero, row_loop_done

	lw	$t6, 0($a0)		#get our tile
	
	beq	$t6, $zero, row_consec	#check consecutivity
	or	$t3, $zero, $zero
row_consec:
	beq	$t6,$zero, row_cmp_1	#blank tiles don't count
	addi	$t3, $t3, 1
row_cmp_1:
	bne	$t6, $t7, row_cmp_2	#is it white?
	addi	$t1, $t1, 1
	j	row_next
row_cmp_2:
	bne	$t6, $t8, row_next	#is it black?
	addi	$t2, $t2, 1
row_next:
	slti	$t5, $t3, 3		#do we have 3 in a row?
	beq	$t5, $zero, row_return_false
	add	$a0, $a0, 4		#next element in row
	j	row_loop
row_loop_done:
	slti	$t5, $t1, 4		#too many whites?
	beq	$t5, $zero, row_return_false
	
	slti	$t5, $t2, 4		#too many blacks?
	beq	$t5, $zero, row_return_false

	or	$v0, $zero, $zero
	jr	$ra			#return true
row_return_false:
	ori	$v0, $zero, 1
	jr	$ra			#return false
