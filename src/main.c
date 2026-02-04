#include "uart.h"
#include "commands.h"
#include <stdint.h>

#define MAX_CMD_LEN 128
#define PROMPT "> "

/*
TODO:
peek <addr>
poke <addr> <val>
led <n> <on|off|toggle>
leds <0-15>
dump <addr> <len>
rand
rand <max>
eval <expr>
reboot
*/

static int str_cmp(const char *s1, const char *s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(uint8_t *)s1 - *(uint8_t *)s2;
}

static void execute_cmd(char *cmd) {
    // Skip leading spaces
    while (*cmd == ' ') cmd++;

    // Empty command
    if (*cmd == '\0') return;

    // Find end of command name
    char *args = cmd;
    while (*args && *args != ' ') args++;
    if (*args) {
        *args = '\0';
        args++;
        while (*args == ' ') args++;
    }

    if (str_cmp(cmd, "help") == 0) {
        cmd_help();
    } else if (str_cmp(cmd, "clear") == 0) {
        cmd_clear();
    } else if (str_cmp(cmd, "echo") == 0) {
        cmd_echo(args);
    } else if (*cmd !='\n') {
        uart_puts((uint8_t *)"Unknown command: ");
        uart_puts((uint8_t *)cmd);
        uart_puts((uint8_t *)"\r\n");
    }
}

int main() {
    uart_init();

    uart_puts((uint8_t *)"FRISC-V UART Shell\r\n");
    uart_puts((uint8_t *)"Type 'help' for commands\r\n");

    char cmd_buf[MAX_CMD_LEN];
    int cmd_idx = 0;

    while (1) {
        uart_puts((uint8_t *)PROMPT);
        cmd_idx = 0;

        while (1) {
            uint8_t c = uart_getc();
            
            if (c == '\r' || c == '\n') {  // Enter/Return
                uart_puts((uint8_t *)"\r\n");
                cmd_buf[cmd_idx] = '\0';
                execute_cmd(cmd_buf);
                break;
            } else if (c == 0x7F || c == 0x08) {  // Backspace/DEL
                if (cmd_idx > 0) {
                    cmd_idx--;
                    uart_puts((uint8_t *)"\b \b");
                }
            } else if (c >= 32 && c < 127 && cmd_idx < MAX_CMD_LEN - 1) {
                cmd_buf[cmd_idx++] = c;
                uart_putc(c);  // Echo
            }
        }
    }

    return 0;
}
