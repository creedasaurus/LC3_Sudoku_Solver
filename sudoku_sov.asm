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
	
	LD	R6, STACK 	; Load up stack pointer
	LD 	R5, BOARD 	; Load up board array pointer

	JSR	PROMPT 		; Call subroutine for the first prompt and info
	JSR	GetAndStore	; Call to subroutine that will get numbers from input and store them
	JSR	DISPLAY_BOARD
	LEA R0, DONE
	PUTS

EndMain	Halt


;---------------------
; Global data
;
;---------------------

STACK	.FILL	x4000
DONE	.STRINGZ "\n -- done! Exit -- \n"
NEWLINE .STRINGZ "\n"	; new line char in LC-3

BOARD	.BLKW	16  ; Test array - has value 0 in each location just as placeholder



;-------------------
; PROMPT
; Subroutine
; this will display the initial info
; and prompts
;--------------------
PROMPT	
	STR	R7, R6, #-1
	ADD	R6, R6, #-1

	LEA 	R0, name	; Outputs Names & Newline
	PUTS				; 
	LEA 	R0, NEWLINE	;
	PUTS			 	;

	LEA 	R0, project	; Outputs Project & Newline
	PUTS				; 
	LEA 	R0, NEWLINE	;
	PUTS 				;

	LEA 	R0, promptWord	; Outputs Prompt
	PUTS				;
	
	LDR	R7, R6, #0
	ADD	R6, R6, #1
	RET

;-------------------
; Promp Variables
;-------------------	
name	.STRINGZ "Creed :: Tanner :: Brandon's "
project	.STRINGZ "Sudoku Solver"
promptWord	.STRINGZ "Please input a number: "
	




;-----------------------------
; GetAndStore
; Subroutine
; *currently proof of concept*
; This shows an example of how we can
; get and store numbers for the board
;----------------------------

GetAndStore

	STR	R7, R6, #-1	; Save location register
	ADD	R6, R6, #-1	; Decrement Stack

	AND	R4, R4, #0	; R4 is counter
	ADD	R4, R4, #8	; LOOP 16 times
 	ADD	R4, R4, R4	; "make 16, with R4"

	ADD	R2, R5, #0	; put BOARD pointer in R2

LOOP 	GETC				; Test Loop for adding input values into an array
		PUTC			;
		STR 	R0, R2, #0	; Stores val of R0 into the loaded array R2[] 
		ADD 	R2, R2, #1	; increments address of array
		ADD 	R4, R4, #-1	; decrements count
		BRnz	OUTLOOP
		BRp	LOOP		;
	
OUTLOOP	
	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET					; Return to calling location
		

;------------------------------
; Subroutine: DISPLAY_BOARD
;
; puts the current board config 
; using whatever is stored in BOARD
;------------------------------

DISPLAY_BOARD
	STR R7, R6, #-1	; Save location of call on stack
	ADD R6, R6, #-1	; 

	LEA	R0, NEWLINE
	PUTS

	AND	R4, R4, #0	; R4 is counter

DISPLAY_NEXT_VALUE	
	ADD 	R3, R5, R4	; R5 is the board. Adding value of R2 increments it and loads to R0
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
	ADD R4, R4, #1	;increments to next location if R0 > 0
	ADD R2, R4, #-16 ;subtracts the 16 from the location
					 ;if equal to zero then you are done 
	BRN SOLVE_LOOP	;if not finished then jump to SOLVE_LOOP

	
	LDR	R7, R6, #0		; Load previous location
	ADD	R6, R6, #1		; Restore Stack location
	RET				; Return to calling location
SOLVE_LOCATION
	ADD R0, R0, #1	;incement R0 by 1
	BRNZP ROW_CHECK	;start the checking starting with the row
	BRNZP INCREMENT_LOCATION		;If it makes it through all checks jump to the looping cycle
; Code
;
;

;---------------------------
; SOLVE_SUDOKU Variables
;---------------------------


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

; Variables
;



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
; 
;--------------------------
BOX_CHECK



BRP SOLVE_LOCATION
; Code
;
;

;---------------------------
; BOX_CHECK Variables
;---------------------------

; Variables
;






	.END