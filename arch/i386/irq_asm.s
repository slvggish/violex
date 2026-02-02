section .text
global irq1_handler
global ignore_irq_handler
extern keyboard_handler

irq1_handler:
	pushad
	cld
	call keyboard_handler
	popad
    
	mov al, 0x20
	out 0x20, al    ; EOI Master PIC
	iret

ignore_irq_handler:
	mov dword [0xB8000], 0x4F454F45 
    
	cli
	hlt
	jmp $
