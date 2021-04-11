; -- -- -- -- -- -- -- --	;
.set	txPORT = PORTB		;
.set	txPIN  = PB4		;
.set	txBitDelay = 0x19	;
; -- -- -- -- -- -- -- --	;



.macro setTxMark
	sbi txPORT, txPIN	; t=2
.endm
.macro setTxSpace
	cbi txPORT, txPIN	; t=2
.endm


.macro setTxSilenceUsing
	setTxMark
	microDelay [(txBitDelay+2)]		; T=81 <i*3>
; sumT =  83
.endm


.macro sendTxAChar
	;start-bit
	setTxSpace
	microDelay [(txBitDelay+2)]	; T=81 <i*3>
	; sumT =  83
	rorR16pushToPORT	; T= 83
	 rorR16pushToPORT	; T= 83
	  rorR16pushToPORT	; T= 83
	   rorR16pushToPORT	; T= 83
	rorR16pushToPORT	; T= 83
	 rorR16pushToPORT	; T= 83
	  rorR16pushToPORT	; T= 83
	   rorR16pushToPORT	; T= 83
	;stop-bit
	setTxMark
	microDelay [(txBitDelay+2)]	; T=81 <i*3>
	; sumT =  83
	ret
.endm



.macro rorR16pushToPORT
	ror argFunc						; t=1
	brcc anot_%						; t=2(1)
		setTxMark					; t=2
		rjmp xx_%					; t=2
	anot_%:
		setTxSpace					; t=2
		nop							; t=1
	xx_%:
	; sumT = 6
	nop								; t=1
	nop								; t=1
	microDelay [txBitDelay]	; T=75 <i*3>
; sumT = 83
.endm



