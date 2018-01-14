#include <stdint.h>

#include "../drivers/6551.h"

/* A mock for writing to the console.
   Mimics a fwrite for now, so assembly does not have to be changed.
   size_t __fastcall__ fwrite (const void* buf, size_t size, size_t count, FILE* file)
   `size` and `file` are ignored.
*/
int16_t console_write(const void *buf, uint16_t size, uint16_t count, void *file) {
	uint8_t i;

	//if (fd == STDOUT_FILENO) {
	for (i = 0; i < count; ++i) {
		acia6551_send_byte(((uint8_t *)buf)[i]);
	}

	return count;
	//}

	//return -1;
}