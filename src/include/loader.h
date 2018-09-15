#ifndef _LOADER_H
#define _LOADER_H

#include <stdint.h>

typedef struct loadinfo {
	uint16_t size;
} loadinfo_t;

uint8_t load_executable(loadinfo_t *loadinfo, int16_t __fastcall__ (*read)(int16_t callerdata, void *buffer, uint16_t count));


#endif