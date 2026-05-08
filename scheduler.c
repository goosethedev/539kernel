#include "scheduler.h"
#include "screen.h"

int running_pid;

void scheduler_init() {
    running_pid = 0;
}

process_t *load_next_process() {
    running_pid = (running_pid + 1) % processes_count;
    return process_table[running_pid];
}

// Receives argument from 'pusha' asm instruction
void context_switch( int eip, int edi, int esi, int ebp, int esp, int ebx, int edx, int ecx, int eax )
{
    process_t *curr_process = process_table[running_pid];
    process_t *next_process = load_next_process();

    // Testing
    print("EAX = ");
    printi(eax);
    print(" ");

    // Back up current process
    if (curr_process->state == RUNNING) {
        curr_process->context.eax = eax;
        curr_process->context.ecx = ecx;
        curr_process->context.edx = edx;
        curr_process->context.ebx = ebx;
        curr_process->context.esp = esp;
        curr_process->context.ebp = ebp;
        curr_process->context.esi = esi;
        curr_process->context.edi = edi;
        curr_process->context.eip = (void (*)()) eip;
    }
    curr_process->state = READY;

    // Setup next process' registers
    asm("   mov %0, %%eax;  \
            mov %0, %%ecx;  \
            mov %0, %%edx;  \
            mov %0, %%ebx;  \
            mov %0, %%esi;  \
            mov %0, %%edi;" ::
            "r" ( next_process->context.eax ),
            "r" ( next_process->context.ecx ),
            "r" ( next_process->context.edx ),
            "r" ( next_process->context.ebx ),
            "r" ( next_process->context.esi ),
            "r" ( next_process->context.edi )
    );
    next_process->state = RUNNING;
}

void run_next_process() {
    process_t *curr_process = process_table[running_pid];
    asm("   sti;    \
            jmp *%0" :: "r" ( curr_process->context.eip ));
}
