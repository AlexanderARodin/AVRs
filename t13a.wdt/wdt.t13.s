
.includepath "/usr/share/avra/"	; path to INC-files
.include "tn13Adef.inc"			; macrodefinitions for AT***
.include "../libinc/raaAvrMacro.inc"
.include "../libinc/uartTxMacro.inc"
.list

.CSEG					; code segment
.ORG 0x0000				; start address
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
	outi	[SPL, r16, low(RAMEND)]			; Set Stack Pointer to top of RAM
	outi	[PORTB, r16, 0xff]				; pull-up all	


INIT:
	outi	[DDRB, r16, 0b00011111]			; output

	rcall processRestartConditions

	outi	[TIMSK0, r16, 0b00001100]		; timer interrupts mask
	outi	[TCCR0A, r16, 0b01010010]		; settings for PWM
	outi	[TCCR0B, r16, 0b00000101]		; pre-scaler 1024
	outi	[OCR0A, r16, 200]
	outi	[OCR0B, r16, 44]
	;outi	[GTCCR, r16, 0b00000001]		; start tcnt0
	sei						; Enable interrupts


MAIN:
	setTxSilenceUsing [r17]
	ldi r16, 'r' 
	rcall sendCharToTx
	ldi r16, 'a'
	rcall sendCharToTx
	ldi r16, 'a'
	rcall sendCharToTx
	ldi r16, 'U' 
	rcall sendCharToTx
	ldi r16, 'A'
	rcall sendCharToTx
	ldi r16, 'R'
	rcall sendCharToTx
	ldi r16, 'T'
	rcall sendCharToTx
	ldi r16, '*' 
	rcall sendCharToTx
	ldi r16, '~'
	rcall sendCharToTx
	ldi r16, 0x0A
	rcall sendCharToTx
	ldi r16, 0x0D
	rcall sendCharToTx

	rcall waitLong
	rcall waitLong
rjmp MAIN

; -- send char to Tx    --
sendCharToTx:
	cli
	sendTxAChar [r16,r17]
	sei
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

clearAllPorts:
	outi [PORTB, r16, 0]
	ret

setAllPorts:
	outi [PORTB, r16, 0b00011111]
	ret

processRestartConditions:
	ldi		r16, 0
	in r2,MCUSR
	out MCUSR, r16
	out	PORTB, r2
	rcall waitLong
	out	PORTB, r16
	rcall waitLong
	out	PORTB, r2
	rcall waitLong
	out	PORTB, r16
	rcall waitLong
	out	PORTB, r2
	rcall waitLong
	out	PORTB, r16
	rcall waitLong
	ret


; -- ################### --
; -- interrupts handlers --

TIM0_OVF:	; Timer0 Overflow Handler
	pushldi		[r16, 0b00000010]
	pushSreg	[r0]
	in r0, PORTB
	eor r0, r16
	;out PORTB, r0
	popSreg	[r0]
	pop r16
	reti

TIM0_COMPA:	; Timer0 CompareA Handler
	pushldi		[r16, 0b00000100]
	pushSreg	[r0]
	in r0, PORTB
	eor r0, r16
	out PORTB, r0
	popSreg		[r0]
	pop r16
	reti

TIM0_COMPB:	; Timer0 CompareB Handler
	pushldi		[r16, 0b00001000]
	pushSreg	[r0]
	in r0, PORTB
	eor r0, r16
	out PORTB, r0
	popSreg 	[r0]
	pop r16
	reti

EXT_INT0:	; IRQ0 Handler
	sbi PORTB, 4
	reti

PC_INT0:	; PCINT0 Handler
	sbi PORTB, 4
	reti


EE_RDY:		; EEPROM Ready Handler
	sbi PORTB, 4
	reti

ANA_COMP:	; Analog Comparator Handler
	sbi PORTB, 4
	reti

WATCHDOG:	; Watchdog Interrupt Handler
	sbi PORTB, 4
	reti

ADC_C:		; ADC Conversion Handler
	sbi PORTB, 4
	reti	; handler exit

; -- ################### --
; -- const data in FLASH --
Program_name: .DB "making uart.Tx"
