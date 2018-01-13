.export _malloc, _free

.import __RAM_LAST__
.import pushax, tosaddax
.importzp ptr1

.data
free_pointer:	.byte $00, $00
.code

.proc _malloc
		sta ptr1                    ; Store size in ptr1
        stx ptr1+1

		; Check for a size of zero, if so, return NULL
        ora ptr1+1
        beq done

        ; if not initialised, then initialise it
        lda	free_pointer
        ora	free_pointer + 1
        bne initialised

		lda #<__RAM_LAST__
		sta free_pointer
		ldx #>__RAM_LAST__
		stx free_pointer + 1

initialised:
		lda ptr1
        ldx ptr1+1

        clc
        adc free_pointer
        tay
        txa
        adc free_pointer + 1
        tax
        tya

done:
		rts
.endproc

.proc _free
		rts
.endproc