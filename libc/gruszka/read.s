.export _read

.import pushax, incsp6
.importzp sp

.macpack generic


.proc _read
	jsr pushax

	lda sp
	ldx sp + 1

	brk
	.byte $01 ; SYS_READ

	; Drop parameters and return.
	jmp incsp6
.endproc