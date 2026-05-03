ASM = nasm
BOOTSTRAP_FILE = bootstrap.asm
KERNEL_FILE = simple_kernel.asm

build: $(BOOTSTRAP_FILE) $(KERNEL_FILE)
	$(ASM) -f bin $(BOOTSTRAP_FILE) -o bootstrap.o
	$(ASM) -f bin $(KERNEL_FILE) -o kernel.o
	dd if=bootstrap.o of=kernel.img
	dd seek=1 if=kernel.o of=kernel.img bs=512
	qemu-system-x86_64 -s -drive format=raw,file=kernel.img

clean:
	rm -f *.o *.img *.bin *.elf
