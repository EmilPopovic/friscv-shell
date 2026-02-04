FRISCV_SDK := sdk
include $(FRISCV_SDK)/friscv.mk

BUILD_DIR := build
TARGET := $(BUILD_DIR)/prog

APP_SRCS := src/main.c src/commands.c
ALL_SRCS := $(FRISCV_CRT0) $(APP_SRCS) $(FRISCV_SRCS)

.PHONY: all clean compile_commands.json

ifeq ($(PLATFORM),friscv)
ELF := $(TARGET).elf
BIN := $(TARGET).bin

all: $(BIN)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ELF): $(ALL_SRCS) | $(BUILD_DIR)
	$(CC) $(FRISCV_CFLAGS) $(FRISCV_LDFLAGS) -o $@ $(ALL_SRCS)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

else
all: $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(TARGET): $(APP_SRCS) $(FRISCV_SRCS) | $(BUILD_DIR)
	$(CC) $(FRISCV_CFLAGS) $(FRISCV_LDFLAGS) -o $# $(APP_SRCS) $(FRISCV_SRCS)
endif

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
