#include <stdint.h>
#include <string.h>
#include <modload.h>
#include <mocks.h>
#include "drivers/6551.h"

void put_string(char *str);
void on_break_interrupt(void);

char *welcome_text = "GRUSZKA Operating System boots...\r\n";
char *break_text = "Break has happened.\r\n";

int16_t __fastcall__ mock_read(int16_t callerdata, void *buffer, uint16_t count);

struct mod_ctrl mod = {mock_read, 0x0, 0};


unsigned char __fastcall__ mod_load (struct mod_ctrl* ctrl);

void run (void) {
	uint8_t b, t;
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
			} else if (b == 'M') {
				t = mod_load(&mod);
				mock_read_rewind();
				put_string("Module loading: ");
				acia6551_send_byte(0x30 + t);

				if (t == MLOAD_OK){
					mock_give_control((uint16_t) mod.module + (uint16_t) mod.entry);
				}
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

int16_t __fastcall__ mock_read(int16_t callerdata, void *buffer, uint16_t count) {
	uint16_t i;

	for (i = 0; i < count; i++) {
		((uint8_t*) buffer)[i] = mock_read_test_byte();
	}
	return count;
}