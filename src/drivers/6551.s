.export _acia6551_init
.export _acia6551_send_byte, _acia6551_send_str
.export _acia6551_recv_byte

.export acia6551_irq_handler

.importzp ptr1

.include "ring_buf.inc"

ACIA_DATA 	 = $8800
ACIA_STATUS  = $8801
ACIA_COMMAND = $8802
ACIA_CONTROL = $8803

ACIA_RECV_RB_LEN = 64
ring_buf_reserve acia6551_recv_buf, ACIA_RECV_RB_LEN

ACIA_SEND_RB_LEN = 64
ring_buf_reserve acia6551_send_buf, ACIA_SEND_RB_LEN

; void acia6551_init(void)
.proc _acia6551_init
		; ACIA should be reset by reset line.

		ring_buf_init acia6551_recv_buf, ACIA_RECV_RB_LEN
        ring_buf_init acia6551_send_buf, ACIA_SEND_RB_LEN

        ; Some safe defults like receive interrupt, 8 bit character, etc.
        lda #%00011111
        sta ACIA_CONTROL
        lda #%00001001
        sta ACIA_COMMAND

        rts
.endproc

; uint8_t __fastcall__ acia6551_send_str(char *str)
.proc _acia6551_send_str
		; Save pointer to str.
		sta ptr1
		stx ptr1 + 1

		ldy #$00

send_byte:
		lda (ptr1),y					; Get a byte from the string.
		beq string_end					; Is this a terminating zero?

		; Add the byte in A to the buffer.
		ring_buf_push acia6551_send_buf, ACIA_SEND_RB_LEN

		; Is buffer full?
		bcs buffer_full

		; Check whether upper boundary of 256 bytes has been reached.
		iny
		cpy #$FF
		beq max_len_reached

		sec
        bcs send_byte
		
buffer_full:
max_len_reached:
string_end:

		; Check whether a NULL was given to procedure.
		cpy #$00
		beq string_empty

		phy

		ring_buf_pop acia6551_send_buf, ACIA_SEND_RB_LEN

		; Bootstrap sending.
        jsr _acia6551_send_byte

        ;;; Simulator's interrupts don't assert IRQ line low and interrupts
        ;;; are gone when in a sequential interrupt handling routine.
        ;;; TODO: fix simulator's interrupts and remove this block
broken_send_byte:
        ring_buf_pop acia6551_send_buf, ACIA_SEND_RB_LEN
        bcs broken_send_done
        jsr _acia6551_send_byte
        sec
        bcs broken_send_byte
broken_send_done:
        ;;;

        ; The A register has number of saved bytes.
        pla

string_empty:
		rts
.endproc

; void __fastcall__ acia6551_send_byte(uint8_t byte)
.proc _acia6551_send_byte
		; Save the byte to X.
		tax

		; Wait until a byte can be written into transmit register.
wait_for_tx_clear:
		lda ACIA_STATUS
		bit #$10						; 'Transmit register full?' bit.
        beq wait_for_tx_clear

        ; Can send the given byte.
        stx ACIA_DATA

        rts
.endproc

; uint8_t __fastcall__ acia6551_recv_byte(uint8_t *byte)
.proc _acia6551_recv_byte
		; Save pointer to byte.
		sta ptr1
		stx ptr1 + 1

        ring_buf_pop acia6551_recv_buf, ACIA_RECV_RB_LEN

        bcc has_data
        ; No byte available. Exit.
        lda #$00
        rts

has_data:
		; Output byte 
		sta (ptr1)
		; TODO: add more bits to output, like framing error, etc.
		lda #$01
        rts
.endproc

.proc acia6551_irq_handler
        lda ACIA_STATUS
        bpl exit

        ; Check whether byte awaits.
		bit #$08
        beq recv_done

        ; Get received byte and store it in the buffer.
        lda ACIA_DATA
        ring_buf_push acia6551_recv_buf, ACIA_RECV_RB_LEN

recv_done:

        ; TODO: fix interrupts,
        ;       more on the bottom of _acia6551_send_str
exit:
		rts
.endproc