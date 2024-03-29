
.includepath "/usr/share/avra/"	; path to INC-files
.include "tn13Adef.inc"			; macrodefinitions for AT***
.include "../libinc/raaAvrMacro.inc"
.include "../libinc/uartTxMacro.inc"
.list


.CSEG
.ORG 0x0000
0x0000:	rjmp RESET			; Reset Handler
0x0001:	rjmp EXT_INT0		; IRQ0 Handler
0x0002:	rjmp PC_INT0		; PCINT0 Handler
0x0003:	rjmp TIM0_OVF		; Timer0 Overflow Handler
0x0004:	rjmp EE_RDY			; EEPROM Ready Handler
0x0005:	rjmp ANA_COMP		; Analog Comparator Handler
0x0006:	rjmp TIM0_COMPA		; Timer0 CompareA Handler
0x0007:	rjmp TIM0_COMPB		; Timer0 CompareB Handler
0x0008:	rjmp WATCHDOG		; Watchdog Interrupt Handler
0x0009:	rjmp ADC_C			; ADC Conversion Handler

RESET:
	; -- RESET WDT
	cli
	in resetInfo, MCUSR			; save RES Info
	outiMain [MCUSR,0]			; clean RES Info
	outiMain [WDTCR, (1<<WDCE)|(1<<WDE)]; reset WDT
	outiMain [WDTCR,(1<<WDTIE)|(0<<WDP3)|(0<<WDP2)|(0<<WDP1)|(0<<WDP0)]; reset preScaler

INIT:
	outiMain	[SPL, low(RAMEND)]		; Stack
	outiMain	[DDRB, (1<<DDB4)|(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0)]		; output
	

	; -- setup timer0
	outiMain [TCCR0A, (1<<COM0A1)|(0<<COM0A0)|(0<<COM0B1)|(0<<COM0B0)|(1<<WGM01)|(1<<WGM00)] ; settings for PWM
	outiMain [TCCR0B, (0<<FOC0A)|(0<<FOC0B)|(0<<WGM02)|(1<<CS02)|(0<<CS01)|(1<<CS00)]	; pre-scaler 1024
	outiMain [TIMSK0, (0<<OCIE0A)|(0<<OCIE0B)|(1<<TOIE0)]			; timer interrupts mask
	outiMain [OCR0A, 0]
	outiMain [OCR0B, 44]
	;outi	[GTCCR, r16, 1]

	setTxSilenceUsing
	ldi argFunc, 0x0A
	rcall typeChar
	ldi argFunc, 0x0A
	rcall typeChar
	ldi argFunc, 'R' 
	rcall typeChar
	ldi argFunc, 'E'
	rcall typeChar
	ldi argFunc, 'S'
	rcall typeChar
	ldi argFunc, '=' 
	rcall typeChar
		ldi argFunc,0x30
		add argFunc,resetInfo
		rcall typeChar
	ldi argFunc, 0x0A
	rcall typeChar
	ldi argFunc, 0x0D
	rcall typeChar
	; -- enable interrupts
	sei


MAIN:
	cli
	setTxSilenceUsing
	ldi argFunc, '.' 
	rcall typeChar
	sei
	;in r16,TCNT0
	;rcall typeChareSafe

	rcall waitLong
	rcall waitLong
	rcall waitLong
	rcall waitLong
	rcall waitLong
	rcall waitLong
	rcall waitLong
	rcall waitLong
rjmp MAIN

; -- send char to Tx    --
typeChar:
	sendTxAChar
	ret


; -- waiting subroutine --
.equ Delay = 25			; установка константы времени задержки
waitLong:
	ldi tmpMain, Delay * 10
	rjmp WLoop0
wait:
	ldi tmpMain, Delay
	WLoop0:
		ldi altMain, 0xFF
		WLoop1:
		dec altMain
		brne WLoop1
	dec tmpMain
	brne WLoop0
	ret



; -- ################### --
; -- interrupts handlers --

TIM0_OVF:	; Timer0 Overflow Handler
	pushSregIRQ
	ldi altIRQ, (1<<PB2)
	in  tmpIRQ, PORTB
	eor tmpIRQ, altIRQ
	out PORTB,  tmpIRQ
	popSregIRQ
	reti

TIM0_COMPA:	; Timer0 CompareA Handler
	pushSregIRQ
	ldi altIRQ, (1<<PB0)
	in  tmpIRQ, PORTB
	eor tmpIRQ, altIRQ
	out PORTB,  tmpIRQ
	popSregIRQ
	reti

TIM0_COMPB:	; Timer0 CompareB Handler
	pushSregIRQ
	ldi altIRQ, (1<<PB1)
	in  tmpIRQ, PORTB
	eor tmpIRQ, altIRQ
	out PORTB,  tmpIRQ
	popSregIRQ
	reti

WATCHDOG:	; Watchdog Interrupt Handler
	pushSregIRQ
	in tmpIRQ, OCR0A
	ldi altIRQ, 0x02
	add tmpIRQ, altIRQ
	out OCR0A, tmpIRQ
	;rjmp WDTOUT

	push argFunc
	push tmpFunc
		ldi argFunc, 'W' 
		rcall typeChar
		ldi argFunc, 'D'
		rcall typeChar
		ldi argFunc, 'G'
		rcall typeChar
		ldi argFunc, '!' 
		rcall typeChar
		ldi argFunc, 0x0A
		rcall typeChar
		ldi argFunc, 0x0D
		rcall typeChar
	pop tmpFunc
	pop argFunc

	WDTOUT:
	popSregIRQ
	reti

EXT_INT0:	; IRQ0 Handler
	sbi PORTB, PB3
	reti
PC_INT0:	; PCINT0 Handler
	sbi PORTB, PB3
	reti
EE_RDY:		; EEPROM Ready Handler
	sbi PORTB, PB3
	reti
ANA_COMP:	; Analog Comparator Handler
	sbi PORTB, PB3
	reti
ADC_C:		; ADC Conversion Handler
	sbi PORTB, PB3
	reti	; handler exit

; -- ################### --
; -- const data in FLASH --
Program_name: .DB "practice PWD+WDT"
