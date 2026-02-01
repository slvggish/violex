OS_NAME = Violex
CC = gcc
AS = nasm
LD = ld

SRC_DIR = .
BUILD_DIR = build
ISO_DIR = iso_root

CFLAGS = -ffreestanding -m32 -Wall -Wextra -fno-stack-protector -Iinclude
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T arch/i386/linker.ld

SRCS_C = $(shell find $(SRC_DIR) -name "*.c")
SRCS_S = $(shell find $(SRC_DIR) -name "*.s")

OBJS = $(SRCS_C:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
OBJS += $(SRCS_S:$(SRC_DIR)/%.s=$(BUILD_DIR)/%.o)

all: $(OS_NAME).iso

$(OS_NAME).iso: $(BUILD_DIR)/kernel.bin
	@mkdir -p $(ISO_DIR)/boot/grub
	cp $(BUILD_DIR)/kernel.bin $(ISO_DIR)/boot/kernel.bin
	cp grub.cfg $(ISO_DIR)/boot/grub/grub.cfg
	grub-mkrescue -o $(OS_NAME).iso $(ISO_DIR)

$(BUILD_DIR)/kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(ISO_DIR) $(OS_NAME).iso

.PHONY: all clean run
