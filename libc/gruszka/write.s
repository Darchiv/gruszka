.export _write

.import pushax, incsp6
.importzp sp

.macpack generic


.proc _write
	jsr pushax

	lda sp
	ldx sp + 1

	brk
	.byte $02 ; SYS_WRITE

	; Drop parameters and return.
	jmp incsp6
.endproc