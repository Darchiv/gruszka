.export start

.data

hello: .byte "hello world!", $0

.code

_some:
	lda #$46
	ldy #$89
	ldx #$38

.proc _main
	lda #$69
	ldx #$12
	brk
	.byte $69
	rts
.endproc

start:
	jsr _main
	rts