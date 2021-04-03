
.INCLUDEPATH "/usr/share/avra/"	; path to INC-files
.INCLUDE "tn13def.inc"			; macrodefinitions for AT***
.LIST							; generate listing

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
	ldi r16, low(RAMEND)	; Load top of RAM
	out SPL,r16				; Set Stack Pointer to top of RAM

INIT:
	ldi R16, 0b00011111		; mask for output Ports 
	out DDRB, R16			; load the mask from  R16 to  DDRB
	;sei						; Enable interrupts


.equ Delay = 1;			; установка константы времени задержки
MAIN:
	in r2,MCUSR
	ldi r16, 0
	out MCUSR, r16
tsttt:
	out PORTB, r2
	;rcall setAllPorts
	rcall waitLong
	rcall clearAllPorts
	rcall waitLong
	rjmp tsttt
	rcall setAllPorts
	rcall waitLong
	rcall clearAllPorts
	rcall waitLong
	rcall setAllPorts

LOOP:
	RCAll clearAllPorts
	RCALL Wait
	SBI PORTB, PORTB0
	RCALL Wait
	RCAll clearAllPorts
	RCALL Wait
	SBI PORTB, PORTB1
	RCALL Wait
	RCAll clearAllPorts
	RCALL Wait
	SBI PORTB, PORTB2
	RCALL Wait
	RCAll clearAllPorts
	RCALL Wait
	SBI PORTB, PORTB3
	RCALL Wait
	RCAll clearAllPorts
	RCALL Wait
	SBI PORTB, PORTB4
	RCALL Wait
	RJMP LOOP			; loop to LOOP

; -- waiting subroutine --
waitLong:
	ldi R17, Delay * 10
	rjmp WLoop0
Wait:
	LDI  R17, Delay			; загрузка константы для задержки в регистр R17
WLoop0:
	LDI  R18, 50			; загружаем число 50 (0x32) в регистр R18
WLoop1:
	LDI  R19, 0xC8			; загружаем число 200 (0xC8, $C8) в регистр R19
WLoop2:
	DEC  R19			; уменьшаем значение в регистре R19 на 1
	BRNE WLoop2			; возврат к WLoop2 если значение в R19 не равно 0
	DEC  R18			; уменьшаем значение в регистре R18 на 1
	BRNE WLoop1			; возврат к WLoop1 если значение в R18 не равно 0
	DEC  R17			; уменьшаем значение в регистре R17 на 1
	BRNE WLoop0			; возврат к WLoop0 если значение в R17 не равно 0
	RET					; возврат из подпрограммы Wait

clearAllPorts:
	ldi r16, 0
	out PORTB, r16
	ret

setAllPorts:
	ldi r16, 0b00011111
	out PORTB, r16
	ret

; -- ################### --
; -- interrupts handlers --

EXT_INT0:	; IRQ0 Handler
	reti

PC_INT0:	; PCINT0 Handler
	reti

TIM0_OVF:	; Timer0 Overflow Handler
	reti

EE_RDY:		; EEPROM Ready Handler
	reti

ANA_COMP:	; Analog Comparator Handler
	reti

TIM0_COMPA:	; Timer0 CompareA Handler
	reti

TIM0_COMPB:	; Timer0 CompareB Handler
	reti

WATCHDOG:	; Watchdog Interrupt Handler
	reti

ADC_C:		; ADC Conversion Handler
	reti	; handler exit

; -- ################### --
; -- const data in FLASH --
Program_name: .DB "basic template"
