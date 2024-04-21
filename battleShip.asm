.data
	player1map: .word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
	
	player2map:	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
			   	.word 0, 0, 0, 0, 0, 0, 0
	inputArray: 	.space	16	# Array has 4 elements so we have 4*4 space
	
	player1Hit:  	.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
	
	player2Hit:		.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'
      				.byte '_', '_', '_', '_', '_', '_', '_'	   	
	
	# output match history file 
	fout: .asciiz "Assignment\\history.txt"
	#define	
	.eqv 		ARRAY_SIZE 	7
	.eqv 		DATA_MAP_SIZE	4
	.eqv 		DATA_HIT_SIZE 		1
	
	#Interface	
	
	mapColSeperate: 	.asciiz "\t-------------------------------------------------\n"
	mapRowSeperate: 	.asciiz "       |\n"
	distanceCol1: 		.asciiz "      "
	clearScreen: 		.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	midScreen:		.asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	alignInput: 		.asciiz "\n\n\n\n\n\n\n\n\n"
	.eqv 			distanceRow  10		# '\n'
	.eqv 			distanceCol   9		# '\t'
	.eqv 			rowSeperate 124	# '|'
	
	# intro part
	branchIntro: 	.asciiz "\n\t\t\t\t\t\t\t\t\t                                  Press any button to continue\n" 
	
	exitGreeting:	.asciiz "\t\t\t\t\t\t\t\t\t                                        THANK YOU! SEE YOU <3\n"
	
	guideGreeting: 	.asciiz "\t\t\t\t\t\tGAME RULES\n"
	guide1: 		.asciiz "\n\t\t\tEach player sets up a fleet of battleships on their map (7x7)\n\t\t\tA fleet of ships can consist of 3 2x1 ships, 2 3x1 ships, and 1 4x1 ship\n"
	guide2:		.asciiz "\n\t\t\tAfter the ships have been positioned, the game proceeds in a series of rounds. In each round.\n\t\t\tEach player takes a turn to announce a target square in the opponent's grid which is to be shot at.\n"
	guide3: 		.asciiz "\n\t\t\tIf all of a player's ships have been sunk, the game is over and their opponent wins.\n"
	guide4: 		.asciiz "\n\t\t\tAll are controlled by entering coordinates from the keyboard.\n\t\t\tFor example, if you want to attack location x = 1, y = 3 type in \"1 3\" when there is a message."
	# game part
	input: 		.space 	32	# 1 0 1 2
	inputError: 	.asciiz	"\nError input, pls type again (index >= 0 && < 7)\n"
	.eqv 			sizeInput 		7
	
	greetingStart: 	.asciiz 	"\n\t\t\t\t\t\t\tLet's go\n"
	setShipGreeting: .asciiz	"\nPls type coordinates of the bow and the stern of the ship  (ex: 0 1 4 1): "
	setShipError1: 	.asciiz	"The ship must be placed in the same row or column in the coordinate system!\n"
	setShipError2: 	.asciiz	"The ship is the wrong size!\n"
	setShipError3: 	.asciiz 	"The ships can not overlap with each other!\n"
	
	typeShip2x1:	.asciiz 	"Choosing coordinate for 2x1 ship's style no."
 	typeShip3x1:	.asciiz 	"Choosing coordinate for 3x1 ship's style no."
 	typeShip4x1:	.asciiz 	"Choosing coordinate for 4x1 ship's style"
	
	
	#Bug detected
	error0: 		.asciiz "access(): Error detected when selecting base address\n"
	error0_1: 		.asciiz "access(): Error detected when selecting coordinates\n"
	error1: 		.asciiz "printMap(): Error detected when selecting base address\n"
	error2:		.asciiz "introProcess(): Error detected when branch\n"
	error3: 		.asciiz "setShips(): Error detected when selecting map for set ships\n"
	
	# MACRO part

