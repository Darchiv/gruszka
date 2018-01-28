#include <stdint.h>
#include <modload.h>
#include <mocks.h>
#include <utils.h>

#include "drivers/6551.h"

void __fastcall__ on_break_interrupt(uint8_t signature);

char *welcome_text = "GRUSZKA Operating System boots...\r\n";

int16_t __fastcall__ mock_read(int16_t callerdata, void *buffer, uint16_t count);

struct mod_ctrl mod = {mock_read, 0x0, 0};

unsigned char __fastcall__ mod_load (struct mod_ctrl* ctrl);

uint16_t entry_addr = 0;

void run (void) {
	uint8_t b, t;
	uint8_t r = 0;

	acia6551_init();

	kprint(welcome_text);

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

				entry_addr = (uint16_t) mod.module + (uint16_t) mod.entry;

				kprint("Module loading: %d. Module: %x. Entry: %x. Size: %x, id: %x. Address: %x\r\n", t, (uint16_t) mod.module, (uint16_t) mod.entry, mod.module_size, mod.module_id, entry_addr);
			} else if(b == 'R') {
				uint8_t ret = mock_give_control(entry_addr);

				kprint("Executed. Return: %d\r\n", ret);
			} else {
				kprint("%c", b);
			}
		}
	}
}

int16_t __fastcall__ mock_read(int16_t callerdata, void *buffer, uint16_t count) {
	uint16_t i;

	for (i = 0; i < count; i++) {
		((uint8_t*) buffer)[i] = mock_read_test_byte();
	}
	return count;
}