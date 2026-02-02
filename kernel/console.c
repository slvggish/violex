#include <stddef.h>
#include <stdint.h>

static uint16_t* video = (uint16_t*)0xB8000;
static int row = 0;
static int col = 0;

static uint16_t make_char(char c) {
	return (uint16_t)c | (0x0F << 8);
}

void console_putc(char c) {
	if (c == '\n') {
		row++;
		col = 0;
		return;
	}

	video[row * 80 + col] = make_char(c);
	col++;

	if (col >= 80) {
		col = 0;
		row++;
	}
}

void console_print(const char* str) {
	for (size_t i = 0; str[i]; i++)
		console_putc(str[i]);
}
