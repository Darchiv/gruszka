#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <unistd.h>

// Numbef of characters per line allowed plus null byte.
#define INPUT_LENGTH (127 + 1)

uint8_t read_buffer[INPUT_LENGTH];

/*struct {
	uint16_t argc;
	uint8_t* argv;
};*/

uint8_t* get_line(void);
uint8_t* split_line(uint8_t *line);

int8_t main(int16_t argc, const char* argv[]) {
	uint8_t *line, *program_name;

	while (1) {
		printf("# ");

		line = get_line();

		program_name = split_line(line);

		if (strcmp(program_name, "help") == 0) {
			printf("Available commands: help, hello.\r\n");
		} else if (strcmp(program_name, "hello") == 0) {
			exec(program_name, "");
		} else {
			printf("[\x1b[41mERR\x1b[0m] No such command: %s\r\n", program_name);
		}
	}

	return 0;
}

uint8_t* get_line(void) {
	// Currently processed character.
	int16_t t;

	// Number of characters current line consists of.
	#if INPUT_LENGTH <= 256
	uint8_t pos = 0;
	#else
	uint16_t pos = 0;
	#endif

	while (1) {
		t = getchar();

		// End of command.
		if (t == '\r' || t == EOF) {
			printf("\r\n");
			read_buffer[pos] = 0;

			return read_buffer;
		// Entered a printable character.
		} else if (pos < INPUT_LENGTH - 1 && t >= 0x20 && t <= 0x7e) {
			putchar(t);
			read_buffer[pos] = t;
			++pos;
		// Backspace pressed.
		} else if (pos > 0 && t == 0x8) {
			printf("\x1b[D \x1b[D"); // Using VT100 codes.
			read_buffer[pos] = 0;
			--pos;
		}
		// Ignore excessive characters.
	}
}

// Splits line into tokens.
// TODO: return proper argc/argv structure.
uint8_t* split_line(uint8_t *line) {
	uint8_t *program_name;
	uint8_t *token;

	uint8_t arg_number = 0;
	uint8_t delimiter[] = " ";

	program_name = strtok(line, delimiter);

	while ((token = strtok(NULL, delimiter)) != NULL) {
		++arg_number;
	}

	return program_name;
}