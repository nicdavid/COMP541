# ############################################################################# #
#										#
# 			Checkers Game 						#
#										#
# 8x8 board									#
# Top left of board starts at (11,16)						#
# Starting in data memory from starting position				#
# Each space in data memory contains:						#
# 	Space color								#
#		0 - Red								#
#		1 - White							#
#	Chip Type								#
#		0 - No chip							#
#		1 - Regular chip						#
# 		2 - Kinged Chip							#
# 	Chip's Player (Assuming there is a chip that exists)			#
# 		0 - North Player						#
# 		1 - South Player						#
#	Selected chips found by (code + 8)					#
#										#
#										#
#										#
# Chips are all going to be placed on white spaces				#
#										#
# ############################################################################# #


.data 0x10010000                # Start of data memory

.text 0x00400000                	# Start of instruction memory
.globl main


main:
    	lui $sp, 0x1001			# Initialize stack pointer to the 64th location above start of data
	ori  $sp, $sp, 0x0100		# top of the stack is the word at address [0x100100fc - 0x100100ff]
                                	#   because $sp is decremented first.
    	addi $fp, $sp, -4        	# Set $fp to the start of main's stack frame
	j initGame			# Initialize the game


exit_from_main:

    ###############################
    # END using infinite loop     #
    ###############################

                        		# program may not reach here, but have it for safety
end:
	j   end             		# infinite loop "trap" because we don't have syscalls to exit



# Initialize Board
initGame:
	add $s0, $0, $0			# Cursor Column
	add $s1, $0, $0			# Cursor Row
	addi $s2, $0, 20		# Selected Column
	addi $s3, $0, 20		# Selected Row
	add $s4, $0, $0			# Player
	j initSelector

# Handles an enter key event
checkPiece:
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal getChar_atXY
	
	addi $t3, $s4, 10		# Selected normal piece for current player
	addi $t4, $s4, 12		# Selected kinged piece for current player
	
	beq $t3, $v0, setSelected	# Set selected piece if the piece is a normal piece
	beq $t4, $v0, setSelected	# Set selected piece if the piece is a kinge piece
	
	#jal playErrorSound		# If it is not a valid key play error sound
	j key_loop			# Keep seeking keys
	
	
# Sets a new selected piece
setSelected:
	add $s2, $0, $s0		# Sets the selected piece to the piece thats currently being selected
	add $s3, $0, $s1		# Sets the selected piece to the piece thats currently being selected
	
	add $a1, $0, $s2		# Cursor Column
	add $a2, $0, $s3		# Cursor Row
	jal getChar_atXY
	
	add $a0, $0, $v0		# Charcode
	addi $a1, $0, 20		# Cursor Column
	addi $a2, $0, 20		# Cursor Row
	jal putChar_atXY

	j key_loop
	
	
# Handles an enter key press
handleEnter:
	beq $s2, 20, checkPiece		# Branch if there is already a piece selected
	
	# Get cursor character code
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal getChar_atXY
	
	bne $v0, 8, key_loop
	
# Checks to see if the move is valid
checkMove:
	# Get cursor character code
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal getChar_atXY
	
	# Get selected character code
	add $a1, $0, $s2		# Cursor Column
	add $a2, $0, $s3		# Cursor Row
	jal getChar_atXY
	

moveNorthEast:
	sub $t4, $s3, $s1		# selected - cursor (row)
	sll $t4, $t4, 1			# t4 * 2
	sub $t5, $s0, $s2		# cursor - selected (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	beq $t4, 3, checkPlayer
	
moveNorthWest:
	sub $t4, $s3, $s1		# selected - cursor (row)
	sll $t4, $t4, 1			# t4 * 2
	sub $t5, $s2, $s0		# selected - cursor (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	beq $t4, 3, checkPlayer
	
moveSouthEast:
	sub $t4, $s1, $s3		# cursor - selected (row)
	sll $t4, $t4, 1			# t4 * 2
	sub $t5, $s0, $s2		# cursor - selected (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	beq $t4, 3, checkPlayer
	
moveSouthWest:
	sub $t4, $s1, $s3		# cursor - selected (row)
	sll $t4, $t4, 1			# t4 * 2
	sub $t5, $s2, $s0		# selected - cursor (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	beq $t4, 3, checkPlayer
	
jumpNorthEast:
	sub $t4, $s3, $s1		# selected - cursor (row)
	sll $t4, $t4, 2			# t4 * 4
	sub $t5, $s2, $s0		# selected - cursor (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	bne $t4, 10, jumpNorthWest
	
	addi $a0, $0, 1			# To get to jumped chip column
	addi $a1, $0, 1			# To get to jumped chip row
	j swapTakePiece
	
