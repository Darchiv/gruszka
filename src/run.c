#include <stdint.h>
#include <string.h>
#include "drivers/6551.h"

void put_string(char *str);
void on_break_interrupt(void);

char *welcome_text = "GRUSZKA Operating System boots...\r\n";
char *break_text = "Break has happened.\r\n";

void run (void) {
	uint8_t b;
	uint8_t r = 0;

	acia6551_init();


	put_string(welcome_text);

	// Simple echo "terminal".
	while (1) {
		r = acia6551_recv_byte(&b);

		if (r != 0) {
			if (b == 'B') {
				__asm__("brk");
				__asm__("nop");
			} else {
				acia6551_send_byte(b);
			}
		}
	}
}

void put_string(char *str) {
	uint8_t r = 0;
	uint8_t len = strlen(str);

	while (r < len) {
		r += acia6551_send_str(str + r);
	}
}

void on_break_interrupt(void) {
	put_string(break_text);
}