.macro writeCordinateToFile(%str, %len)
        .text 
            addi $sp, $sp, -12
            sw $a0, 0($sp)
            sw $a1, 4($sp)
            sw $a2, 8($sp) 
            
            # Write to file just opened
            li   $v0, 15       # syscall 15: Write to file
            move $a0, $s6      # File descriptor 
            move  $a1, %str    # Address of buffer from which to write
            li   $a2, %len     # Hardcoded buffer length
            syscall            # Write to file
            
            lw $a2, 8($sp)
            lw $a1, 4($sp)
            lw $a0, 0($sp)
            addi $sp, $sp, 12
    .end_macro	

 .macro writeToFile(%str, %len)
        .data
            string: .asciiz %str
        .text 
            addi $sp, $sp, -12
            sw $a0, 0($sp)
            sw $a1, 4($sp)
            sw $a2, 8($sp) 
            
            # Write to file just opened
            li   $v0, 15       # syscall 15: Write to file
            move $a0, $s6      # File descriptor 
            la   $a1, string   # Address of buffer from which to write
            li   $a2, %len     # Hardcoded buffer length
            syscall            # Write to file
            
            lw $a2, 8($sp)
            lw $a1, 4($sp)
            lw $a0, 0($sp)
            addi $sp, $sp, 12
    .end_macro  
.macro loopMapAndSet()
	li $a2, 0
	forX:
		li $a3, 0
		forY:
			jal setMap
			addi $a3, $a3, 1
			blt $a3, ARRAY_SIZE, forY
		addi $a2, $a2, 1
		blt $a2, ARRAY_SIZE, forX
.end_macro

.macro printPrompt(%str)
.data 
	prompt: .asciiz %str
.text
	li $v0, 4
	la $a0, prompt
	syscall
.end_macro

.macro checkAlive(%ship)
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $a2, 4($sp)
		sw $s3, 8($sp)
		li $a2, 0 
		loopX: 
			li $a3, 0
			loopY: 
				jal access
				move $t0, $v0
				beq $t0, %ship, alive
				addi $a3, $a3, 1
				ble $a3, 6, loopY
			addi $a2, $a2, 1
			ble $a2, 6, loopX
		li $v0, 0
		j exitCheckAlive
		alive:
			li $v0, 1
		exitCheckAlive:
		lw $a3, 8($sp)
		lw $a2, 4($sp)
		lw $t0, 0($sp)
		addi $sp, $sp, 12
.end_macro
	

#----------------------getInput function-----------------------------------------------------#
# Feature:  read input with constant size and check std form							#
# Argument: %sizeInput is length of input in string								#
#		    %stypeOutput used of printMap									#
#		    %str is the greeting when input									 #
# Return: x1, y1 and x2, y2 in inputArray is integer array							   	#
#---------------------------------------------------------------------------------------------# 
.macro getInput(%sizeInput, %stypeOutput, %str)
.data 
	label: .asciiz %str
.text
	addi $sp, $sp, -8
	sw $a1, 0($sp)
	sw $s2, 4($sp)
read:	
	lw $a1, 0($sp)
	printMap(%stypeOutput) #<-
	jal alignInputFunction
	#print greeting
	li $v0, 4
	la $a0, label #<-
	syscall

	# read data
	li $v0, 8
	la $a0, input
	li $a1, 32
	syscall
	
	# use $s2 to store address of input
	la $s2, input
	
	li $t0, 0	#declare index of Input string
	li $t2, 0      #declare index of  Array
loopForRead:
	lbu $t1, 0($s2)
	beq $t0, %sizeInput, returnArray
	
	beq $t1, ' ', nextChar
	slti $t3, $t1, '0' #  set if x < 0 
	sge $t4, $t1, '7' #set if x >= 7
	or $t3, $t3, $t4
	beq $t3, 1, errorInputCatch
	
	subi $t1, $t1, '0'
	
	sw $t1, inputArray($t2)
	addi $t2, $t2, 4

nextChar:
	addi $s2, $s2, 1
	addi $t0, $t0, 1
	j loopForRead

errorInputCatch:
 	jal alignInputFunction
 	li $v0, 4
 	la $a0, inputError
 	syscall
 	
 	 j read
 	 
returnArray:
	bne $t1, 10, errorInputCatch
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	li $t0, %sizeInput
	bne $t0, 3, ignoreWrite
	la $t0, input
	writeCordinateToFile($t0, 3)
ignoreWrite:
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	
.end_macro
#----------------------End getInput--------------------------------------------#
	
	.macro accessA(%data_size)
	addi $sp, $sp, -4 
	sw $ra, 0($sp)
# For Debug
	jal checkIndex
	beq $v0, 0, elseAccess
	
	 li $v0, 4
	 la $a0, error0_1
	 syscall 
	 j exitDebug
