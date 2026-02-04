#include "uart.h"

void cmd_help() {
    uart_puts((uint8_t *)"Commands:\r\n");
    uart_puts((uint8_t *)"  help        - Show this help\r\n");
    uart_puts((uint8_t *)"  clear       - Clear screen\r\n");
    uart_puts((uint8_t *)"  echo <text> - Echo input\r\n");
}

void cmd_clear() {
    uart_puts((uint8_t *)"\033[2J");
    uart_puts((uint8_t *)"\033[H");
}

void cmd_echo(char *args) {
    uart_puts((uint8_t *)args);
    uart_puts((uint8_t *)"\r\n");
}
