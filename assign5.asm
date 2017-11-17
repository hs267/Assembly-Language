**************************************
*
* Name: Han Song
* ID: 14253499
* Date: Nov/11
* Lab5
*
* Program description:
*	This program is to find the sum of the squared numbers from the NARR, then we store the
* result into a new array called RESARR. the result will be ordered listed in the RESARR
* array
* the subroutine is transparent to the main program and only the local dynamic variable
* implemented on the stack
*
* Pseudocode of Main Program:
*
* unsigned int NARR[]
* #define SENTIN $FF
* unsigned int RESARR[]
*  pointer1=&NARR[0]
*  pointerT=&RESARR[0]
* while(*pointer1 != SENTIN)
* {
*
* 	push x onto stack
*		*pointer1 = A register
*		call subroutine
*
*		Pull RESULT from stack
*		pointerT= RESULT(STORE THE RESULT FROM SUB)
*		pointerT=pointerT+4
*		pull pointer1 from stack
*		pointer1++
*
* }
*
*---------------------------------------
*
* Pseudocode Subroutine
*
*	make space for return data
*	make space for return data
*	make space for return data
*	make space for return data （4 bytes data)
*	save A register
*	save B register
*	save X register
*	save Y register
*  save CC register
*	OPEN HOLE FOR RESULT+2
*	OPEN HOLE FOR RESULT
* OPEN HOLE FOR COUNT
*	OPEN HOLE FOR J
*	OPEN HOLE FOR SQUARE
*	OPEN HOLE FOR I
*	GET VARIABLE ADDRESS
* J = A VALUE
* RESULT = 0;
*     J=N;
*     DO{
*	COUNT = J;
*	I = 1;
*	SQUARE = 0;
*	DO{
*	  SQUARE = SQUARE + I;
*	  I+=2;
*	  COUNT--;
*	} until (COUNT == 0)
*
*       RESULT(lower two bytes) = RESULT (lower two bytes)+ SQUARE;
*	if( C-flag ==1) RESULT(upper two bytes) ++;
*
*	 	(the above implements the addition of a 2-byte and a 4-byte number)
*
*       J--;
*     } until (J==0)
*
* UPDATE RETURN ADDRESS
*	ASSIGN VALUE TO THE FIRST TWO BYTE
*	ASSIGN VALUE TO THE SECOND TWO BYTE
*	CLOSE HOLES
* RESTORE A REGISTER
*	RESTORE CC REGISTER
*	RESTORE Y REGISTER
* RESTORE X REGISTER
* RESTORE B REGISTER
* RESTORE A REGISTER
***************************************

* start of data section
	ORG $B000
NARR	FCB	1, 2, 5, 100, 150, 200, 250, 254, $FF
SENTIN	EQU	$FF

	ORG $B010
RESARR	RMB	32


* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.

temp		RMB		4


	ORG $C000
	LDS	#$01FF		initialize stack pointer
* start of your program
	LDX 		#RESARR			*get the result array address
	STX		 temp			*store the address in a variable
	LDX 		#NARR			*get Number array address
WHILE1		LDAA 		0,X			*GET FIRST NUMBER
	CMPA 		#SENTIN 			*IF IT REACH THE END OF THE ARRAY
	BEQ 		ENDWHI1			*STOP THE WHILE
	PSHX				*PUSH NARR ADDRESS TO STACK
	JSR 		SUB			*JUMP TO SUBROUTINE

	PULA				*PULL A FROM STACK OBTAIN THE VALUE
	PULB				*PULL B FROM STACKOBTAIN THE VALUE
	LDX 		temp			*GET THE VARIABLE ADDRESS
	STD 		0,X			*STORE	THE FIRST TWO BYTE RESULT TO THE ARRAY

	PULA							*PULL A FROM STACK OBTAIN THE VALUE
	PULB				*PULL B FROM STACKOBTAIN THE VALUE
	STD		2,X				*STORE	THE SECOND TWO BYTE RESULT TO THE ARRAY

	LDAB		#4			*BUMP 4 SLOTs
	ABX
	STX 		temp			* ASSIGN THE NEW VALUE TO THE TEMP VARIABLE
	PULX				*PULL X FROM STACK TO GET THE ADDRESS
	INX				*BUMP TO NEXT SLOT
	BRA 		WHILE1		*WHILE CONDITION