elseAccess:
	addi $sp, $sp, -16
	sw $a2, 0($sp)
	sw $a3, 4($sp)
	sw $s0, 8($sp)
	sw $a1, 12($sp)
					
	beq $a1, 0, map1
	beq $a1, 1, map2
	beq $a1, 2, mapHit1
	beq $a1, 3, mapHit2
	
	li $v0, 4
	la $a0, error0
	syscall
	j exitDebug
map1: 
	la $s0, player1map
	j sum
map2:
	la $s0, player2map
	j sum
mapHit1:
	la $s0, player1Hit
	j sum
mapHit2:
 	la $s0, player2Hit
sum: 
	mul $t0, $a2, ARRAY_SIZE
	add $t0, $t0, $a3
	mul $t0, $t0, %data_size
	add $t0, $t0, $s0
	.end_macro
	
	.macro accessB
	lw $a1, 12($sp)
	lw $s0, 8($sp)
	lw $a3, 4($sp)
	lw $a2, 0($sp)
	addi $sp, $sp, 16
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	.end_macro
	
	# $s1 is argument
	.macro checkOverlapAndSetRandom (%constIndex, %runIndex, %valConst, %index1, %index2)
	addi %constIndex, %valConst, 0 
	addi %runIndex, %index1, 0
	forCheck1:
		jal access
		bne $v0, 0, randomAgain
		addi %runIndex, %runIndex, 1
		ble %runIndex, %index2, forCheck1
	addi %runIndex, %index1, 0
	 forSet1:
	 	jal setMap
	 	addi %runIndex, %runIndex, 1
		ble %runIndex, %index2, forSet1
	 j exitRandom
	.end_macro
	
	.macro checkOverlapAndSet (%constIndex, %runIndex, %valConst, %index1, %index2)
	addi %constIndex, %valConst, 0 
	addi %runIndex, %index1, 0
	forCheck:
		jal access
		bne $v0, 0, setShipError3Catching
		addi %runIndex, %runIndex, 1
		ble %runIndex, %index2, forCheck
	addi %runIndex, %index1, 0
	 forSet:
	 	jal setMap
	 	addi %runIndex, %runIndex, 1
		ble %runIndex, %index2, forSet
	 j exitCheckLegal
	.end_macro
	
	.macro changeScene (%str)
	.data
		myLabel: .asciiz %str
	.text
		jal clearScreenFunction
		
		li $v0, 4
		la $a0, myLabel
		syscall
		
		jal adjustToMidScreen
	
		li $v0, 4 
		la $a0, branchIntro
		syscall
		# press to continue animation
		li $v0, 12
		syscall
	.end_macro
	
	.macro invert1bit(%x)
		li $t1, 1
		sub %x, $t1,%x
	.end_macro 
	
#-----------------------Print map function -----------------------#
#  Feature :  print all element of map array					#
#  Argument $a1 (by default) = 0 ->map1 and vice versa		#
#-----------------------------------------------------------------#
.macro printMap(%stypeOut)
	# print player1'map or player2'map ?
	addi $sp, $sp, -4
	sw $t9, 0($sp)
	
	beq $a1, 0, printMap1
	beq $a1, 1, printMap2
	beq $a1, 2, printHit1
	beq $a1, 3, printHit2
	
	li $v0, 4
	la $a0, error1
	syscall
	j exitDebug
printMap1:
	printPrompt("\n\t\t\tPlayer 1 MAP\n")
	j print
printMap2: 
	printPrompt("\n\t\t\tPlayer 2 MAP\n")
	j print
printHit1:
	printPrompt("\n\t\t\tPlayer 2 HIT\n")
	j print
printHit2:
	printPrompt("\n\t\t\tPlayer 1 HIT\n")
print: 
	# print column label 
	jal printColumnLabel
	
	li $t3, '0'
	li $a2, 0  # set row index = 0
