typedef enum process_state { READY, RUNNING } process_state_t;

typedef struct process_context {
    int eax, ecx, edx, ebx, esp, ebp, esi, edi;
    void (*eip)();
} process_context_t;

typedef struct process {
    int pid;
    process_context_t context;
    process_state_t state;
    void (*base_addr)();
} process_t;

extern int processes_count;
extern process_t *process_table[15];

void process_init();
void process_create(void (*)(), process_t *);