jumpNorthWest:
	sub $t4, $s3, $s1		# selected - cursor (row)
	sll $t4, $t4, 2			# t4 * 4
	sub $t5, $s0, $s2		# selected - cursor (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	bne $t4, 10, jumpSouthEast
	
	addi $a0, $0, -1		# To get to jumped chip column
	addi $a1, $0, 1			# To get to jumped chip row
	j swapTakePiece
	
jumpSouthEast:
	sub $t4, $s1, $s3		# cursor - selected (row)
	sll $t4, $t4, 2			# t4 * 4
	sub $t5, $s2, $s0		# selected - cursor (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	bne $t4, 10, jumpSouthWest
	
	addi $a0, $0, 1			# To get to jumped chip column
	addi $a1, $0, -1		# To get to jumped chip row
	j swapTakePiece
	
jumpSouthWest:
	sub $t4, $s1, $s3		# cursor - selected (row)
	sll $t4, $t4, 2			# t4 * 4
	sub $t5, $s2, $s0		# selected - cursor (column)
	add $t4, $t4, $t5		# Using a two bit binary number to check if the movement is diagonal
	bne $t4, 10, key_loop
	
	addi $a0, $0, -1		# To get to jumped chip column
	addi $a1, $0, -1		# To get to jumped chip row
	j swapTakePiece
	

# Jumping a piece
# $a0 - column to get to jumped piece
# $a1 - row to get to jumped piece
swapTakePiece:
	add $t6, $0, $a0
	add $t7, $0, $a1
	
	# Checks if jumped piece is oponents piece
	add $a1, $t6, $s0		# Selected Column
	add $a2, $t7, $s1		# Selected Row
	jal getChar_atXY
	
	add $a0, $0, $v0		# Charcode
	addi $a1, $0, 10		# Cursor Column
	addi $a2, $0, 1			# Cursor Row
	jal putChar_atXY
	
	slti $t2, $s4, 1		# Gets the opponent number
	addi $t3, $t2, 2		# Selected normal piece for opponent
	addi $t4, $t2, 4		# Selected kinged piece for opponent
	
	beq $t3, $v0, continueJump	# If the jumped piece is equal to the opponents normal piece
	beq $t4, $v0, continueJump	# If the jumped piece is equal to the opponents kinged piece
	
	jal playErrorSound
	j key_loop
	
continueJump:
	# Get character code of selected chip
	add $a1, $0, $s2		# Selected Column
	add $a2, $0, $s3		# Selected Row
	jal getChar_atXY
	
	# Move chip to new space
	add $a0, $0, $v0		# Charcode
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal putChar_atXY
	
	# Remove the jumped piece
	add $a0, $0, 0			# Charcode
	add $a1, $t6, $s0		# Cursor Column
	add $a2, $t7, $s1		# Cursor Row
	jal putChar_atXY
	
	# Set the old space to white
	add $a0, $0, 0			# Charcode
	add $a1, $0, $s2		# Cursor Column
	add $a2, $0, $s3		# Cursor Row
	jal putChar_atXY
	
	beq $s1, $0, makeKing		# Turn the piece into a king if cursor row = 0
	add $s0, $0, $0			# Reset the cursor column
	add $s1, $0, $0			# Reset the cursor row
	addi $s2, $0, 20		# Reset the selected column
	addi $s3, $0, 20		# Reset the selected row
	slti $s4, $s4, 1		# Change the player
	j initSelector
	

# Normal piece movement	
checkPlayer:
	# Check the direction of movement
	beq $s4, $0, checkP1
	beq $s4, 1, checkP2
	
checkP1:
	# Check if normal chip
	add $a1, $0, $s2		# Selected Column
	add $a2, $0, $s3		# Selected Row
	jal getChar_atXY
	beq $v0, 4, swapPiece		# If it's a kinged piece move the piece
	#beq $v0, 12, swapPiece		# If it's a kinged piece move the piece
	
	# Check if cursor row > selected row
	slt $t0, $s3, $s1		# Selected < cursor = 1
	beq $t0, 1, swapPiece
	
	j cantMove
	
checkP2:
	# Check if normal chip
	add $a1, $0, $s2		# Selected Column
	add $a2, $0, $s3		# Selected Row
	jal getChar_atXY
	beq $v0, 5, swapPiece		# If it's a kinged piece move the piece
	#beq $v0, 13, swapPiece		# If it's a kinged piece move the piece
	
	# Check if cursor row > selected row
	slt $t0, $s3, $s1		# Selected < Cursor = 1
	beq $t0, 0, swapPiece
	
	j cantMove

