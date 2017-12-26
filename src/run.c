#include <stdint.h>
#include "drivers/6551.h"

void run (void) {
	uint8_t r;

	acia6551_init();

	// Simple echo "terminal".
	while (1) {
		r = acia6551_recv_byte();

		if (r != 0) {
			acia6551_send_byte(r);
		}
	}
}