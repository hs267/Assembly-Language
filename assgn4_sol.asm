**************************************
*
* Name: Steve Vai
* ID: 123456
* Date: 11/03/17
* Lab4
*
* Program description:
* This program will go through a table of 1-byte numbers with sentinel $FF and
* will send each number to a subroutine via call-by-value in register. 
* The subroutine will generate the sum of squares according to the value sent down
* and will send the 4-byte result back to the main program via call-by-value over stack. 
* The main program will store the result in the RESARR array. 
*
* Pseudocode of Main Program:
*
* unsigned int NARR[];
* unsigned int RESARR[];
*
* pointer1=&NARR[0];
* pointer2=&RESARR[0];
* while (*pointer1 != sentinel){
*	A-register= *pointer1;
*	call subroutine;
*	get 4-byte sum off the stack;
*	store it to memory where pointer2 is pointing to;
*	pointer2+=4;
*	pointer1++;
* }
* END
*
*
*---------------------------------------
*
* Local subroutine variables
*
* unsigned int RESULT (4-byte variable)
* unsigned int COUNT  (1-byte variable)
* unsigned int I (2-byte variable)
* unsigned int J (1-byte variable)
* unsigned int SQUARE (2-byte variable)
*
* Pseudocode Subroutine
*
*     N = value sent to the subroutine
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
*
*    TMPY = Y (temporarily store Y register)
*    pull return address off
*    push lower two bytes of result onto stack
*    push upper two bytes of result onto stack
*    push return address back
*    Y = TMPY (restore Y register)
*    RTS 
*
**************************************


* start of data section
	ORG $B000
NARR	FCB	1, 2, 5, 100, 150, 200, 250, 254, $FF
SENTIN	EQU	$FF

	ORG $B010
RESARR	RMB	32	



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.



	ORG $C000
	LDS	#$01FF	        initialize stack pointer;
* start of your main program
	LDX	#NARR		initialize pointer1;
	LDY	#RESARR		initialize pointer2;
WHILE	LDAA	0,X		while(*pointer1 !=SENTINEL){
	CMPA	#$FF		
	BEQ	ENDWHILE	  (*pointer in B register)
	JSR	SUMSQU		  jump to subroutine
	PULA
	PULB			  get upper two result bytes off the stack
	STD	0,Y		  store them in RESARR array
	PULA
	PULB 			  get lower two result bytes off the stack
	STD	2,Y		  store them in RESARR array
	LDAB	#$4
	ABY			  pointer2+=4;
	INX			  pointer1++;
	BRA	WHILE	       }
ENDWHILE
DONE	BRA	DONE



* define any variables that your SUBROUTINE might need here
N	RMB	1
RESULT	RMB	4
COUNT	RMB	1
SQUARE	RMB	2
I	RMB	2
J	RMB	1
TMPY	RMB	2



	ORG $D000
* start of your subroutine
SUMSQU	STAA	N		N = value sent to subroutine
	LDD	#0
	STD	RESULT
	STD	RESULT+2	RESULT = 0;
	LDAA	N
	STAA	J		J=N
DO1	LDAA	J		DO{
	STAA	COUNT		  COUNT = J; 
	LDD	#1
	STD	I		  I = 1;
	CLR	SQUARE
	CLR	SQUARE+1	  SQUARE = 0;
DO2	LDD	SQUARE		  DO{
	ADDD	I
	STD	SQUARE		    SQUARE = SQUARE + I;
	LDD	I
	ADDD	#2
	STD	I		    I+=2;
	DEC	COUNT		    COUNT--;
UNTIL2	BNE	DO2		  } until (COUNT == 0);
ENDDO2	LDD	RESULT+2
	ADDD	SQUARE
	STD	RESULT+2	 lower two bytes of RESULT += lower two bytes of SQUARE;
IF	BCC	ENDIF		 if (carry set){
THEN	LDD	RESULT
	ADDD	#1		    upper two bytes of RESULT += 1;
	STD	RESULT	              }
ENDIF	DEC	J		 J --;
UNTIL1	BNE	DO1 		} until (J==0)
ENDDO1	STY	TMPY		temporarily store Y register
	PULY			pull return address off
	LDD	RESULT+2
	PSHB
	PSHA			push lower two bytes of result onto stack
	LDD	RESULT
	PSHB
	PSHA			push upper two bytes of result onto stack
	PSHY			push return address back
	LDY	TMPY		restore Y register
	RTS
	END
