start:
    mov ax, cs      ; load current segment as data segment
    mov ds, ax

    mov si, hello_str
    call print_str

    jmp $           ; nothing to do, loop infinitely

print_str:
    mov ah, 0Eh

    print_char:
        lodsb
        cmp al, 0
        je done

        int 10h
        jmp print_char

done:
    ret

hello_str db 'KERNEL: Hello World! This is Simple 539kernel!', 0
