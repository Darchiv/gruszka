#include <stdint.h>
#include <mocks.h>
#include <modload.h>
#include <utils.h>

int16_t __fastcall__ mock_read(int16_t callerdata, void *buffer, uint16_t count) {
	uint16_t i;

	for (i = 0; i < count; i++) {
		((uint8_t*) buffer)[i] = mock_read_test_byte((uint8_t) callerdata);
	}
	return count;
}

uint8_t __fastcall__ mock_execute(int16_t fd) {
	uint8_t ret, t;
	uint16_t entry_addr;

	// Modload structure for reading shell program.
	struct mod_ctrl mod;
	mod.read = mock_read;
	mod.callerdata = fd;

	t = mod_load(&mod);
	mock_read_rewind(fd);
	entry_addr = (uint16_t) mod.module + (uint16_t) mod.entry;

	kprint("Module loading: %d. Module: %x. Entry: %x. Size: %x, id: %x. Address: %x\r\n", t, (uint16_t) mod.module, (uint16_t) mod.entry, mod.module_size, mod.module_id, entry_addr);
	
	ret = mock_give_control(entry_addr);

	return ret;
}