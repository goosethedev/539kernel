start:
    ; load bootloader at known BIOS address 0x07C00
    ; physical addr (real-mode) = segment * 16 + offset
    mov ax, 0x07C0
    mov ds, ax

    ; welcome string
    mov si, title_str
    call print_str

    ; load kernel and execute it
    call load_kernel_from_disk
    jmp 0x0900:0000


; load the kernel at 0x9000 (div by 16 for physical addr)
;
load_kernel_from_disk:
    ; calculate the offset in memory of the current sector in bx
    mov ax, [curr_sector_to_load]
    sub ax, 2
    mov bx, 512
    mul bx
    mov bx, ax

    mov ax, 0x0900
    mov es, ax

    ; execute BIOS service 13h:02h (read from hard-disk)
    mov ah, 02h     ; load BIOS service
    mov al, 01h     ; read only one sector
    mov ch, 0h      ; hdd track we want to read (track 0)
    mov cl, [curr_sector_to_load]     ; sector to read from disk
    mov dh, 0h      ; head number (?)
    mov dl, 80h     ; type of disk to read (0h=floppy, 80h=hdd0)
    int 13h         ; bios hard-disk service category

    jc kernel_load_error    ; check carry flag (1 if errored)

    ; load next sector if available
    sub byte [number_of_sectors_to_load], 1
    add byte [curr_sector_to_load], 1
    cmp byte [number_of_sectors_to_load], 0

    jne load_kernel_from_disk

    ret

kernel_load_error:
    mov si, load_error_str
    call print_str

    jmp $   ; enter infinite loop, there's nothing to do


print_str:
    mov ah, 0Eh             ; set service: print to screen

    print_char:
        lodsb               ; load one str byte from SI and increment pos
        cmp al, 0           ; if 0 (null), stop
        je print_finished

        int 10h             ; call interrupt category
        jmp print_char

print_finished:
    mov al, 10d     ; print new line
    int 10h

    mov ah, 03h     ; read current cursor pos
    mov bh, 0
    int 10h

    mov ah, 02h     ; move cursor to the beginning
    mov dl, 0
    int 10h

    ret

title_str       db "BOOTLOADER: loading 539 kernel...", 0
load_error_str  db "BOOTLOADER: ERROR! the kernel failed to load", 0
number_of_sectors_to_load   db 15d
curr_sector_to_load         db 2d

; pad with zeros until addr 510
; 510 - (addr of cur line - addr of cur section (start))
times 510-($-$$) db 0

; set the two last bytes to the bootloader magic code
dw 0xAA55
