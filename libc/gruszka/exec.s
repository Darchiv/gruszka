.export _exec

.import pushax, incsp4
.importzp sp

; int __fastcall__ exec (const char* progname, const char* cmdline)
.proc _exec
	jsr pushax

	lda sp
	ldx sp + 1

	brk
	.byte $05 ; SYS_EXEC

	; Drop parameters and return.
	jmp incsp4
.endproc