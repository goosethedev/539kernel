#include "screen.h"

void kernel_main() {
    screen_init();
    print("Hello World from ");
    printi(539);
    print("kernel!");
    println();
    print("This is another line c:");
    while(1);
}

void interrupt_handler(int int_num) {
    println();
    print("Interrupt received: ");
    printi(int_num);
}
