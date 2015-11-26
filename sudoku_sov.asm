; Program:	sudoku_solv.asm	|
; Date:		17 Nov. 2015	|
; Version:	1.0		|
;
; Authors:	Creed Haymond	|
;		Tanner Frandsen	|
;		Brandon Bentley	|
; Note:				|
; 

	.ORIG x3000

MAIN
	
	LD	R6, STACK 	; Load up stack pointer
	LD 	R5, BOARD 	; Load up board array pointer
	JSR	PROMPT 		; Call subroutine for the first prompt and info
	JSR	GetAndStore	; Call to subroutine that will get numbers from input and store them

EndMain	Halt


;---------------------
; Global data
;
;---------------------

STACK	.FILL	x4000

NEWLINE .STRINGZ "\n"	; new line char in LC-3

BOARD	.BLKW	81 #0  ; Test array - has value 0 in each location just as placeholder



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

	LEA 	R0, prompt	; Outputs Prompt
	PUTS				;
	
	LDR	R7, R6, #0
	ADD	R6, R6, #1
	RET

;-------------------
; Promp Variables
;-------------------	
name	.STRINGZ "Creed :: Tanner :: Brandon's"
project	.STRINGZ "Sudoku Solver"
prompt	.STRINGZ "Please input a character: "
	


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

	AND	R5, R5, #0	; R5 is counter
	ADD	R5, R5, #4	; LOOP 4 times
	LEA	R2, BOARD


LOOP 	GETC				; Test Loop for adding input values into an array
		PUTC				;
		STR 	R0, R2, #0	; Stores val of R0 into the loaded array R2[] 
		ADD 	R2, R2, #1	; increments address of array
		ADD 	R5, R5, #-1	; decrements count
		BRp		LOOP		;
	
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
;
;
;
;


;----------
; BOARD vars
; for displaying the board only
;----------



	.END