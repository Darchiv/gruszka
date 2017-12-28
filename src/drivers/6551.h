#ifndef A6551_H
#define A6551_H

#include <stdint.h>

void acia6551_init(void);

void __fastcall__ acia6551_send_byte(uint8_t byte);
/* Returns number of bytes sent. */
uint8_t __fastcall__ acia6551_send_str(char *str);

/* Returns 0 when no byte available or non-0 when alright. */
uint8_t __fastcall__ acia6551_recv_byte(uint8_t *byte);

#endif