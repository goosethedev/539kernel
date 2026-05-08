%assign i 0
%rep 49
isr_%+i:
    cli
; handle system interrupts
%if i < 32
    push    i
    jmp     isr_basic
; handle system timer for context switching
%elif i = 32
    jmp     timer_handler
%else
    push    i
    jmp     irq_basic
%endif
%assign i i+1
%endrep

isr_basic:
	call interrupt_handler
	pop eax
    sti
	iret

timer_handler:
    pusha           ; push all register values to the stack
                    ; eax, ecx, edx, ebx, esp, ebp, esi, edi

    mov eax, [esp + 32]     ; push the eip value
    push eax

    call context_switch

    mov al, 0x20    ; issue EOI to master PIC for all IQRs
	out 0x20, al

	add esp, 40d    ; clean up pushed values by advancing the sp
	push run_next_process
	iret

irq_basic:
	call interrupt_handler

	mov al, 0x20    ; issue EOI to master PIC for all IQRs
	out 0x20, al

	cmp byte [esp], 40d
	jnge irq_basic_end

	mov al, 0xa0    ; issue EOI to slave PIC for its IQRs only
	out 0x20, al

irq_basic_end:
	pop eax
    sti
	iret

idt:
%assign i 0
%rep 49
    dw isr_%+i, 8, 0x8e00, 0x0000
%assign i i+1
%endrep

idtr:
	idt_size_in_bytes	: 	dw idtr - idt
	idt_base_address	: 	dd idt
