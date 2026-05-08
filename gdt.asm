gdt:
    null_descriptor             :   dw 0,0,0,0  ; requisite in x86
    kernel_code_descriptor      :   dw 0xffff, 0, 0x9a00, 0x0cf
    kernel_data_descriptor      :   dw 0xffff, 0, 0x9200, 0x0cf
    userspace_code_descriptor   :   dw 0xffff, 0, 0xfa00, 0x0cf
    userspace_data_descriptor   :   dw 0xffff, 0, 0xf200, 0x0cf
    tss_descriptor              :   dw tss + 3, tss, 0x8900, 0x0000

gdtr:
    gdt_size_in_bytes   :   dw (6*8)    ; gdt limit (2 bytes)
    gdt_base_address    :   dd gdt      ; gdt base (4 bytes)
