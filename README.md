# FRISC-V Shell

A minimal UART shell for the FRISC-V platform. Accepts commands over UART, echoes input, and dispatches to built-in command handlers.

## Prerequisites

- RISC-V cross-compiler (`riscv32-unknown-elf-gcc`)
- `objcopy` for the target

## Getting started

Clone with `--recursive` to pull the SDK submodule:

```sh
git clone --recursive https://github.com/friscv/friscv-shell
```

If you already cloned without `--recursive`:

```sh
git submodule update --init
```

## Build

```sh
make
```

The output binary will be at `build/prog.bin`.

## Clean

```sh
make clean
```
