#include <stdint.h>
#include "console.h"

#define KBD_DATA_PORT 0x60
#define KDB_STATUS_PORT 0x64

static inline uint8_t inb(uint16_t port);

extern void irq1_handler(); /* assembly stub */

char keymap[128] = {
	0, 27,'1','2','3','4','5','6','7','8','9','0','-','=','\b',
	'\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
	0,'a','s','d','f','g','h','j','k','l',';','\'','`',
	0,'\\','z','x','c','v','b','n','m',',','.','/',
};

/* keyboard init */
void keyboard_handler() {
	uint8_t scancode;
	scancode = inb(KBD_DATA_PORT);

	if (scancode & 0x80) return; /* key release */

	char c = keymap[scancode];
	if (c) console_putc(c);
}

/* additional funcs for ports */
static inline uint8_t inb(uint16_t port) {
	uint8_t ret;
	asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
	return ret;
}
