.import handle_reset
.import acia6551_send_byte, acia6551_irq_handler

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

break:  ; TODO: system calls
        lda #$47
        jsr acia6551_send_byte ; Just for laughs on BReaK.

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