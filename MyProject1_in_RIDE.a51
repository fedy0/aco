; 							ADOREMUS IN AETEMUM SANCISSIMUM SACRAMENTUM

; *** File Name: ACOSmain.asm
; *** Project: Automatic Change Over Switch for 3 phases and generator sypplies
; *** Author: FEDYRONIX INC.
; *** Date: 04/01/2007
; *** Processor: Atmel AT89C1051 Microcontroller (Compatible With MCS-51)
; *** Priority Switch: 4 DIP SW
; *** Phase Selector Driver: ULN2001

; A PROGRAM THAT MONITORS THE PHASE INDISCATORS AND SWITCHES THE PHASE SELECTORS ACCORDINGLY
 
; ====================================== DEFINITIONS ==================================================

; ========================================== MAIN =====================================================
$INCLUDE	(REG51.INC) 
				ORG		0000H
				JMP		MAIN					; ON SYSTEM RESET, JUMP TO MAIN

; =====================================================================================================
				ORG		0006H					; START AT THIS ADDRESS
MAIN:			
				MOV		P1, #0FH				; MAKE THE LSB OF P1 INPUT PORTS

REPEAT:		
				JB		P1.0, R_PHASE			; IS RED PHASE ON? IF YES TURN OFF GEN
				CLR		P1.4

				JB		P1.1, Y_PHASE			; IS YELLOW PHASE ON? IF YES TURN OFF GEN
				CLR		P1.5

				JB		P1.2, B_PHASE			; IS BLUE PHASE ON? IF YES TURN OFF GEN
				CLR		P1.6

				SETB	P1.7					; TURN ON THE GENERATOR

				SJMP	REPEAT

; =====================================================================================================
R_PHASE:		ACALL	R_TURN_OFF_GEN
				SJMP	REPEAT
Y_PHASE:		ACALL	Y_TURN_OFF_GEN
				SJMP	REPEAT
B_PHASE:		ACALL	B_TURN_OFF_GEN
				SJMP	REPEAT   

;======================================================================================================
R_TURN_OFF_GEN:	
				CLR		P1.7					; TURN OFF THE GENERATOR
				CLR		P1.5					; CLEAR ALL (TURN OFF) OTHER PIN LINES/PHASE SWITCHES
				CLR		P1.6					
				ACALL	DELAY					; CALL DELAY FOR PROTECTION
				SETB	P1.4					; CONNECT THE RED PHASE
				JB		P1.0, $					; STAY HERE AS LONG AS THE RED PHASE IS ON
				CLR		P1.4					; ELSE RED PHASE IS OFF, DISCONNECT	R
				ACALL	DELAY					; CALL DELAY FOR PROTECTION
				RET

Y_TURN_OFF_GEN:
				CLR		P1.7					; TURN OFF THE GENERATOR
				CLR		P1.6					; CLEAR ALL (TURN OFF) OTHER PIN LINES/PHASE SWITCHES
				CLR		P1.4					
				ACALL	DELAY					; CALL DELAY FOR PROTECTION
				SETB	P1.5					; CONNECT THE YELLOW PHASE
				JB		P1.1, $					; STAY HERE AS LONG AS THE YELLOW PHASE IS ON
				CLR		P1.5					; ELSE YELLOW PHASE IS OFF, DISCONNECT Y
				ACALL	DELAY					; CALL DELAY FOR PROTECTION
				RET

B_TURN_OFF_GEN:
				CLR		P1.7					; TURN OFF THE GENERATOR
				CLR		P1.5					; CLEAR ALL (TURN OFF) OTHER PIN LINES/PHASE SWITCHES
				CLR		P1.4
				ACALL	DELAY					; CALL DELAY FOR PROTECTION
				SETB	P1.6					; CONNECT THE BLUE PHASE
				JB		P1.2, $					; STAY HERE AS LONG AS THE BLUE PHASE IS ON
				CLR		P1.6					; ELSE BLUE PHASE IS OFF, DISCONNECT B
				ACALL	DELAY					; CALL DELAY FOR PROTECTION
				RET

; ============================== DELAY USED FOR SAFETY/PROTECTION =====================================
DELAY:			
				MOV		R0, #0FFH 
J:				MOV		R1, #0FFH
				DJNZ	R1, $
				DJNZ	R0, J
				RET

				END 