swapPiece:
	# Get character code of selected chip
	add $a1, $0, $s2		# Selected Column
	add $a2, $0, $s3		# Selected Row
	jal getChar_atXY
	
	# Puts the selected chip at the cursor position
	add $a0, $0, $v0		# Charcode
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal putChar_atXY
	
	# Sets the selected position to white chip
	add $a0, $0, 0			# Charcode
	add $a1, $0, $s2		# Cursor Column
	add $a2, $0, $s3		# Cursor Row
	jal putChar_atXY
	
	beq $s1, $0, makeKing		# Turn the piece into a king if cursor row = 0
	add $s0, $0, $0			# Reset the cursor column
	add $s1, $0, $0			# Reset the cursor row
	addi $s2, $0, 20		# Reset the selected column
	addi $s3, $0, 20		# Reset the selected row
	slti $s4, $s4, 1		# Change the player
	j initSelector
	
# Turn a piece into a kinged piece
makeKing:
	# Get character code of selected chip
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal getChar_atXY
	
	# Puts the selected chip at the cursor position
	addi $a0, $v0, 2		# Charcode (Add two to get a king and eight for the selected king)
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal putChar_atXY
	
	add $s0, $0, $0			# Reset the cursor column
	add $s1, $0, $0			# Reset the cursor row
	addi $s2, $0, 20		# Reset the selected column
	addi $s3, $0, 20		# Reset the selected row
	slti $s4, $s4, 1		# Change the player
	j initSelector

# Can't jump if the piece that's being jumped isn't the other player's
cantMove:
	jal playErrorSound
	j key_loop
	
# Sets the first selected piece
initSelector:
	# Set selecting player
	addi $a0, $s4, 2		# Charcode
	addi $a1, $0, 10		# Cursor Column
	addi $a2, $0, 0			# Cursor Row
	jal putChar_atXY
	
	# Set the cursor
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal getChar_atXY
	
	addi $a0, $v0, 8		# Charcode
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal putChar_atXY
	
	# Set the display
	addi $a0, $0, 222
	jal put_display
	
	li $a0, 50
	jal pause			# Pause for 1/4 second
	
	beq $0, $0, key_loop
	

# Moves the selector
# $a0 - Amount movement by column
# $a1 - Amount movement by row
moveSelector:
	add $t0, $0, $a0		# Column Movement
	add $t1, $0, $a1		# Row Movement
	
	# Selects the old square
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal getChar_atXY
	
	addi $a0, $v0, -8		# Charcode
	add $a1, $0, $s0		# Cursor Column
	add $a2, $0, $s1		# Cursor Row
	jal putChar_atXY
	
	# Set the display
	addi $a0, $0, 888
	jal put_display

	# Select the new square
	add $s0, $0, $t0		# Sets new column position
	add $s1, $0, $t1		# Sets new row position
	j initSelector

	
# Keyboard Loop
key_loop:
	jal get_key			# get a key (if available)
	beq $v0, $0, key_loop		# 0 means no valid key
	
left_key:
	bne $v0, 1, up_key
	addi $a0, $s0, -1		# Column Movement
	add $a1, $s1, $0		# Row Movement
	slti $t0, $a0, 0
	bne $t0, 0, incorrectMove
	j moveSelector

up_key:
	bne $v0, 2, right_key
	add $a0, $s0, $0		# Column Movement
	addi $a1, $s1, -1		# Row Movement
	slti $t0, $a1, 0
	bne $t0, 0, incorrectMove
	j moveSelector

right_key:
	bne $v0, 3, down_key
	addi $a0, $s0, 1		# Column Movement
	add $a1, $s1, $0		# Row Movement
	slti $t0, $a0, 8
	bne $t0, 1, incorrectMove
	j moveSelector

down_key:
	bne $v0, 4, enter_key
	add $a0, $s0, $0		# Column Movement
	addi $a1, $s1, 1		# Row Movement
	slti $t0, $a1, 8
	bne $t0, 1, incorrectMove
	j moveSelector
	
enter_key:
	bne $v0, 5, key_loop		# read key again
	j handleEnter
	
incorrectMove:
	jal playErrorSound
	j key_loop
	
# Play Error Sound
playErrorSound:
	add $t7, $0, $ra		# Save $ra in a temp register
	addi $a0, $0, 32		# Base period
	sll $a0, $a0, 12		# Period ^ 12
	jal put_sound			# Create sound with that as period
	li $a0, 50
	jal pause			# Pause for 1/4 second
	jal sound_off
	jr $t7


.include "procs_board.asm"          	# Include file with helpful procedures
