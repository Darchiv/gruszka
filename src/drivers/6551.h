#ifndef A6551_H
#define A6551_H

#include <stdint.h>

void acia6551_init(void);
void acia6551_send_byte(uint8_t byte);
uint8_t acia6551_recv_byte(void);

#endif