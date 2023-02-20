.INCLUDEPATH "/usr/share/avra/"	; path to INC-files
.INCLUDE "m8def.inc"			; macrodefinitions for AT***
.LIST								; generate listing

.CSEG								; code segment
.ORG 0x0000						; start address
0x0000	rjmp RESET			;External Pin, Power-on Reset, Brown-out Reset, and Watchdog Reset
0x0001	rjmp OTHER_IRQ		;test closure
0x0002	rjmp OTHER_IRQ		;test closure
0x0003	rjmp OTHER_IRQ		;test closure
0x0004	rjmp OTHER_IRQ		;test closure
0x0005	rjmp OTHER_IRQ		;test closure
0x0006	rjmp OTHER_IRQ		;test closure
0x0007	rjmp OTHER_IRQ		;test closure
0x0008	rjmp OTHER_IRQ		;test closure
0x0009	rjmp OTHER_IRQ		;test closure
0x000A	rjmp OTHER_IRQ		;test closure
0x000B	rjmp OTHER_IRQ		;test closure
0x000C	rjmp OTHER_IRQ		;test closure
0x000D	rjmp OTHER_IRQ		;test closure
0x000E	rjmp OTHER_IRQ		;test closure
0x000F	rjmp OTHER_IRQ		;test closure
0x0010	rjmp OTHER_IRQ		;test closure
0x0011	rjmp OTHER_IRQ		;test closure
0x0013	rjmp OTHER_IRQ		;test closure
0x0014	rjmp OTHER_IRQ		;test closure
0x0015	rjmp OTHER_IRQ		;test closure
0x0016	rjmp OTHER_IRQ		;test closure
0x0017	rjmp OTHER_IRQ		;test closure
0x0018	rjmp OTHER_IRQ		;test closure
0x0019	rjmp OTHER_IRQ		;test closure
0x001A	rjmp OTHER_IRQ		;test closure
0x001B	rjmp OTHER_IRQ		;test closure
0x001C	rjmp OTHER_IRQ		;test closure
0x001D	rjmp OTHER_IRQ		;test closure
0x001E	rjmp OTHER_IRQ		;test closure
0x001F	rjmp OTHER_IRQ		;test closure


RESET:
	ldi r16, high(RAMEND)	;
	out SPH,r16					;
	ldi r16, low(RAMEND)		; Load top of RAM
	out SPL,r16					; Set Stack Pointer to top of RAM
	sei

INIT:
	ldi r16, 0
	out DDRB, r16
	
	ldi R16, 0
	ldi r18, 0x00
	ldi r19, 0xFF
MAIN:

LOOP:
	out PORTB, r18
	nop
	in r30, PINB
	nop
	inc r16
	nop
	out PORTB, r19
	nop
	in r30, PINB
	RJMP LOOP					; loop to LOOP


; -- ################### --
; -- interrupts handlers --

OTHER_IRQ:		;test closure
	ldi r31, 0xFF
deadLoop:
	rjmp deadLoop
	reti


; -- ################### --
; -- const data in FLASH --
Program_name: .DB "basic qemu template"
