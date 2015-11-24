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
	LD	R6, STACK
	JSR	PROMPT
	JSR	RADICAL




EndMain	Halt




PROMPT	
	STR	R7, R6, #-1
	ADD	R6, R6, #-1

	LEA 	R0, name	; Outputs Names & Newline
	PUTS			; 
	LEA 	R0, NEWLINE	;
	PUTS			;

	LEA 	R0, project	; Outputs Project & Newline
	PUTS			; 
	LEA 	R0, NEWLINE	;
	PUTS			;

	LEA 	R0, prompt	; Outputs Prompt
	PUTS			;
	
	LDR	R7, R6, #0
	ADD	R6, R6, #1
	RET

	

RADICAL

	STR	R7, R6, #-1	; Save location register
	ADD	R6, R6, #-1	; Decrement Stack

	AND	R5, R5, #0	; R5 is counter
	ADD	R5, R5, #4	; LOOP 4 times
	LEA	R2, array


LOOP	GETC			; Test Loop for adding input values into an array
	PUTC			;
	STR 	R0, R2, #0	; Stores val of R0 into the loaded array R2[] 
	ADD	R2, R2, #1	; increments address of array
	ADD 	R5, R5, #-1	; decrements count
	BRp	LOOP		;
	
	LDR	R7, R6, #0	; Load previous location
	ADD	R6, R6, #1	; Restore Stack location
	RET			; Return to location in R7
	




;---------------------
; Global data
;
;---------------------

STACK	.FILL	x4000

NEWLINE .STRINGZ "\n"				; new line char in LC-3
name	.STRINGZ "Creed :: Tanner :: Brandon's"
project	.STRINGZ "Sudoku Solver"
prompt	.STRINGZ "Please input a character: "

OS_KBSR	.FILL	xFE00
OS_KBDR	.FILL	xFE02
OS_DSR	.FILL	xFE04
OS_DDR	.FILL	xFE06

array	.BLKW	5 #3  ; Test array - has value 3 in each location just as placeholder



	.END