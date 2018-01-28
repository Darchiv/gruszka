#include <stdint.h>
#include <utils.h>
#include <_syscall.h>

#include "../drivers/6551.h"

//#define DEBUG

uint16_t __fastcall__ on_break_interrupt(uint8_t signature, uint8_t *argaddr) {
	switch(signature) {
		case SYS_READ:
		{
			uint8_t b;
			uint16_t i;

			uint16_t count = *((int16_t *) argaddr);
			uint8_t *buf = (uint8_t *) *((int16_t *) argaddr + 1);
			uint16_t fd = *((int16_t *) argaddr + 2);

			#ifdef DEBUG
			kprint("[SYSCALL] Performing read. ArgAddr = %p, Count = %x, Buf = %x, Fd = %x\r\n", argaddr, count, buf, fd);
			#endif

			if (fd != 0) {
				kprint("[SYSCALL] Descriptor `%x` not supported.\r\n", fd);
				return 0;
			}

			for (i = 0; i < count; ++i) {
				while(!acia6551_recv_byte(&b));

				buf[i] = b;
			}

			return count;
		}
		case SYS_WRITE:
		{
			uint16_t i;

			uint16_t count = *((int16_t *) argaddr);
			uint8_t *buf = (uint8_t *) *((int16_t *) argaddr + 1);
			uint16_t fd = *((int16_t *) argaddr + 2);

			#ifdef DEBUG
			kprint("[SYSCALL] Performing write. ArgAddr = %p, Count = %x, Buf = %x, Fd = %x\r\n", argaddr, count, buf, fd);
			#endif

			if (fd != 1 && fd != 2) {
				kprint("[SYSCALL] Descriptor `%x` not supported.\r\n", fd);
				return 0;
			}
			
			for (i = 0; i < count; ++i) {
				acia6551_send_byte(buf[i]);
			}

			return count;
		}
		default:
			kprint("[SYSCALL] Undefined syscall: %u.\r\n", signature);
			return 0;
	}
}