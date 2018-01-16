.importzp ptr1

.export _mock_give_control

.proc _mock_give_control
	sta ptr1
    stx ptr1+1

    ldy #>(return - 1)
    phy
    ldy #<(return - 1)
    phy

    jmp (ptr1)
return:
	rts
.endproc