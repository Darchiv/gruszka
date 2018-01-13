.importzp ptr1

.export _mock_give_control

_mock_give_control:
	sta ptr1
    stx ptr1+1

    jmp (ptr1)