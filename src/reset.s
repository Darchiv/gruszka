.export handle_reset

; Operating system entry point - a C procedure named run().
.import _run

.import copydata

; C stack pointer.
.importzp sp

; Import symbols generated by linker.
.import __OSCSTACK_START__, __OSCSTACK_SIZE__  ; Boundaries of operating system C stack segment.
.import __BSS_START__, __BSS_SIZE__            ; Boundaries of BSS - uninitialised globals.

; Procedure for handling RESET interrupt.
; Initialises the processor, stack, C stack,
; runs main C procedure - run().
; TODO: add zeroing of system's zeropage and BSS,
;       add interrupt handlers linked list
.proc handle_reset
        ; Disable interrupts during system initialisation.
        sei
        ; Set stack pointer to $FF.
        ldx #$FF
        txs

        ; Initialisation of C stack at the end of "RAM".
        lda     #<(__OSCSTACK_START__ + __OSCSTACK_SIZE__)
        sta     sp
        lda     #>(__OSCSTACK_START__ + __OSCSTACK_SIZE__)
        sta     sp + 1

        ; Copy DATA segment from ROM to RAM.
        jsr copydata

        ; Enable interrupts.
        cli
        ; Jump to run().
        jmp     _run
.endproc