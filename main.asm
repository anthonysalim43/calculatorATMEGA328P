;
; lab1 first project.asm
;
; Created: 2/14/2023 9:08:54 AM
; Author : Anthony
;

.include "m328pdef.inc"
;your own register definition
.def JOYSTICK_POSITION = R2 
; Replace with your application code
;start:
 ;   inc r16
  ;  rjmp start

.INCLUDE "m328pdef.inc" ; Load addresses of (I/O) registers
.ORG 0x0000
RJMP init ; First instruction that is executed by the microcontroller

init:
;Configure output pin PC2
SBI DDRB,3 ; Pin Pb3 is an input,it has the data
SBI PORTB,3 ; Output Vcc => LED1 is turned off!

;Configure output pin PC2
SBI DDRB,4 ; Pin Pb2 is an output,output for the screen
SBI PORTB,4 ; Output Vcc => LED1 is turned off!
;Configure output pin PC2
SBI DDRB,5 ; Pin Pb5 is an output,clock for the screen
SBI PORTB,5 ; Output Vcc => LED1 is turned off!

	LDI R19,8   ;To do multiplication when i read the value from Y because i have 8 byte
		LDI R23,0b00000001	
			LDI R20,0   ; zero for 16-bit add		
LDI YL,Low(0x0100);the addres if th SRAM start 0x0100 and use Y register to access it
LDI YH,High(0x0100)
LDI R16,11
LDI R17,0
ST Y+, R17; block 11
ST Y+, R17; block 12
ST Y+, R17; block 13
ST Y+, R17; block 14
ST Y+, R17; block 15
;ST Y+, R17; block 16
storingSRAM:
	ST Y+, R17
	INC R17
	DEC R16
	BRNE storingSRAM



main :

/*CBI PORTB,4;Not sure why yet*/

; SCREEN BUFFER INIT


	
/*	LDI R18,0   ;this represent the row, i need to add after multiplying to 8 and keep looping until it is 7(we started with 0 so 8 byte 0->7*/


	
Screen:
	;LDI RX,1;hayda RX(you need to change X an put a number) ha yhadedle aya ra2em bede farje ha ykoun input keyboard bs for now i will fix it for element'1', fa bede zid 3a z 1*8 after initializing

	
	;what i want to do is to put back Y at the start and read all the register value in y address(indirect=>LD not immediate)

	           ;We have 16 block each block i need to read the value in the next addres of Y
	
	send1row2:
	LDI R18,0 
	
	send1row:
	LDI YL,Low(0x0100)    ;the addres if th SRAM start 0x0100 and use Y register to access it
	LDI YH,High(0x0100)
	
	LDI R16, 16
	nextBlock:
		LD R17,Y+;I PUT THE VALUE IN THE ADDRESS OF y THEN ADD ONE TO GET THE NEXT VALUE 
		MUL R19,R17; i need to multiply by 8 because i have 8 bytes the result is save in R0 and R1, this value is for the first roo wand first block i need to go for all the block=> all the address in Y	
		ADD R0,R18
		ADC R1,R20

		LDI ZH,High(charTable<<1)
		LDI ZL,Low(charTable<<1);to get the addres of the table
		ADD ZL,R0
		ADC ZH,R1
		LPM R21,Z;
		LDI R22,5; i want to read the first 5 bit 
		oneBlock:
			ROR R21
;			CLC;Clearing the carry
CBI PORTB,3; YOU NEED TO CHECK IN CASE carry is one if i ba3mol skip this line or not
			BRCC CarryZero;Branch in case carry is zero
			SBI PORTB,3

				
			CarryZero:
			SBI PORTB,5
			CBI PORTB,5
			DEC R22
			BRNE oneBlock

		DEC R16
		BRNE nextBlock

		;MOV R24,R23;R21 5alast mena 3melt decrement kelchi w maba2 3ayza fa fine erja3 3ouza
		LDI R22,8;Same for R20 8 is because i want to send 8 rows
		CLC
		sendingRow:

			ROR R23;0000 0010
			CBI PORTB,3; YOU NEED TO CHECK IN CASE carry is one if i ba3mol skip this line or not
			BRCC rowZero;Branch in case carry is zero
				SBI PORTB,3
			rowZero:
			SBI PORTB,5
			CBI PORTB,5
			DEC R22
			BRNE sendingRow
			SBI PORTB,4
			LDI R20,255
			DELAY:
			DEC R20
			BRNE DELAY 
			CBI PORTB,4;Not sure why yet
			INC R18;Because next loop i want the next byte for the second row

			TST R23
			BRNE send1row
			rol R23
			RJMP send1row2
		;LSL R23
		
					
RJMP main

charTable:
.db 0b00000000,0b00000000,0b00000000,0b00000000,0b00000000,0b00000000,0b00000000,0b00000000;off
.db 0b00000000,0b00011111,0b00000001,0b00000001,0b00011111,0b00010001,0b00010001,0b00011111 ;9
.db 0b00000000,0b00011111,0b00010001,0b00010001,0b00011111,0b00010001,0b00010001,0b00011111 ;8
.db 0b00000000,0b00000001,0b00000001,0b00000001,0b00011111,0b00000001,0b00000001,0b00011111 ;7
.db 0b00000000,0b00011111,0b00010001,0b00010001,0b00011111,0b00010000,0b00010000,0b00011111 ;6
.db 0b00000000,0b00011111,0b00000001,0b00000001,0b00011111,0b00010000,0b00010000,0b00011111 ;5
.db 0b00000000,0b00000001,0b00000001,0b00000001,0b00011111,0b00010001,0b00010001,0b00010001 ;4
.db 0b00000000,0b00011111,0b00000001,0b00000001,0b00011111,0b00000001,0b00000001,0b00011111 ;3
.db 0b00000000,0b00011111,0b00010000,0b00010000,0b00011111,0b00000001,0b00000001,0b00011111 ;2
.db 0b00000000,0b00011111,0b00000100,0b00000100,0b00000100,0b00010100,0b00001100,0b00000100 ;1
.db 0b00000000,0b00011111,0b00010001,0b00010001,0b00010001,0b00010001,0b00010001,0b00011111 ;0











 