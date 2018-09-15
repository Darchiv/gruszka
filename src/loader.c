#include <stdint.h>

#include <loader.h>
#include <mocks.h>
#include <utils.h>

uint8_t load_executable(loadinfo_t *loadinfo, int16_t __fastcall__ (*read)(int16_t callerdata, void *buffer, uint16_t count)) {
	uint16_t tbase, tlen, dbase, dlen, bbase, blen, zbase, zlen, stack;
	uint8_t headoptlen, opttype;
	char *option;




	// Check header.
	uint8_t *s = malloc(8);

	read(0, s, 8);

	if(s[0] != 0x01 ||
	   s[1] != 0x00 ||
	   s[2] != 0x6f ||
	   s[3] != 0x36 ||
	   s[4] != 0x35) {
		kprint("Invalid header.");
		return 1;
	}

	read(0, &tbase, 2);
	read(0, &tlen, 2);
	read(0, &dbase, 2);
	read(0, &dlen, 2);
	read(0, &bbase, 2);
	read(0, &blen, 2);
	read(0, &zbase, 2);
	read(0, &zlen, 2);
	read(0, &stack, 2);

	kprint("Lengths: tbase = %01x, tlen = %01x, dbase = %01x, dlen = %01x, bbase = %01x, blen = %01x, zbase = %01x, zlen = %01x, stack = %u\r\n",
		tbase, tlen, dbase, dlen, bbase, blen, zbase, zlen, stack);

	while ((read(0, &headoptlen, 1), headoptlen) != 0) {
		// Read type.
		read(0, &opttype, 1);

		if (opttype == 0) {
			option = malloc(headoptlen);
			read(0, &option, headoptlen - 2);

			kprint("Filename: %c\r\n", option[0]);
		} else {
			option = malloc(headoptlen);
			read(0, &opttype, headoptlen - 2);
		}
	}

	kprint("OK.");
	return 0;
}