rowLoop:
	li $a3, 0 # set col index = 0
	
	li $v0, 11
	add $a0, $t3, $zero
	syscall 
	addi $t3, $t3, 1
	
	li $v0, 4
	la $a0, distanceCol1
	syscall
	
	li $v0, 11
	li $a0, rowSeperate
	syscall
	colLoop:
		jal access		
		move $t9, $v0		# use $t9 to store temp access value 

		li $v0, %stypeOut			#print return value
		add $a0, $t9, $zero
		syscall
	
		li $v0, 11			# print space
		li $a0, distanceCol
		syscall
	
		addi $a3, $a3, 1
		blt $a3, ARRAY_SIZE, colLoop
	
		li $v0, 11			# print line feed
		li $a0, distanceRow
		syscall
	
		li $v0, 4			# print "      |\n"
		la $a0, mapRowSeperate
		syscall
	
	addi $a2, $a2, 1
	blt $a2, ARRAY_SIZE, rowLoop
	
	lw $t9, 0($sp)
	addi $sp, $sp, 4
.end_macro
#----------------------- End Print map ------------------------#

	#.macro abs(%number)
	#sra $t1, %number, 31   
	#xor %number, %number, $t1   
	#sub %number, %number, $t1 
	#.end_macro
# END MACRO PART
.text
.globl main
main: 
	# open historyFile
	# Close the file if it's already opened
            li   $v0, 16       # syscall 16: Close file
            move $a0, $s6      # File descriptor to close
            syscall            # Close file syscall

            # Open (for writing) a file that does not exist
            li   $v0, 13       # syscall 13: Open file
            la   $a0, fout     # Output file name
            li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
            li   $a2, 0        # Mode is ignored
            syscall            # Open a file (file descriptor returned in $v0)
            move $s6, $v0      # Save the file descriptor 
         #########################################
         
         writeToFile("MOVES OF THE GAME\n", 18)
         
	j introProcess
	playGame:

	changeScene("\t\t\t\t\t                                     Player 1 set ships\n")
	
	#player 1 set ships	
	li $a1, 0 
	jal setShips
	
	changeScene("\t\t\t\t\t                                     Player 2 set ships\n")
	#player 2 set ships
	li $a1, 1 
	jal setShips
	
	changeScene("\t\t\t\t\t                                     GAME START!\n")
	
	jal gameProcess
	
playAgain:
	jal clearScreenFunction
	printPrompt("\t\t\t\t\t                    Do you want to play again?( 0 : NO |  1 : YES )\n")
	jal adjustToMidScreen
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	beq $t1, 0, Exit
	bne $t1, 1, playAgain
	
resetAll:
	li $s1, 0
	li $a1, 0
	loopMapAndSet()
	li $a1, 1
	loopMapAndSet()
	li $s1, '_'
	li $a1, 2
	loopMapAndSet()
	li $a1, 3
	loopMapAndSet()
	j main

#-------------------------------end main-----------------------------------------------#

#-------------------------------gameProcess function----------------------------------#
# Feature: launch the game and return who's won						  	#
# Argument: NO 													#
# Return: 0 is player 1 won and 1 is player 2 won								#
#---------------------------------------------------------------------------------------#				   
gameProcess:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
#  Initial 6 ships for each other
	li $t8, 6 #player1
	li $t9, 6 # player2 
player1GotoHit:
	changeScene("\t\t\t\t\t                                            Player 1 FIRE\n")
	
	jal clearScreenFunction
	
	li $a1, 3
	writeToFile("Player 1 fire to ", 17)
	getInput(3, 11, "\nPls type the coordinate you want to attack  (ex: 0 1): ")
	# check input?
	li $a1, 1
	jal checkSinkAndSet
	move $t0, $v0
	
	beq $t0, 0, player2GotoHit
	subi $t9, $t9, 1 
	beq $t9, 0, endGame1
player2GotoHit:
	changeScene("\t\t\t\t\t                                           Player 2 FIRE\n")
	jal clearScreenFunction
	
	li $a1, 2
	writeToFile("Player 2 fire to ", 17)
	getInput(3, 11, "\nPls type the coordinate you want to attack  (ex: 0 1): ")
	li $a1, 0
	jal checkSinkAndSet
	move $t0, $v0
	
	beq $t0, 0, player1GotoHit
	subi $t8, $t8, 1
	beq $t8, 0, endGame2
	
	j player1GotoHit