ENDWHI1									*END THE WHILE LOOP
DONE		BRA 		DONE


* NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
*       AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM


	ORG $D000
* start of your subroutine
SUB	DES		make space for return data
	DES
	DES
	DES
	PSHA		save A register
	PSHB		save B register
	PSHX		save X register
	PSHY		save Y register
	TPA
	PSHA		save CC register
	DES			OPEN HOLE FOR RESULT+2
	DES
	DES			OPEN HOLE FOR RESULT
	DES
	DES			OPEN HOLE FOR COUNT
	DES			OPEN HOLE FOR J
	DES			OPEN HOLE FOR SQUARE
	DES
	DES			OPEN HOLE FOR I
	DES
	TSX			GET VARIABLE ADDRESS

* 0,X SQUARE; 2,X I; 4,X RESULT; 6,X RESULT+2
* 8,X J; 9,X COUNT

	LDAA	16,X
	STAA	8,X			*J= THE VALUE IN ARRAY
	LDD		#0
	STD		4,X			* RESULT=0
	STD		6,X			*RESULT+2 =0
DO1	LDAA	8,X
	STAA	9,X			*J=COUNT
	LDD		#1
	STD		2,X			*I=1
	CLR		0,X
	CLR		1,X			*SQUARE =0
DO2	LDD	0,X			* DO 2
	ADDD	2,X
	STD		0,X			* SQUARE = SQUARE +I
	LDD		2,X
	ADDD	#2
	STD		2,X
	DEC		9,X
UNTIL2		BNE		DO2
ENDDO2		LDD		6,X				 * END DO2 LOOP
	ADDD	0,X
	STD 	6,X						*RESULT+2 = RESULT+2 + SQUARE
IF	BCC		ENDIF				*IF CONDITION
THEN 	LDD		4,X
	ADDD	#1					*	RESULT =RESULT +1
	STD 	4,X					* CHECK C FLAG
ENDIF		DEC 	8,X
UNTIL1	BNE 	DO1
ENDDO1							*END DO1 LOOP
	LDY 21,X					 *UPDATE RETURN ADDRESS
	STY	17,X

	LDD 6,X						*ASSIGN VALUE TO THE FIRST TWO BYTE
	STD 21,X
	LDD 4,X						* ASSIGN VALUE TO THE SECOND TWO BYTE
	STD 19,X
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	INS								*CLOSE HOLES
	PULA							* RESTORE A REGISTER
	TAP								*RESTORE CC REGISTER
	PULY							*RESTORE Y REGISTER
	PULX							* RESTORE X REGISTER
	PULB							* RESTORE B REGISTER
	PULA							* RESTORE A REGISTER
	RTS								* RETURN
				END					* END



*  The following is the SP table-- used for understanding the program
*  ________________________
* | 		SP points here 		 |
* |	0: SQUARE							 |
*	| 1: 			               |
* |	2: I									 |
* |	3:										 |
* |	4: RESULT							 |
* |	5:										 |
* |	6: RESULT + 2          |
* |	7:                     |
* |	8: J									 |
* |	9: COUNT 							 |
* |	10: A									 |
* |	11: YH								 |
* |	12:	YL								 |
* |	13: XH								 |
* |	14:	XL								 |
* |	15:	B									 |
* |	16:	A									 |
* |	17:										 |
* |	18:									   |
* |	19:										 |
* |	20:										 |
* |	21: RetH							 |
* |	22: RetL							 |
* |	23:	XH								 |
* |	24: XL								 |
* |________________________|
