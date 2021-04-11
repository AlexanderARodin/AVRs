.def	tmpMain		= r16	;
.def	altMain		= r17	;
							;
.def	tmpIRQ		= r18	;
.def	altIRQ		= r19	;
							;
.def	argFunc		= r20	;
.def	tmpFunc		= r21	;
							;
.def	resetInfo	= r15	;
;	--	--	--	--	--	--	;



.macro pushSregIRQ
	in tmpIRQ, SREG		; t=1
	push tmpIRQ			; t=2
.endm
.macro popSregIRQ
	pop tmpIRQ			; t=2
	out SREG, tmpIRQ	; t=1
.endm

.macro pushArgFunc
	push argFunc		; t=2
.endm
.macro popArgFunc
	pop argFunc			; t=2
.endm
.macro pushResFunc
	push resFunc		; t=2
.endm
.macro popResFunc
	pop resFunc			; t=2
.endm


.macro outiMain
	.message "mast have params"
.endm
.macro outiMain_i_i
	ldi tmpMain, @1		; t=1
	out @0, tmpMain		; t=1
.endm






.macro microDelay
	.message "microDelay must have params"
.endm
.macro	microDelay_i
; sumT = i*3
	ldi		tmpFunc, @0		; t=1
		loop_%:				;
		dec tmpFunc			; t=1
		brne loop_%			; t=2(1)
.endm

