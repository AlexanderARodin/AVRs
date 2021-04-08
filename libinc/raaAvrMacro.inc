



.macro	outi
	.message "outi must have params"
.endm
.macro	outi_i_8_i
	ldi		@1, @2
	out		@0, @1
.endm

.macro	pushldi
	.message "pushldi must have params"
.endm
.macro	pushldi_8_i	
	push	@0
	ldi		@0, @1
.endm

.macro	pushSreg
	.message "pushSreg must have params"
.endm
.macro	pushSreg_8
	push	@0
	in		@0, SREG
	push	@0
.endm

.macro	popSreg
	.message "popSreg must have params"
.endm
.macro	popSreg_8
	pop		@0
	out		SREG, @0
	pop		@0
.endm

.macro microDelay
	.message "microDelay must have params"
.endm

.macro	microDelay_8_i
; sumT = i*3
	ldi		@0, @1		; t=1
		loop_%:			;
		dec @0			; t=1
		brne loop_%		; t=2(1)
.endm

