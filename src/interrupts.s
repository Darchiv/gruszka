.import handle_reset
.import acia6551_irq_handler
.import _on_break_interrupt

.import decax1
.importzp ptr1

.bss
SavePtr: .res 2

; Assigning procedure addresses to interrupt vectors.
.segment "VECTORS"
	.word    do_nothing
	.word    handle_reset
	.word    handle_irq

.code


do_nothing:
	rti

; Interrupt service routine for IRQ.
.proc handle_irq
        ; Save registers on the stack.
        pha
        phx
        phy

        ; Check whether it is a BRK or IRQ.
        tsx
        inx                ; Address where Y is stored.
        inx                ; Address where X is stored.
        inx                ; Address where A is stored.
        inx                ; Address where P is stored.
        lda $100,x         ; Get stack copy of P to A.
        and #$10           ; Get B bit from P copy.
        beq irq

break:
        ; Save ptr1.
        lda ptr1
        sta SavePtr
        lda ptr1+1
        sta SavePtr+1

        ; Get down to the address of the signature byte.
        inx
        lda $100,x
        pha
        inx
        lda $100,x
        tax
        pla
        ;tyx ; "Expected :" - cc65 bug?
        jsr decax1

        ; Load that byte.
        sta ptr1
        stx ptr1+1
        lda (ptr1)

        jsr _on_break_interrupt

        sec
        bcs exit

irq:    ; TODO: interrupt chain
        jsr acia6551_irq_handler

exit:   ; Restore registers from the stack.
        ply
        plx
        pla

        rti
.endproc