FRISCV_SDK := sdk
include $(FRISCV_SDK)/friscv.mk

BUILD_DIR := build
ELF := $(BUILD_DIR)/prog.elf
BIN := $(BUILD_DIR)/prog.bin

APP_SRCS := src/main.c src/commands.c
ALL_SRCS := $(FRISCV_CRT0) $(APP_SRCS) $(FRISCV_SRCS)

.PHONY: all clean compile_commands.json

all: $(BIN)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ELF): $(ALL_SRCS) | $(BUILD_DIR)
	$(CC) $(FRISCV_CFLAGS) $(FRISCV_LDFLAGS) -o $@ $(ALL_SRCS)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -rf $(BUILD_DIR)

compile_commands.json:
	@echo '[' > $@
	@echo '  {' >> $@
	@echo '    "directory": "$(CURDIR)",' >> $@
	@echo '    "file": "src/main.c",' >> $@
	@echo '    "arguments": ["clang", "-c", "--target=riscv32-unknown-elf", "-march=rv32i", "-mabi=ilp32", "-ffreestanding", "-fno-builtin", "-nostdlib", "-nostartfiles", "-Isdk/include", "-Wall", "-Wextra", "src/main.c"]' >> $@
	@echo '  }' >> $@
	@echo ']' >> $@
