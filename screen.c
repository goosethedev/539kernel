#include "screen.h"

volatile unsigned char *video;
int next_char_pos;

void screen_init() {
    video = (unsigned char*) 0xB8000;
    next_char_pos = 0;
}

void printchar(char ch) {
    video[next_char_pos++] = ch;    // set character byte
    video[next_char_pos++] = CHAR_COLOR;    // set color byte
}

void print(char *str) {
    while (*str != '\0')
        printchar(*str++);
}

void println() {
    int char_count = next_char_pos / 2;  // one char printed every two bytes
    int offset = SCREEN_WIDTH - (char_count % SCREEN_WIDTH);
    next_char_pos += offset * 2;  // offset char and color bytes
}

void printi(int num) {
    if (num >= 10) printi(num / 10);
    printchar('0' + (num % 10));
}
