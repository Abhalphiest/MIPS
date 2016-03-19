# File: 	print.asm
# Author: 	Margaret Dorsey
#
# Description:	Handles all console output, including the preformatted banners
#		and the printing of both the initial board and the solution
#
# Revisions:	See gitlog.txt
#

#
# CONSTANT DEFINITIONS
#

#syscalls
PRINT_STRING = 		4
EXIT = 			10

#print lookup table, we don't actually use these here
#but it's nice to have as a reference within the file
INVALID_BOARD_SIZE = 	0
INVALID_INPUT_VALUE=	1
IMPOSSIBLE_PUZZLE =	2
PROGRAM_BANNER =	3
INITIAL_PUZZLE =	4
FINAL_PUZZLE =		5
NEWLINE =		6

#ASCII character codes 
CORNER =		43	#plus sign
HORIZONTAL_BAR = 	45	#edge of board
VERT_BAR =		124	#edge of board
BLANK =			46	#period
BLACK =			35	#octothorpe or pound sign
WHITE =			32	#space


#
# DATA BLOCK
#
	.data
	.align 2

invalid_board_size:
	.asciiz "Invalid board size, 3-In-A-Row terminating\n"
illegal_input_value:
	.asciiz "Illegal input value, 3-In-A-Row terminating\n"
newline:
	.asciiz "\n"
program_banner:
	.ascii 	"******************\n"
	.ascii 	"**  3-In-A-Row  **\n"
	.asciiz "******************\n\n"

initial_puzzle:
	.asciiz "Initial Puzzle\n\n"
final_puzzle:
	.asciiz "Final Puzzle\n\n"
impossible_puzzle:
	.asciiz "Impossible Puzzle\n\n"
	.align 2

predef_tbl:		#for print lookup table
	.word invalid_board_size
	.word illegal_input_value
	.word impossible_puzzle
	.word program_banner
	.word initial_puzzle
	.word final_puzzle
	.word newline

	.text

#
# TEXT
#

	.globl print_predef	#other files will need to print
#
# Name: print_predef
#
# Description: 	Prints the appropriate predefined message based on the argument
#		passed in. Uses the switch statement from above.
# 
# Arguments:	$a0 is an int in the range 0 to 6 indicating which message
#		to print.
# 
# Returns:	Nothing
#
print_predef:
	addi	$sp, $sp, -4	#store our ra and a single s register
	sw	$ra, 0($sp)

	la	$t0, predef_tbl	#get our table of things to print
	sll	$a0, 2		#multiply by 4 for word
	add	$t0, $t0, $a0	#get ptr to correct mem with stored str
	lw	$a0, 0($t0)	#address of our string
	li	$v0, PRINT_STRING
	syscall			#print it
	
	lw 	$ra, 0($sp)	#restore stack
	addi	$sp, $sp, 4
	jr	$ra		#return

	.globl print_board

#
# Name: print_board
# 
# Description:	Prints out the board currently stored at board_arr in line with
#		output requirements. Appends a newline after.
#
# Arguments:	$a0: ptr to board
#		$a1: dimension of board
#
# Returns:	Nothing
#
print_board:

	



