.export _mock_read_test_byte, _mock_read_rewind

.importzp ptr1

.data

Position: .byte <test_file, >test_file

.rodata
test_file:
.incbin "test.o65"

.code

; uint8_t __fastcall__ _mock_read_test_byte(void)
.proc _mock_read_test_byte
	lda Position + 1
	sta ptr1 + 1
	lda Position
	sta ptr1
	

    clc
    adc #$01
    sta Position
    lda Position + 1
    adc #$00
    sta Position + 1

	lda (ptr1)
	rts
.endproc

.proc _mock_read_rewind
	lda #<test_file
	sta Position
	lda #>test_file
	sta Position + 1
	rts
.endproc