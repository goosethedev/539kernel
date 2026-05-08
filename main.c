#include "scheduler.h"
#include "screen.h"

void processA();
void processB();
void processC();
void processD();

void kernel_main() {
    process_t p1, p2, p3, p4;

    screen_init();
    process_init();
    scheduler_init();

    print("Hello World from ");
    printi(539);
    print("kernel!");
    println();

    process_create(&processA, &p1);
    process_create(&processB, &p2);
    process_create(&processC, &p3);
    process_create(&processD, &p4);

    while(1);
}

void interrupt_handler(int int_num) {
    println();
    print("Interrupt received: ");
    printi(int_num);
}

void processA() {
    while (1) asm("mov $5390, %eax");
}

void processB() {
    while (1) asm("mov $5391, %eax");
}

void processC() {
    while (1) asm("mov $5392, %eax");
}

void processD() {
    while (1) asm("mov $5393, %eax");
}