endGame1:
	writeToFile("Player 1 WIN\n", 13)
	changeScene("\t\t\t\t\t                                     Player 1 WIN\n")
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
endGame2:
	writeToFile("Player 2 WIN\n", 13)
	changeScene("\t\t\t\t\t                                     Player 2 WIN\n")
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
#-------------------------------checkSinkAndSet Function-------------------------------#
#  Feature: check whether hit or not and return sink or not in $v0					#
# Argument: InputArray, $a1											#
# Return: 0 or 1 in $v0 												#
#----------------------------------------------------------------------------------------#
checkSinkAndSet:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $a2, 8 ($sp)
	sw $a3, 12($sp)
	sw $t9, 16($sp)
	sw $t8, 20($sp)
	
	la $t0, inputArray
	lw $a2, 0($t0)
	lw $a3, 4($t0)
	
	writeCordinateToFile($t0, 3)
	
	jal access
	move $t9, $v0
	
	#set 0 at the coordinate 
	addi $s1, $zero, 0
	jal setMap 
	
	checkAlive($t9)
	move $t1, $v0
	
	beq $t9, 0, missFire
	# set hit in HIT map
	la $t0, inputArray
	lw $a2, 0($t0)
	lw $a3, 4($t0)
	addi $a1, $a1, 2
	addi $s1, $zero, 'o'
	jal setMap
	
	beq $t1, 0, shipSink
	writeToFile("| HIT\n", 6)
	changeScene("\t\t\t\t\t                                     	    HIT\n")
	li $v0, 0
	j exitCheckHitAndSet
shipSink:
	ble $t9, 3, shipSink2x1 
	ble $t9, 5, shipSink3x1
	#else 4x1 
	writeToFile("| HIT and Sink 4x1 Ship\n", 24)
	changeScene("\t\t\t\t\t                                     HIT and Sink 4x1 Ship\n")
	li $v0, 1
	j exitCheckHitAndSet
shipSink2x1:
	writeToFile("| HIT and Sink 2x1 Ship\n", 24)
	changeScene("\t\t\t\t\t                                     HIT and Sink 2x1 Ship\n")
	li $v0, 1
	j exitCheckHitAndSet
shipSink3x1:
	writeToFile("| HIT and Sink 3x1 Ship\n", 24)
	changeScene("\t\t\t\t\t                                     HIT and Sink 3x1 Ship\n")
	li $v0, 1
	j exitCheckHitAndSet
missFire:
	writeToFile("| Miss\n", 7)
	la $t0, inputArray
	lw $a2, 0($t0)
	lw $a3, 4($t0)
	addi $s1, $zero, 'x'
	addi $a1, $a1, 2
	jal setMap
	changeScene("\t\t\t\t\t                                             MISS\n")
	li $v0, 0
exitCheckHitAndSet:
	lw $t8, 20($sp)
	lw $t9, 16($sp)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $s1, 4($sp)			
	lw $ra, 0($sp)
	addi $sp, $sp, 24
	 
	 jr $ra

#-------------------------------setShips function -------------------------------------#
# Feature: Set location for 3 2x1 ships, 2 3x1 ships and 1 4x1 ship				     # 
# Argument: $a1 to set map player for change  ($a1 = 0 ->player1 and vice versa)	     #
#-------------------------------------------------------------------------------------#
setShips: 
	addi $sp, $sp, -8 
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	
	li $t9, 1 	#set count ship
	li $s1, 1
	beq $a1, 0, player1turn
	beq $a1, 1, player2turn
	
	li $v0, 4 
	la $a0,  error3
	syscall
	j exitDebug
player1turn: 
	la $s0, player1map
	j choosingMode
player2turn: 
	la $s0, player2map
choosingMode:
	jal clearScreenFunction
	printPrompt("\t\t\t\t\t                    Do you want to use random mode for set ship?( 0 : NO |  1 : YES )\n")
	jal alignInputFunction
	
	li $v0, 5
	syscall
	move $s7, $v0

set2x1Ships:
	jal clearScreenFunction
set2x1ShipsError:
	li $v0, 4
	la $a0, typeShip2x1
	syscall
	
	li $v0, 1
	addi $a0, $t9, 0
	syscall

	li $s2, 2 				#Set size ship and value to set
	beq $s7, 1, randomMode1
	bne $s7, 0, choosingMode
	# read data from user
	getInput(7, 1,"\nPls type coordinates of the bow and the stern of the ship  (ex: 0 1 4 1): ")
	# check 
	jal checkLegalShipAndSet
	j nextSet1
