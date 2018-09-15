.export _mock_read_test_byte, _mock_read_rewind

.importzp ptr1, tmp1

.data

PositionSh:		.byte <sh_file, >sh_file
PositionHello:	.byte <hello_file, >hello_file

.rodata
; Inclusion of executable files - mocking a filesystem.
sh_file:
.incbin "sh/sh.o65"
hello_file:
.incbin "hello/hello.o65"

.code

; uint8_t __fastcall__ _mock_read_test_byte(uint8_t fd)
.proc _mock_read_test_byte
	cmp #$0
	beq Shell
	cmp #$1
	beq Hello
	lda #$00
	bra Return

Shell:
	; Save position.
	lda PositionSh + 1
	sta ptr1 + 1
	lda PositionSh
	sta ptr1
	
	; Increment position cursor by 1.
    clc
    adc #$01
    sta PositionSh
    lda PositionSh + 1
    adc #$00
    sta PositionSh + 1
    bra LoadByte

Hello:
   	; Save position.
	lda PositionHello + 1
	sta ptr1 + 1
	lda PositionHello
	sta ptr1
	
	; Increment position cursor by 1.
    clc
    adc #$01
    sta PositionHello
    lda PositionHello + 1
    adc #$00
    sta PositionHello + 1
    bra LoadByte

LoadByte:
    ; Load that byte already.
	lda (ptr1)
Return:
	rts
.endproc

.proc _mock_read_rewind
	cmp #$0
	beq ShellRewind
	cmp #$1
	beq HelloRewind
	lda #$00
	bra ReturnRewind

ShellRewind:
	lda #<sh_file
	sta PositionSh
	lda #>sh_file
	sta PositionSh + 1

HelloRewind:
	lda #<hello_file
	sta PositionHello
	lda #>hello_file
	sta PositionHello + 1

ReturnRewind:
	rts
.endproc