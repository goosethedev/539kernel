// Video memory:
//          0     1     2     3     ... 80
// line 0   char  color char  color ...
// line 1   char  color char  color ...
// ...
// line 25

#define SCREEN_WIDTH    80
#define SCREEN_HEIGHT   25
#define CHAR_COLOR      15 // white

volatile unsigned char *video = (unsigned char*) 0xB8000;

int next_char_pos = 0;

void print(char *);
void println();
void printi(int);

void kernel_main() {
    print("Hello World from ");
    printi(539);
    print("kernel!");
    println();
    print("This is another line c:");
    while(1);
}

void printchar(char ch) {
    video[next_char_pos++] = ch;    // set character byte
    video[next_char_pos++] = CHAR_COLOR;    // set color byte
}

void print(char *str) {
    while(*str != '\0')
        printchar(*str++);
}

void println() {
    int char_count = next_char_pos / 2;  // one char printed every two bytes
    int offset = SCREEN_WIDTH - (char_count % SCREEN_WIDTH);
    next_char_pos += offset * 2;  // offset char and color bytes
}

void printi(int num) {
    if (num <= 0) return;
    printi(num / 10);
    printchar('0' + (num % 10));
}

void interrupt_handler(int int_num) {
    println();
    print("Interrupt received: ");
    printi(int_num);
}
