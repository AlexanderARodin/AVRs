; -- -- -- -- -- -- -- --	;
.set	txPORT = PORTB		;
.set	txPIN  = 4			;
.set	txBitDelay = 0x19	;
; -- -- -- -- -- -- -- --	;



.macro setTxMark
	sbi txPORT, txPIN
.endm
.macro setTxSpace
	cbi txPORT, txPIN
.endm


.macro setTxSilenceUsing
	.message "needs params"
.endm
.macro setTxSilenceUsing_8
	setTxMark
	microDelay [@0, (txBitDelay+2)]		; T=81 <i*3>
; sumT =  83
.endm


.macro sendTxAChar
	.message "needs params"
.endm
.macro sendTxAChar_8_8
	;start-bit
	setTxSpace
	microDelay [@1, (txBitDelay+2)]	; T=81 <i*3>
	; sumT =  83
	rorR16pushToPORTB4 [@0,@1]	; T= 83
	 rorR16pushToPORTB4 [@0,@1]	; T= 83
	  rorR16pushToPORTB4 [@0,@1]	; T= 83
	   rorR16pushToPORTB4 [@0,@1]	; T= 83
	rorR16pushToPORTB4 [@0,@1]	; T= 83
	 rorR16pushToPORTB4 [@0,@1]	; T= 83
	  rorR16pushToPORTB4 [@0,@1]	; T= 83
	   rorR16pushToPORTB4 [@0,@1]	; T= 83
	;stop-bit
	setTxMark
	microDelay [@1, (txBitDelay+2)]	; T=81 <i*3>
	; sumT =  83
	ret
.endm



.macro rorR16pushToPORTB4
	.message "needs params"
.endm
.macro rorR16pushToPORTB4_8_8
	ror @0							; t=1
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
	microDelay [@1, txBitDelay]	; T=75 <i*3>
; sumT = 83
.endm



