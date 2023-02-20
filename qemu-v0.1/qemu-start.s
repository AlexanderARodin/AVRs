.INCLUDEPATH "/usr/share/avra/"	; path to INC-files
.INCLUDE "m8def.inc"			; macrodefinitions for AT***
.LIST							; generate listing

.CSEG								; code segment
.ORG 0x0000						; start address
0x0000:	rjmp RESET			; Reset Handler
0x0001:	rjmp EXT_INT0		; IRQ0 Handler
0x0002:	rjmp PC_INT0		; PCINT0 Handler
0x0003:	rjmp TIM0_OVF		; Timer0 Overflow Handler
0x0004:	rjmp EE_RDY			; EEPROM Ready Handler
0x0005:	rjmp ANA_COMP		; Analog Comparator Handler
0x0006:	rjmp TIM0_COMPA	; Timer0 CompareA Handler
0x0007:	rjmp TIM0_COMPB	; Timer0 CompareB Handler
0x0008:	rjmp WATCHDOG		; Watchdog Interrupt Handler
0x0009:	rjmp ADC_C			; ADC Conversion Handler

RESET:
	ldi r16, low(RAMEND)		; Load top of RAM
	out SPL,r16					; Set Stack Pointer to top of RAM
	
	ldi r16, 0
	out DDRB, r16
	
	sei

INIT:
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

EXT_INT0:	; IRQ0 Handler
	ldi r21, 123
	reti

PC_INT0:	; PCINT0 Handler
	ldi r22, 123
	reti

TIM0_OVF:	; Timer0 Overflow Handler
	ldi r23, 123
	reti

EE_RDY:		; EEPROM Ready Handler
	ldi r24, 123
	reti

ANA_COMP:	; Analog Comparator Handler
	ldi r25, 123
	reti

TIM0_COMPA:	; Timer0 CompareA Handler
	ldi r26, 123
	reti

TIM0_COMPB:	; Timer0 CompareB Handler
	ldi r27, 123
	reti

WATCHDOG:	; Watchdog Interrupt Handler
	ldi r28, 123
	reti

ADC_C:		; ADC Conversion Handler
	ldi r29, 123
	reti	; handler exit

; -- ################### --
; -- const data in FLASH --
Program_name: .DB "basic qemu template"
