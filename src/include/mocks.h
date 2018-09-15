#ifndef MOCKS_H
#define MOCKS_H

uint8_t __fastcall__ mock_read_test_byte(uint8_t fd);
int16_t __fastcall__ mock_read(int16_t callerdata, void *buffer, uint16_t count);
void __fastcall__ mock_read_rewind(uint8_t fd);
uint8_t __fastcall__ mock_give_control(uint16_t addr);
uint8_t __fastcall__ mock_execute(int16_t fd);

void *malloc(uint16_t m);
void set_malloc_40(void);

#endif
