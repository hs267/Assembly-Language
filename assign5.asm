**************************************
*
* Name: Han Song
* ID:
* Date:
* Lab5
*
* Program description:
*
*
* Pseudocode of Main Program:
*
*
*---------------------------------------
*
* Pseudocode Subroutine
*
*
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


	ORG $C000
	LDS	#$01FF		initialize stack pointer
* start of your program
	LDX	#NARR		initialize pointer1;
	LDY	#RESARR		initialize pointer2;
WHILE	LDAA	0,X		while(*pointer1 !=SENTINEL){
	CMPA	#$FF
	BEQ	ENDWHILE	  (*pointer in B register)
	JSR	SUB		  jump to subroutine
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


* NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
*       AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM


	ORG $D000
* start of your subroutine
SUB	DES		make space for return data
	PSHA		save A register
	PSHB		save B register
	PSHX		save X register
	PSHY		save Y register
	TPA
	PSHA		save CC register
