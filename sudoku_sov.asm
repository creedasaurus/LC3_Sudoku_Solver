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


Main	LEA R0, name	; Outputs Names & Newline
	PUTS		; 
	LEA R0, newLine	;
	PUTS		;

	LEA R0, project	; Outputs Project & Newline
	PUTS		; 
	LEA R0, newLine	;
	PUTS		;

	LEA R0, prompt	; Outputs Prompt
	PUTS		;
	
LOOP	LDI R0, OS_KBSR ;
	BRzp	LOOP	
	LDI R0, OS_KBDR	;
	PUTS		;
	

EndMain	Halt


;---------------------
; Memory Allocation
;
;---------------------


newLine .STRINGZ "\n"				; new line char in LC-3
name	.STRINGZ "Creed :: Tanner :: Brandon's"
project	.STRINGZ "Sudoku Solver"
prompt	.STRINGZ "Please input a character: "

OS_KBSR	.FILL	xFE00
OS_KBDR	.FILL	xFE02


	.END