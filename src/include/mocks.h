#ifndef MOCKS_H
#define MOCKS_H

uint8_t __fastcall__ mock_read_test_byte(void);
void __fastcall__ mock_read_rewind(void);
uint8_t __fastcall__ mock_give_control(uint16_t addr);

#endif
