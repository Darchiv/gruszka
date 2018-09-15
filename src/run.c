#include <stdint.h>
#include <modload.h>
#include <mocks.h>
#include <utils.h>

#include "drivers/6551.h"

char *welcome_text = "GRUSZKA Operating System boots...\r\n";

void run (void) {
	uint8_t ret;
	uint16_t entry_addr = 0;

	// Modload structure for reading shell program.
	struct mod_ctrl mod = {mock_read, 0x0, 0};

	kprint(welcome_text);

	kprint("Initializing ACIA 6551...\r\n");
	acia6551_init();

	kprint("Opening shell...\r\n");
	ret = mock_execute(0x0);

	kprint("Shell exited with code %d. System hangs.\r\n", ret);
}