randomMode1:
	jal randomCordinate

nextSet1:	
	addi $s1, $s1, 1
	addi $t9, $t9, 1
	ble $t9, 3, set2x1Ships

	li $t9, 1
set3x1Ships:
	jal clearScreenFunction
set3x1ShipsError:
	li $v0, 4
	la $a0, typeShip3x1
	syscall
	
	li $v0, 1
	addi $a0, $t9, 0
	syscall
	
	li $s2, 3
	beq $s7, 1, randomMode2
	getInput(7, 1,"\nPls type coordinates of the bow and the stern of the ship  (ex: 0 1 4 1): ")
	jal checkLegalShipAndSet
	j nextSet2
randomMode2:
	jal randomCordinate
nextSet2:	
	addi $s1, $s1, 1
	addi $t9, $t9, 1
	ble $t9, 2, set3x1Ships
		
set4x1Ships:
	jal clearScreenFunction
set4x1ShipsError:
	li $v0, 4
	la $a0, typeShip4x1
	syscall
	
	li $s2, 4	
	beq $s7, 1, randomMode3
	getInput(7, 1,"\nPls type coordinates of the bow and the stern of the ship  (ex: 0 1 4 1): ")

	jal checkLegalShipAndSet
	
	j nextSet3
randomMode3:
	jal randomCordinate
nextSet3:	
	jal clearScreenFunction
	printMap(1)
	jal alignInputFunction
	
	li $v0, 4 
	la $a0, branchIntro
	syscall
	# press to continue animation
	li $v0, 12
	syscall

setShipAgain:	
	jal clearScreenFunction
	printPrompt("\t\t\t\t\t                    Do you want to reset map and set ship again?( 0 : NO |  1 : YES )\n")
	jal adjustToMidScreen
	# reset all ship and set again
	li $v0, 5
	syscall
	move $t1, $v0
	
	beq $t1, 0, exitSetShip
	bne $t1, 1, setShipAgain
	
	li $s1, 0
	loopMapAndSet()
	li $s1, 1
	li $t9, 1
	j choosingMode
exitSetShip:						
	lw $a1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra
#------------------------------ End setShips --------------------------------------------#

#-------------------------------checkLegalShipAndSet----------------------------------------#	
# Feature: Check whether the ship placement is valid or not							#
# Agument: inputArray space, size of selected's ship in $s2 register and $s1 is the value to set	#
# return: NO but set ship if legal												#
#---------------------------------------------------------------------------------------------#
checkLegalShipAndSet:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8 ($sp)
	# get data from inputArray
	la $t0, inputArray
	lw $t1, 0($t0)
	lw $t2, 4($t0)
	lw $t3, 8($t0)
	lw $t4, 12($t0)
	# Check to see if the ship are lined up in the same row or column
	sub $t5, $t1, $t3 		
	sub $t6, $t2, $t4		
	beq $t5, 0, checkSize
	beq $t6, 0, checkSize
	j setShipError1Catching
checkSize:	# check size ship
	abs $t5, $t5
	abs $t6, $t6
	
	addi $t5, $t5, 1
	addi $t6, $t6, 1
	
	sub $t7, $t5, $s2  	# this size's ship - size 	if = 0 -> ==
	sub $t8, $t6, $s2
	and $t0, $t7, $t8		# and together if == 0 	-> same size
	bne $t0, 0, setShipError2Catching
	# check overlap
		# For loop to check coordinates is placed or not
	beq $t5, 1, rowPlace
	beq $t6, 1, colPlace
	 
rowPlace:
	blt $t2, $t4, setRowFor2
setRowFor1: 
	checkOverlapAndSet($a2, $a3, $t1, $t4, $t2)
setRowFor2:
	checkOverlapAndSet($a2, $a3, $t1, $t2, $t4)

colPlace: 
	blt $t1, $t3, setColFor2
setColFor1:
	checkOverlapAndSet($a3, $a2, $t2, $t3, $t1)
setColFor2: 
	checkOverlapAndSet($a3, $a2, $t2, $t1, $t3)

setShipError1Catching: 	
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12

 	jal alignInputFunction
	li $v0, 4
	la $a0, setShipError1
	syscall

	beq $s2, 2, set2x1ShipsError
	beq $s2, 3, set3x1ShipsError
	beq $s2, 4, set4x1ShipsError
	
