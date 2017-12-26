.export _acia6551_init = acia6551_init, acia6551_init
.export _acia6551_send_byte = acia6551_send_byte, acia6551_send_byte
.export _acia6551_recv_byte = acia6551_recv_byte, acia6551_recv_byte
.export acia6551_irq_handler

ACIA_DATA 	 = $8800
ACIA_STATUS  = $8801
ACIA_COMMAND = $8802
ACIA_CONTROL = $8803


.bss
; UNSAFE AND BAD. ONLY LAST RECEVED BYTE IS RETURNED. THE REST IS DROPPED
received_byte:	.res 1

.code

.proc acia6551_init
        lda #%00011111
        sta ACIA_CONTROL
        lda #%00001001
        sta ACIA_COMMAND

        rts
.endproc

.proc acia6551_send_byte
wait_txd_empty:
		; Save byte (parameter).
		tax

		; Check whether ACIA can accept datum.
		lda ACIA_STATUS
		and #$10
		beq wait_txd_empty

		; Send byte to the ACIA data register.
		stx ACIA_DATA
		rts
.endproc

; UNSAFE AND BAD. ONLY LAST RECEVED BYTE IS RETURNED. THE REST IS DROPPED
.proc acia6551_recv_byte
		lda received_byte
		stz received_byte
		rts
.endproc

.proc acia6551_irq_handler
        lda ACIA_STATUS
        bpl exit

        bit #$08
        beq exit
        ; UNSAFE AND BAD. ONLY LAST RECEVED BYTE IS RETURNED. THE REST IS DROPPED
        lda ACIA_DATA
        sta received_byte

exit:
		rts
.endproc