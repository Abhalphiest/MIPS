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

#syscall
EXIT =			10

#for printing
IMPOSSIBLE_PUZZLE = 	2

#
# DATA BLOCK
#
	.data
	.align 	2


#
# FUNCTIONS
#

	.text
	.align 	2
	
	.globl 	step_back
	.globl	step_forward
	.globl 	solve
	.globl	print_predef
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
	addi	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	sw	$s4, 20($sp)

	or	$s0, $a0, $zero	#keep our args
	or	$s1, $a1, $zero
	
	ori	$s3, $zero, 1	#for comparisons and setting
	ori	$s4, $zero, 2	
	
	jal	check_board	#see if we even started correct
	beq	$v0, $zero, init_valid
	ori	$a0, $zero, IMPOSSIBLE_PUZZLE
	jal	print_predef
	ori	$v0, $zero, EXIT
	syscall			#force exit
	jal	print_predef
init_valid:
	or	$a0, $s0, $zero
	or	$a1, $s1, $zero
	jal	set_next_square	#get our next square
#solve_loop:
#	beq	$v0, $zero, solve_done
#	or	$s2, $v0, $zero	#store our new tile
#	
#	lw	$t6, 0($s2)
#	beq	$t6, $s3, set_black
#	beq	$t6, $s4, solve_step_back
#	sw	$s3, 0($s2)	#make it white
#	
#	or	$a0, $s0, $zero #check the board for correctness
#	or	$a1, $s1, $zero	
#	jal	check_board	#will be 0 if correct
#	beq	$v0, $zero, new_correct
#set_black:
#	sw	$s4, 0($s2)	#try black instead
#	or	$a0, $s0, $zero	#check for correctness
#	or	$a1, $s1, $zero
#	jal	check_board
#	beq	$v0, $zero, new_correct
#solve_step_back:
#	sw	$zero, 0($s2)	#set to blank and step back
#	or	$a0, $s0, $zero
#	or	$a1, $s1, $zero
#	jal	step_back
#	j solve_loop
#new_correct:
#	or	$a0, $s0, $zero	#we changed a tile
#	or	$a1, $s1, $zero
#	or	$a2, $s2, $zero
#	jal	step_forward
#
#	or	$a0, $s0, $zero	#set up our args
#	or	$a1, $s1, $zero	
#	jal	set_next_square	#get our next tile
#	j	solve_loop
solve_done:
	lw 	$ra, 0($sp)	#restore stack and return
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra		
#
# Name:		set_next_square
#
# Description:	Finds the next blank square in the puzzle and returns its index
#		or 0 if all the tiles are filled (and thus puzzle is complete)
#
# Arguments:	a0: pointer to board to solve
#		a1: dimension of the board
#
# Returns:	address of next blank tile or 0  if puzzle has no more blanks
#

set_next_square:
					#no stack for leaf function

	mult	$a1, $a1		#get the boundary addr for end of array
	mflo	$t0
	sll	$t0, 2
	add	$t0, $a0, $t0
	
	or	$v0, $zero, $zero	#null ptr until we find one
next_square_loop:
	slt	$t1, $a0, $t0		#less than boundary of array
	beq	$t1, $zero, next_loop_done
	
	lw	$t2, 0($a0)		#get our tile
	bne	$t2, $zero, non_zero	#is it blank?
	or	$v0, $zero, $a0		#return our address
	jr	$ra				
non_zero:
	add	$a0, $a0, 4		#next word in array
	j	next_square_loop
next_loop_done:
	jr	$ra			#return 0, puzzle done





#
# Name:		check_board
#
# Description:	Uses check_column and check row to check the board for
#		correctness, to keep the solve function a little cleaner.
#
# Arguments	a0: pointer to board to check
#		a1: dimension of the board
#
# Returns:	0 on correct board, 1 on error
#

check_board:
	addi	$sp, $sp, -16		#set up our stack
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)

	or	$s0, $a0, $zero		#store our args
	or	$s1, $a1, $zero

	or	$s2, $zero, $zero	#loop control

check_board_loop:
	slt	$t1, $s2, $s1		#loop through our whole dimension
	beq	$t1, $zero, check_board_done

	or	$a0, $s0, $zero		#set up args for row check
	or	$a1, $s1, $zero
	or	$a2, $s2, $zero

	jal	check_row		#returns 0 for correct

	bne	$v0, $zero, check_board_false 
	
	or	$a0, $s0, $zero		#set up args for column check
	or	$a1, $s1, $zero
	or	$a2, $s2, $zero

	jal 	check_column		#returns zero for correct
	
	bne	$v0, $zero, check_board_false

	addi	$s2, $s2, 1		#increment loop counter
	j	check_board_loop	#back to top

check_board_done:
	or	$v0, $zero, $zero
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra			#return true

check_board_false:
	ori	$v0, $zero, 1
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra			#return false

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
	sll	$a2, 2			#get words	
	mult	$a1, $a1
	mflo	$t0			#get nxn or length of array
	sll	$t0, 2			#multiply by 4 for word
	add	$t0, $a0, $t0		#get end boundary of the array
	sll	$a1, 2			#for incrementing later  need words
	add	$a0, $a2, $a0		#set up at first column tile

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
	or	$t4, $t6, $zero		#update our last used color
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
	srl	$a1, 3			#to get dimension/2
	addi	$a1, $a1, 1	
	slt	$t5, $t1, $a1		#do we have too many whites?
	beq	$t5, $zero, col_return_false

	slt	$t5, $t2, $a1		#too many blacks?
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
	or	$t1, $a1, $zero
	sll	$t1, 2
	add	$t0, $a0, $t1		#get boundary of our row
	
	or	$t1, $zero, $zero	#set up our black counter
	or	$t2, $zero, $zero	#set up our white counter
	or	$t3, $zero, $zero	#set up our consecutive counter
	or	$t4, $zero, $zero	#set up our previous color for checking
					#consecutivity
	
	ori	$t7, $zero, 1		#for comparison
	ori	$t8, $zero, 2

row_loop:
	slt	$t5, $a0, $t0		#are we still in our row?
	beq	$t5, $zero, row_loop_done

	lw	$t6, 0($a0)		#get our tile
	
	beq	$t6, $t4, row_consec	#check consecutivity
	or	$t3, $zero, $zero
row_consec:
	beq	$t6,$zero, row_cmp_1	#blank tiles don't count
	addi	$t3, $t3, 1
row_cmp_1:
	or	$t4, $t6, $zero		#update our last color
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
	srl	$a1, 1			#to get dimension/2
	addi	$a1, $a1, 1
	slt	$t5, $t1, $a1		#too many whites?
	beq	$t5, $zero, row_return_false
	
	slt	$t5, $t2, $a1		#too many blacks?
	beq	$t5, $zero, row_return_false

	or	$v0, $zero, $zero
	jr	$ra			#return true
row_return_false:
	ori	$v0, $zero, 1
	jr	$ra			#return false