setShipError2Catching:
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12

 	jal alignInputFunction
	li $v0, 4
	la $a0, setShipError2
	syscall 
	
	beq $s2, 2, set2x1ShipsError
	beq $s2, 3, set3x1ShipsError
	beq $s2, 4, set4x1ShipsError
	
setShipError3Catching:
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12

	jal alignInputFunction
	li $v0, 4
	la $a0, setShipError3
	syscall 
	
	beq $s2, 2, set2x1ShipsError
	beq $s2, 3, set3x1ShipsError
	beq $s2, 4, set4x1ShipsError
	
exitCheckLegal:
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra


#----------------------Access function-------------------------------------------------#
#	Feature: return data at 1 coordinate 								   	#
#	Argument : Need row and col index (default loaded into $a2, $a3) 		    	#
#	and which map want to access										#
#	 (default  	$a1 = 0 -> player1'map									#
#	  		$a1 = 1 -> player2'map									#
#	  		$a1 = 2 -> player1'hit map									#
#	  		$a1 = 3 -> player2'hit map) 							    	#
#	Return : value at your coordinates in $v0							    	#
#	NOTE: Use $s0 as base address									    	#
#----------------------------------------------------------------------------------------#
access:
	bge $a1, 2, accessByte
		accessA(DATA_MAP_SIZE)
	 	lw $v0, 0($t0)
	j returnAccess
	accessByte:
		accessA(DATA_HIT_SIZE)
		lb $v0, 0($t0)
	returnAccess:
	accessB()
#----------------------- End Access---------------------- -------#

#----------------------setMap function---------------------------------------------------------#	
#	Feature: set Data for map												#	
#	Argument: need row and col index (default loaded into $a2, $a3) 					#
#			and which map want to access 									#
#	 (default  	$a1 = 0 -> player1'map										#
#	  		$a1 = 1 -> player2'map										#
#	  		$a1 = 2 -> player1'hit map										#
#	  		$a1 = 3 -> player2'hit map) 							    		#
 #			$s1 (by default) is the value that you want to set at that coordinate			    #
#	return : NO but change data of selected's map							            #
#	use $s0 like base address										    		   #
#-----------------------------------------------------------------------------------------------#
setMap:
	bge $a1, 2, setByte
		accessA(DATA_MAP_SIZE)
	 	sw $s1, 0($t0)
	j returnSet
	setByte:
		accessA(DATA_HIT_SIZE)
		sb $s1, 0($t0)
	returnSet:
	accessB()
#--------------------------------------------- End Access-------------------------------------#

randomCordinate:
	addi $sp, $sp, -28
	sw $a1, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $ra, 24($sp)
	# random same row or same col (row = 0, col = 1)
	
	li $a1, 7  
	li $v0, 42
	syscall
	move $t1, $a0

randomAgain:
	li $a1, 7  
	li $v0, 42
	syscall
	move $t2, $a0
		
	li $a1, 7  
	li $v0, 42
	syscall
	move $t3, $a0
	
	sub $t0, $t2, $t3
	abs $t4, $t0
	addi $t4, $t4, 1
	bne $t4, $s2, randomAgain
	
	li $a1, 2
	li $v0, 42
	syscall
	lw $a1, 0($sp)
	beq $a0, 1, colSet
	#row set
	blt $t0, 0, rowSet1
	checkOverlapAndSetRandom($a2, $a3, $t1, $t3, $t2)
rowSet1:
	checkOverlapAndSetRandom($a2, $a3, $t1, $t2, $t3)	
colSet:
	 # (%constIndex, %runIndex, %valConst, %index1, %index2)
	 blt $t0, 0, colSet1
	 checkOverlapAndSetRandom($a3, $a2, $t1, $t3, $t2)
colSet1:
	 checkOverlapAndSetRandom($a3, $a2, $t1, $t2, $t3)
exitRandom:
	lw $ra, 24($sp)
	lw $t4, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 12($sp)	
	lw $t1, 8($sp)		
	lw $t0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 28
.	
	jr $ra

#-----------------------printColumnLabel function-------------#
# Feature : print column label for map					     #
# Argument: NO								      #
# ----------------------end printColumnLabel function---------#
printColumnLabel:
	li $t0, 0 # print begin 0
	
	li $v0, 11
	li $a0, distanceRow
	syscall
	
	li $v0, 11
	li $a0, distanceCol
	syscall

