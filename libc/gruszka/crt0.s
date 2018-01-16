       .export         _exit, start
       .export         __STARTUP__ : absolute = 1
       .import         zerobss, _main
       .import         initlib, donelib
       .import         __STACKSTART__, __STACKSIZE__

       .constructor    initmainargs, 24
       .import         __argc, __argv

       .include "zeropage.inc"

.segment "STARTUP"
start:
       lda #<(__STACKSTART__ + __STACKSIZE__)
       sta sp
       lda #>(__STACKSTART__ + __STACKSIZE__)
       sta sp + 1

       jsr zerobss
       jsr initlib
       jsr _main
_exit: pha
       jsr donelib
       pla
       rts

.segment "ONCE"

.proc initmainargs
       lda     #$00
       ldx     #$00
       sta     __argv
       stx     __argv + 1

       lda     #$00
       ldx     #$00
       sta     __argc
       stx     __argc + 1

       rts
.endproc