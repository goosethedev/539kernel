#include "process.h"

process_t *process_table[15];
int processes_count;

void process_init() {
    processes_count = 0;
}

// In the real world, this function should allocate memory for the process
void process_create(void (*base_addr)(), process_t *process) {
    process->context.eax = 0;
    process->context.ecx = 0;
    process->context.edx = 0;
    process->context.ebx = 0;
    process->context.esp = 0;
    process->context.ebp = 0;
    process->context.esi = 0;
    process->context.edi = 0;
    process->context.eip = base_addr;

    process->state = READY;
    process->base_addr = base_addr;

    process->pid = processes_count++;
    process_table[process->pid] = process;
}