loopLabel:	
	li $v0, 1
	add $a0, $t0, $zero
	syscall
	
	li $v0, 11
	li $a0, distanceCol
	syscall
	
	addi $t0, $t0, 1
	ble $t0, 6, loopLabel
	
	li $v0, 11
	li $a0, distanceRow
	syscall
	
	li $v0, 4
	la $a0, mapColSeperate
	syscall
	
	jr $ra

#--------------------------introProcess function-------------------------#
#  Feature:  Greeting and show how to play or exit Game			  #
#  Argument: No										  #
#------------------------------------------------------------------------#
introProcess: 
	jal clearScreenFunction
	changeScene("\t\t\t\t\t\t\t\t\t                                         BATTLE SHIP GAME\n")
branchChoosing:
	jal clearScreenFunction
	
	printPrompt("\t\t\t\t\tPlay\t\tPress 1 to play\n")
	
	printPrompt("\t\t\t\t\tGuide\t\tPress 2 to read game rules\n")
	
	printPrompt("\t\t\t\t\tExit\t\tPress 3 to out game\n")
	
	jal adjustToMidScreen
	li $v0, 12 # Get character
 	# $v0 contains character read
	syscall
	add $a0, $0, $v0 # Move character to register
	
	beq $a0, '1', playGame
	beq $a0, '2', showGuide
	beq $a0, '3', Exit
	
	li $v0, 4
	la $a0, error2
	syscall
	
	j branchChoosing

showGuide:
	jal clearScreenFunction
	
 	li $v0, 4
 	la $a0, guideGreeting
 	syscall
 	
 	li $v0, 4 
 	la $a0, guide1
 	syscall
 	
 	li $v0, 4 
 	la $a0, guide2
 	syscall
 	
 	li $v0, 4 
 	la $a0, guide3
 	syscall
 	
 	li $v0, 4 
 	la $a0, guide4
 	syscall
 	
 	jal adjustToMidScreen
 	
 	li $v0, 4 
 	la $a0, branchIntro
 	syscall
 	
 	li $v0, 8
	syscall
	
	j branchChoosing
 #---------------------- End introProcess ------------------------#

#-----------------------checkIndex function ---------------------#
# Feature: Examinate index is legal ? 						#
# Argument: x, y (by default is $a2, $a3)					#
# Return $v0 is true or false								#
#-----------------------------------------------------------------#
checkIndex:
	addi $sp, $sp, -8
	sw $t9, 0($sp)
	sw $t8, 4($sp)
	
	slti $t8, $a2, 0  # x < 0
	sge $t9, $a2, 7 # x >= 7
	or $t9, $t8, $t9 # x < 0 || x >= 7
	
	slti $t7, $a3, 0  # y < 0
	sge $t8, $a3, 7 # y >= 7
	or $t7, $t8, $t7 # y < 0 || y >= 7
	
	or $v0, $t9, $t7 # x < 0 || x >= 7 || y < 0 || y >= 7
	
	lw $t8, 4($sp)
	lw $t9, 0($sp)
	addi $sp, $sp, 8
	jr $ra
#--------------- clearScreenFunction ---------------------------#
# Feature: clear screen terminal 						      #
# Argument: NO 								      #
#----------------------------------------------------------------# 
clearScreenFunction: 
	li $v0, 4
	la $a0, clearScreen
	syscall 	
	
	jr $ra	
#--------------- adjustToMidScreen Function ---------------------------#
# Feature: clear screen terminal 						      		#
# Argument: NO 								      		#
#-----------------------------------------------------------------------#	 
adjustToMidScreen:
	li $v0, 4
	la $a0, midScreen 
	syscall
	
	 jr $ra 
	 
alignInputFunction:
	li $v0, 4
	la $a0, alignInput
	syscall 
	
	jr $ra
Exit: 
	jal clearScreenFunction
	
	li $v0, 4
	la $a0, exitGreeting
	syscall 
	
	jal adjustToMidScreen
	
	# Close the file 
    	li   $v0, 16       # syscall 16: Close file
    	move $a0, $s6      # File descriptor to close
    	syscall            # Close file syscall

	li $v0, 10
	syscall
exitDebug:
