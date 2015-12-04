; Program:	sudoku_solv.asm		|
; Date:		17 Nov. 2015		|
; Version:	1.0					|
;
; Authors:	Creed Haymond		|
;			Tanner Frandsen 	|
;			Brandon Bentley		|
; Note:							|
; 

	.ORIG x3000

MAIN
	
	LD R6, STACK 	; Load up stack pointer
	LD R5, BOARD 	; Load up board array pointer

	JSR	PROMPT 			; Call subroutine for the first prompt and info

	JSR	LOAD_BOARD	 	; Call to subroutine that will get numbers from input and store them
	JSR	DISPLAY_BOARD	; Display in formatted board

	;JSR SOLVE_SUDOKU 	; Call subroutine that solves the Sudoku
	JSR SOLVE_BOARD 	


	JSR	DISPLAY_BOARD	; Display board AGAIN, Solved. 

	LEA R0, DONE
	PUTS

EndMain	Halt


;---------------------
; Global data
;
;---------------------

STACK	.FILL	x4000
DONE	.STRINGZ "\n -- done! Exit -- \n"
BOARD	.BLKW	16  ; Test array - has value 0 in each location just as placeholder



;------------------------------------
;   ***** PROMPT *****
; 		Subroutine
; - Just displays initial message and prompt
; 
; Clobbers:
; R0 = display register
; R1 = 
; R2 = 
; R3 = 
; R4 = 
;
; NO TOUCHEEE 
; R5 = loaded board
; R6 = stack
; R7 = PC counter thing 
;------------------------------
PROMPT	
	STR	R7, R6, #-1 	; 
	ADD	R6, R6, #-1

	LEA R0, name		; Outputs Names & Newline
	PUTS				; 
	LD R0, NEW_LINE		;
	OUT			 		;

	LEA R0, project		; Outputs Project & Newline
	PUTS				; 
	LD R0, NEW_LINE		;
	OUT 				;

	LEA R0, promptWord	; Outputs Prompt
	PUTS				;
	
	LDR	R7, R6, #0		; Return to JSR calling location
	ADD	R6, R6, #1		; & restor stack
	RET

;-------------------
; Promp Variables
;-------------------	
name		.STRINGZ "Creed :: Tanner :: Brandon's "
project		.STRINGZ "Sudoku Solver"
promptWord	.STRINGZ "Please enter 16 numbers between 0 & 4: \n"
	


;------------------------------------
; ***** LOAD_BOARD *****
; 		Subroutine
; 
; - gets 16 numbers input from the user
; between the numbers 0 & 4
;
; Clobbers:
; R0 = display register
; R1 = find 0
; R2 = 
; R3 = incremented board 
; R4 = counter to get through the board *should be restored if 
; 		you jump to another sub that clobbers it. 
; 
; NO TOUCHEEE 
; R5 = loaded board
; R6 = stack
; R7 = PC counter thing 
;------------------------------------

LOAD_BOARD

	STR	R7, R6, #-1	; Save location register
	ADD	R6, R6, #-1	; Decrement Stack

	AND	R4, R4, #0	; R4 is counter
	ADD	R4, R4, #8	; LOOP 16 times
 	ADD	R4, R4, R4	; "make 16, with R4"

	ADD	R3, R5, #0	; put BOARD pointer in R2

GET_LOOP 	
	GETC			; Test Loop for adding input values into an array
	OUT				;

	;****************************
	;
	; Call error check for 0 - 4
	; - not yet implemented
	;
	;****************************

	STR R0, R3, #0		; Stores val of R0 into the loaded array R2[] 
	ADD R3, R3, #1		; increments address of array

	LD R0, SPACE		; puts space for readability
	OUT

	ADD R4, R4, #-1		; decrements count
	BRnz GET_OUT
	BRp  GET_LOOP		;
	
GET_OUT	
	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET					; Return to calling location



;------------------------------------
; ***** DISPLAY_BOARD *****
; 		Subroutine
; 
; - Displays the contents of 
; the array in sudoku form
; 
; Clobbers:
; R0 = display register
; R1 = 
; R2 = 
; R3 = incremented board 
; R4 = counter to get through the board *should be restored if 
; 		you jump to another sub that clobbers it. 
; 
; NO TOUCHEEE 
; R5 = loaded board
; R6 = stack
; R7 = PC counter thing 
;------------------------------------

DISPLAY_BOARD
	STR R7, R6, #-1	; Save location of call on stack
	ADD R6, R6, #-1	; 

	LD	R0, NEW_LINE
	OUT
	OUT

	AND	R4, R4, #0	; R4 is counter

DISPLAY_NEXT_VALUE	
	ADD R3, R5, R4	; R5 is the board. Adding value of R4 increments it and loads to R0
	LDR	R0, R3, #0
	OUT			; Prints value
	ADD	R4, R4, #1	; increment counter

	LD	R0, SPACE
	OUT

	ADD	R0, R4, #-2
	BRz	DISPLAY_BIGSPACE

	ADD	R0, R4, #-4
	BRz	DISPLAY_NEXT_LINE

	ADD	R0, R4, #-6
	BRz	DISPLAY_BIGSPACE

	ADD	R0, R4, #-8
	BRz	DISPLAY_NEXT_LINE

	ADD	R0, R4, #-10
	BRz	DISPLAY_BIGSPACE

	ADD	R0, R4, #-12
	BRz	DISPLAY_NEXT_LINE

	ADD	R0, R4, #-14
	BRz	DISPLAY_BIGSPACE

	ADD	R0, R4, #-16
	BRz	FINISH_DISPLAY

	BRnp	DISPLAY_NEXT_VALUE
	
DISPLAY_BIGSPACE
	LEA	R0, BIG_SPACE
	PUTS
	BRnzp	DISPLAY_NEXT_VALUE

DISPLAY_NEXT_LINE
	LD	R0, NEW_LINE
	OUT
	
	ADD	R0, R4, #-16
	BRnp	DISPLAY_NEXT_VALUE
	

FINISH_DISPLAY
	LD	R0, NEW_LINE
	OUT
	
	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET				; Return to calling location


;------------------------------
; BOARD formatting data
; for displaying the board only
;------------------------------
	SPACE		.FILL	x20 ; space
	NEW_LINE	.FILL	x0A ; new line
	BIG_SPACE	.STRINGZ " "




;------------------------------------
; ***** SOLVE_BOARD *****
; 		Subroutine
; - moves through array finding 0's and 
; keeping track of the row and column counters
; calls separate SUB that will test new 
; numbers for the unsolved locations
; 
; Clobbers:
; R0 = display register
; R1 = find 0
; R2 = 
; R3 = incremented board 
; R4 = counter to get through the board *should be restored if 
; 		you jump to another sub that clobbers it. 
; NO TOUCHEEE 
; R5 = loaded board
; R6 = stack
; R7 = PC counter thing 
;------------------------------

SOLVE_BOARD
	STR R7, R6, #-1	; Save location of call on stack
	ADD R6, R6, #-1	; 

	LD	R0, NEW_LINE 	; just in case we need to output DEBUG 
	OUT 				; info during the running of this

	AND	R4, R4, #0		; R4 is counter
	
	LD	R1, RESET		;
	NOT	R1, R1			; 
	ADD	R1, R1, #1		; make inverted ASCII "0" to check against

SOLVE_NEXT_VALUE	
	ADD R3, R5, R4	; R5 is the board. Adding value of R4 increments it and loads to R0
	LDR R0, R3, #0
	
	ADD	R0, R0, R1	; check for 0
	BRz	SOLVE_ZERO
	
	BRnp CONTINUE

CONTINUE	
	ADD	R4, R4, #1			; increment array counter

	LD R0, column 			; upacks, increments, & repacks column count
	ADD R0, R0, #1
	ST R0, column

	ADD	R0, R4, #-4			;
	BRz	GOTO_NEXT_LINE		;
							;
	ADD	R0, R4, #-8			;
	BRz	GOTO_NEXT_LINE		; These direct the counting
							; of the columns and rows
	ADD	R0, R4, #-12		;
	BRz	GOTO_NEXT_LINE		;
							;
	ADD	R0, R4, #-16		;
	BRz	FINISH_SOLVE		;

	BRnp	SOLVE_NEXT_VALUE

	
SOLVE_ZERO
	LD R0, zero_count		; unpacks, increments, & repacks zero counter
	ADD R0, R0, #1
	ST R0, zero_count
	
	;*****************************************
	; CALL SOLVE POSITION SUB
	; - This will hand over the solving to Brandon's sub 
	; that will increment the test_num and loop until one 
	; works
	; ;lajsdf;lkjasdf;lkjasdf;lkjasdf;lkjasdf;lkjasdf;lkjasdf;lkjasd
	;*****************************************

	BRnzp CONTINUE


GOTO_NEXT_LINE
	
	LD  R0, RESET 			; resets column counter 
	ST  R0, column

	LD  R0, row 			; unpacks, increments, and packs row counter
	ADD R0, R0, #1
	ST  R0, row

	ADD R0, R4, #-16    	; if its the last element in the array
	BRnp SOLVE_NEXT_VALUE	; drop through, if not, SOLVE_NEXT_VALUE
	

FINISH_SOLVE

	LD  R0, column 		; Decrement column count by 1
	ADD R0, R0, #-1		; since it skips the last reset 
	ST  R0, column

	LD R0, NEW_LINE
	OUT

	LD R0, column
	OUT

	LD R0, NEW_LINE
	OUT

	LD R0, row
	OUT

	LD R0, NEW_LINE
	OUT

	LD R0, zero_count
	OUT

	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET					; Return to calling location

;******** GO BACK TO CALLING JSR *******


;-------------------------------------
; *** SOLVE VARS *** 
; Imporant "global-ish" Solving Variables
; and Data. 
; *** Use these in the other checks ***
; ------------------------------------

;--- Constant
RESET 		.FILL x30 

;--- Variable
column 		.FILL x30
row 		.FILL x30
zero_count	.FILL x30




;------------------------------------
; **** SOLVE_SUDOKU *****
; subroutine
;------------------------------------
SOLVE_SUDOKU	
	STR R7, R6, #-1	; Save location of call on stack
	ADD R6, R6, #-1	; 

	AND R4, R4, #0  ;initialize the counter at 0
SOLVE_LOOP
	ADD R3, R5, R4	;Starts at location 0 of array
	LDR	R0, R3, #0	;loads value at R3 into R0
	BRZ SOLVE_LOCATION ;If R0 = 0 jump to Solve Location
INCREMENT_LOCATION
	ADD R4, R4, #1	 ;increments to next location if R0 > 0
	ADD R2, R4, #-15 ;subtracts the 15 from the location. 
					 ;if R2 == 0 you are done
	BRN SOLVE_LOOP	 ;if not finished then jump to SOLVE_LOOP

	
	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET				; Return to calling location
SOLVE_LOCATION
	ADD R0, R0, #1	;increment value at R0 by 1
	BRNZP ROW_CHECK	;start the checking starting with the row
	BRNZP INCREMENT_LOCATION		;If it makes it through all checks jump to the looping cycle
; Code
;
;

;---------------------------
; SOLVE_SUDOKU Variables
;---------------------------
test_num	.FILL x30 



;--------------------------
; ROW_CHECK
; Subroutine
; 
;--------------------------
ROW_CHECK



BRP SOLVE_LOCATION

;---------------------------
; ROW_CHECK Variables
;---------------------------






;--------------------------
; COLUMN_CHECK
; Subroutine
; R2, R3
;--------------------------
COLUMN_CHECK


BRP SOLVE_LOCATION
;---------------------------
; COLUMN_CHECK Variables
;---------------------------

; Variables
;



;--------------------------
; BOX_CHECK
; Subroutine
; R0: 
; R1: Hold The result for the NZP bits
; R2: ? row or  column
; R3: Hold the board value temp using offset number
; R4: Counter
; R5: Board
; R6: Return Values
; R7: Return Values
;--------------------------
BOX_CHECK


	;----- Allow us to return -----;
	STR	R7, R6, #-1	; Save Return Address
	ADD	R6, R6, #-1	; Get True Return Address

	LD  R0, test_num	; this is the test number

	; ----------Turn the test number negative -----------;
	NOT R0, R0		; Flip the bits
	Add R0, R0, #1 	; Add One to create negative

	
	
	LD  R2, row	; load the value from row into R2

	AND R1, R1, #0		;Reset the R1
	ADD R1, R2, #-2 	;This is the assuming the value of the row in in row
					;set NZP for the top/bottom boxes
	BRn TOP_BOXES
	
	BRzp BOTTOM_BOXES
	

BOX_1	
	LD R2, QUAD1	;start at 0
	BRnzp STEP_BOX

BOX_2
	LD R2, QUAD2	;start at 2
	BRnzp STEP_BOX

BOX_3
	LD R2, QUAD3	;start at 8
	BRnzp STEP_BOX

BOX_4	
	LD R2, QUAD4	;start at 10
	BRnzp STEP_BOX


STEP_BOX
;------- TOP_LEFT number-------------;
	ADD R2, R2, #0	;0 + [first] = TL
	ADD R3, R5, R2 	;R3 = (R5 + R2)	 R2 = start number

	;==========================================================================================================================================;
	; This was for debug 
	ADD R3, R5, R2	; R5 is the board. Adding value of R4 increments it and loads to R0
	LDR	R0, R3, #0
	OUT			; Prints value
	;=========================================================================================================================================;

	;*****************************************************************************************************************************************;
	;ADD R1, R3, R0  ;R1 = R3 + R0 is equal?

	;BRz
	;	SOLVE_LOCATION 	; fail the number was found
	;BRnp
		;number was not found fall through
	;*****************************************************************************************************************************************;

;--------- TOP RIGHT ------------;
	ADD R2, R2, #1 	;[first] + 1 = TR
	ADD R3, R5, R2 	;Load the value into R3

	;========================================================================================================================================;
	ADD R3, R5, R2	; R5 is the board. Adding value of R4 increments it and loads to R0
	LDR	R0, R3, #0
	OUT		; Prints value
	;========================================================================================================================================;	


	;ADD R1, R3, R0  ;R1 = R3 + R0 is equal?

	;BRz
	;	SOLVE_LOCATION 	; fail the number was found
	;BRnp
		;number was not found fall through

	
;---------- Bottom Left -----------;
	ADD R2, R2, #3 ; [first] + 4 = BL
	ADD R3, R5, R2 ; Load the value into R3

	;========================================================================================================================================;
	ADD R3, R5, R2	; R5 is the board. Adding value of R4 increments it and loads to R0
	LDR	R0, R3, #0
	OUT			; Prints value
	;========================================================================================================================================;

	;****************************************************************************************************************************************;
	;ADD R1, R3, R0 ; R1 = R3 + R0

	;BRz
	;	SOLVE_LOCATION 	; fail the number was found
	;BRnp
		; number was not found fall throught
	;****************************************************************************************************************************************;

; --------- Bottom right ------------;

	ADD R2, R2, #1 ;[first] + 5 = BR
	ADD R3, R5, R2 ; Load the value into R3


	;========================================================================================================================================;
	ADD R3, R5, R2	; R5 is the board. Adding value of R4 increments it and loads to R0
	LDR	R0, R3, #0
	OUT		; Prints value
	;========================================================================================================================================;

	;****************************************************************************************************************************************;
	;ADD R1, R3, R0 ; R1 = R3 + R0


	;BRz
	;	SOLVE_LOCATION 	; fail the number was found
	;BRnp
		; number was not found fall throught
	;****************************************************************************************************************************************;
	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET					; Return to calling location




TOP_BOXES

	LD  R2, column

	AND R1, R1, #0		;Reset the R1
	ADD R1, R2, #-2 	;This is the assuming the value of the row in in column
		BRn BOX_1	;Top_Left

		BRzp BOX_2	;Top_Right
				

BOTTOM_BOXES

	LD  R2, column

	ADD R1, R1, #0		;Reset the R1
	ADD R1, R2, #-2 	;This is the assuming the value of the row in in column
	
	BRn BOX_3	;Bottom Right
			
	BRzp BOX_4	;Bottom Left



QUAD1 .FILL #0
QUAD2 .FILL #2
QUAD3 .FILL #8
QUAD4 .FILL #10

.END