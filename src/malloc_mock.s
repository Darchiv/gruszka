.export _malloc, _free

.import __RAM_LAST__
.import pushax, tosaddax
.importzp ptr1

.data
free_pointer:	.byte $00, $00
.code

.proc _malloc
        ; Store size in ptr1
        sta ptr1                   
        stx ptr1+1

        ; Check for a size of zero, if so, return NULL
        ora ptr1+1
        beq done

        ; if not initialised, then initialise it
        lda free_pointer
        ora free_pointer + 1
        bne initialised

	lda #<__RAM_LAST__
	sta free_pointer
	ldx #>__RAM_LAST__
	stx free_pointer + 1

initialised:
        ; Save current free pointer.
        lda free_pointer
        pha
        lda free_pointer + 1
        pha

        ; Load the size argument
        lda ptr1
        ldx ptr1 + 1

        ; Calculate next free address with the size argument.
        clc
        adc free_pointer
        sta ptr1
        txa
        adc free_pointer + 1
        sta ptr1 + 1

        ; Restore the free pointer.
        plx
        pla

done:
		rts
.endproc

.proc _free
		rts
.endproc