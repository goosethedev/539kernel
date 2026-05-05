; still runs in real-mode (16-bit, not supported by C)
; responsibilities
; - load the GDT
; - setup video mode for VGA usage
; - switch to protected mode
; - setup interrupts

[bits 16]               ; because we're compiling to elf32
extern kernel_main      ; tell the linker to link these functions
extern interrupt_handler

start:
    ; set the data segment to the current address
    mov ax, cs
    mov ds, ax

    call load_gdt
    call init_video_mode
    call enter_protected_mode
    call setup_interrupts

    call 0x08:start_kernel   ; far jump to kernel_code_descriptor

load_gdt:
    cli                     ; disable interrupts (recommended)
    lgdt [gdtr - start]     ; set GDTR
    ret

init_video_mode:
    mov ah, 0h          ; service 0 -> set video mode service
    mov al, 3h          ; video mode: 3h (text mode 16 colors)
                        ;             13h (graphics mode 320x200, 256 colors)
    int 10h

    mov ah, 1h          ; service 1 -> set text cursor service
    mov cx, 2000h       ; cursor: 2000h -> cursor disabled (no text input allowed)
    int 10h

    ret

enter_protected_mode:
    mov eax, cr0
    or eax, 1           ; switch first bit to 1 (protected mode)
    mov cr0, eax
    ret

setup_interrupts:
    call remap_pic
    call load_idt
    ret

remap_pic:
    ; make PICs start initialization command
    mov al, 11h
    out 0x20, al        ; send init cmd to pic master
    out 0xa0, al        ; send init cmd to pic slave

    ; first arg: offsets
    mov al, 32d         ; master irq offset at 32 (8 values)
    out 0x21, al
    mov al, 40d         ; slave irq offset at 40 (7 values)
    out 0xa1, al

    ; second arg: master-slave connection port
    mov al, 0100b       ; bit 2 from right (0-index) = IQR2
    out 0x21, al
    mov al, 2h          ; "connected to IQR2 on master"
    out 0xa1, al

    ; third arg: use x86 mode
    mov al, 1h
    out 0x21, al
    out 0xa1, al

    ; fourth arg: enable all IRQs
    mov al, 0h
    out 0x21, al
    out 0xa1, al

    ret

load_idt:
    lidt [idtr - start]
    ret


; must use 32-bit and segment selectors, since we're on protected mode
[bits 32]
start_kernel:
    mov eax, 10h        ; points to kernel_data_descriptor
    mov ds, eax
    mov ss, eax

    mov eax, 0          ; points to null_descriptor (disable)
    mov es, eax
    mov fs, eax
    mov gs, eax

    sti                 ; enable again the interrupts

    call kernel_main

%include "gdt.asm"
%include "idt.asm"
