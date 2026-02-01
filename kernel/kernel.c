#include "console.h"

extern void gdt_install();
extern void idt_install();
extern void pic_remap();
extern void enable_keyboard_irq();

void kernel_main() {
    console_print("Welcome to Violex\n");

    gdt_install();
    idt_install();
    pic_remap();
    enable_keyboard_irq();

    console_print("There's nothing here yet\n");
    
    asm volatile ("sti");

    while(1) {
        asm volatile ("hlt");
    }
}
