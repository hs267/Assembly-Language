***************************************
*
* Name: Han Song
* ID:   14253499
* Date: Nov 1
* Lab 4
*
* Program description:
* This program is to find the sum of the squared numbers from the NARR, then we store the
* result into a new array called RESARR. the result will be ordered listed in the RESARR
* array
*
* Pseudocode of Main Program:
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
*---------------------------------------
*
* Pseudocode of Subroutine:
*
* unsigned int N= value passed from main;
* unsigned int RESULT
* unsigned int COUNT
* unsigned int I
* unsigned int J
* unsigned int SQUARE
*
*     RESULT = 0;
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
*		pull x from the stack to get the address
*		push B & A  onto stack in order to get the value
*   push x onto stack to let the stack have the address
*		return main
*
***************************************
* start of data section
		ORG 		$B000
NARR		FCB		1, 2, 5, 100, 150, 200, 250, 254, $FF
SENTIN		EQU		$FF

		ORG 		$B010
RESARR		RMB		32



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.

temp		RMB		4

		ORG	 	$C000
		LDS		#$01FF			*initialize stack pointer
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



* define any other variables that you might need here using RMB (not FCB or FDB)
* remember that your main program must not access any of these variables, including
SQUARE		RMB		2
I		RMB		2
COUNT		RMB		1
J		RMB		1
RESULT		RMB		4

		ORG 		$D000
* start of your subroutine
SUB		STAA		J		*J= THE VALUE IN ARRAY
		LDD		#0
		STD		RESULT		* RESULT=0
		STD		RESULT+2		*RESULT+2 =0
DO1		LDAA		J
		STAA		COUNT  *J=COUNT
		LDD		#1
		STD		I				*I=1
		CLR		SQUARE			*SQUARE =0
		CLR		SQUARE+1
DO2		LDD		SQUARE  * DO 2
		ADDD		I
		STD		SQUARE			* SQUARE = SQUARE +I
		LDD		I
		ADDD		#2
		STD		I
		DEC		COUNT
UNTIL2		BNE		DO2
ENDDO2		LDD		RESULT+2   * END DO2 LOOP
		ADDD		SQUARE
		STD		RESULT+2				*RESULT+2 = RESULT+2 + SQUARE
IF		BCC		ENDIF				*IF CONDITION
THEN		LDD		RESULT
		ADDD		#1				*	RESULT =RESULT +1
		STD		RESULT    * CHECK C FLAG
ENDIF		DEC		J
UNTIL1		BNE		DO1
ENDDO1		PULX  				*END DO1 LOOP
		LDD		RESULT+2	     *ASSIGN VALUE TO THE FIRST TWO BYTE
		PSHB									*SEND THE SUM TO THE STACK
		PSHA									*SEND THE SUM TO THE STACK

		LDD		RESULT					* ASSIGN VALUE TO THE SECOND TWO BYTE
		PSHB								*SEND THE SUM TO THE STACK
		PSHA									*SEND THE SUM TO THE STACK

		PSHX								*SEND ADDRESS TO STACK
		RTS									* RETURN TO Main
		END									* END THE PROGRAM
