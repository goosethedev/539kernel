#include "process.h"

void scheduler_init();
void context_switch( int, int, int, int, int, int, int, int, int );
void run_next_process();
