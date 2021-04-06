
.macro rorR16pushToPORTB4
	ror r16						; t=1
	brcc anot_%					; t=2(1)
		sbi PORTB, 4			; t=2
		rjmp xx_%				; t=2
	anot_%:
		cbi PORTB, 4			; t=2
		nop						; t=1
	xx_%:
	nop							; t=1
	nop							; t=1
	microDelay [r17, 0xFF]		; T=765 <i*3>
	microDelay [r17, 0x14]		; T=60 <i*3>
	; sumT = 833
.endm



