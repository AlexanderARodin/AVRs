
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
	; RESET WDT
	cli
	in r18,MCUSR			; save RES info
	ldi r16, 0				; and clear
	out MCUSR, r16
	;          76543210
	ldi r16, 0b00011000		; reset WDT
	ldi r17, 0b01000111		; reset preScaler
	out WDTCR, r16
	out WDTCR, r17

INIT:
	outi	[SPL, r16, low(RAMEND)]		; Stack
	outi	[DDRB, r16, 0b00011111]			; output
	
	setTxSilenceUsing [r17]
	ldi r16, 0x0A
	rcall typeCharDir
	ldi r16, 0x0A
	rcall typeCharDir
	ldi r16, 'R' 
	rcall typeCharDir
	ldi r16, 'E'
	rcall typeCharDir
	ldi r16, 'S'
	rcall typeCharDir
	ldi r16, '=' 
	rcall typeCharDir
		ldi r16,0x30
		add r16,r18
		rcall typeCharDir
	ldi r16, 0x0A
	rcall typeCharDir
	ldi r16, 0x0D
	rcall typeCharDir
	
	; setup timer0
	;outi	[TCCR0A, r16, 0];b01010010]		; settings for PWM
	outi	[TCCR0B, r16, 0b00000101]		; pre-scaler 1024
	outi	[TIMSK0, r16, 0b00000010]		; timer interrupts mask
	;outi	[OCR0A, r16, 200]
	;outi	[OCR0B, r16, 44]
	;outi	[GTCCR, r16, 1]

	sei						; Enable interrupts


MAIN:
	setTxSilenceUsing [r17]
	ldi r16, '.' 
	rcall typeChareSafe
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
typeChareSafe:
	;cli
	sendTxAChar [r16,r17]
	;sei
	ret

typeCharDir:
	sendTxAChar [r16,r17]
	ret


; -- waiting subroutine --
.equ Delay = 3;			; установка константы времени задержки
waitLong:
	ldi R20, Delay * 10
	rjmp WLoop0
Wait:
	LDI  R20, Delay		; загрузка константы для задержки в регистр R17
WLoop0:
	LDI  R18, 50		; загружаем число 50 (0x32) в регистр R18
WLoop1:
	LDI  R19, 0xC8		; загружаем число 200 (0xC8, $C8) в регистр R19
WLoop2:
	DEC  R19			; уменьшаем значение в регистре R19 на 1
	BRNE WLoop2			; возврат к WLoop2 если значение в R19 не равно 0
	DEC  R18			; уменьшаем значение в регистре R18 на 1
	BRNE WLoop1			; возврат к WLoop1 если значение в R18 не равно 0
	DEC  R20			; уменьшаем значение в регистре R17 на 1
	BRNE WLoop0			; возврат к WLoop0 если значение в R17 не равно 0
	RET					; возврат из подпрограммы Wait



; -- ################### --
; -- interrupts handlers --

TIM0_OVF:	; Timer0 Overflow Handler
	pushldi		[r16, 0b00000001]
	pushSreg	[r0]
	in r0, PORTB
	eor r0, r16
	out PORTB, r0
	popSreg	[r0]
	pop r16
	reti

TIM0_COMPA:	; Timer0 CompareA Handler
	pushldi		[r16, 0b00000010]
	pushSreg	[r0]
	in r0, PORTB
	eor r0, r16
	out PORTB, r0
	popSreg		[r0]
	pop r16
	reti

TIM0_COMPB:	; Timer0 CompareB Handler
	pushldi		[r16, 0b00000100]
	pushSreg	[r0]
	in r0, PORTB
	eor r0, r16
	out PORTB, r0
	popSreg 	[r0]
	pop r16
	reti

EXT_INT0:	; IRQ0 Handler
	sbi PORTB, 2
	reti

PC_INT0:	; PCINT0 Handler
	sbi PORTB, 2
	reti


EE_RDY:		; EEPROM Ready Handler
	sbi PORTB, 2
	reti

ANA_COMP:	; Analog Comparator Handler
	sbi PORTB, 2
	reti

WATCHDOG:	; Watchdog Interrupt Handler
	pushSreg [r16]
	push r17
		ldi r16, 'W' 
		rcall typeCharDir
		ldi r16, 'D'
		rcall typeCharDir
		ldi r16, 'G'
		rcall typeCharDir
		ldi r16, '!' 
		rcall typeCharDir
		ldi r16, 0x0A
		rcall typeCharDir
		ldi r16, 0x0D
		rcall typeCharDir
	pop r17
	popSreg [r16]
	reti

ADC_C:		; ADC Conversion Handler
	sbi PORTB, 2
	reti	; handler exit

; -- ################### --
; -- const data in FLASH --
Program_name: .DB "learning WDT"
