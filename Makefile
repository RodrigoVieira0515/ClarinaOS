CC = i686-elf-g++
CCPARAMS = -Iinclude -Wwrite-strings
AS = i686-elf-as
LD = i686-elf-ld

objects = obj/loader.o \
          obj/constructors.o \
          obj/kernel.o \
		  obj/text_mode.o

run_prep: 
	dd if=/dev/zero of=out/floppy_disk.img bs=512 count=2880
	mkfs.fat -F 12 -n "FLOPPY_DISK" out/floppy_disk.img
	echo "Hello from test file" > test.txt
	mcopy -i out/floppy_disk.img test.txt "::test.txt"
	rm -rf test.txt

run: out/clarinaos.iso run_prep
	qemu-system-i386 -boot d -cdrom out/clarinaos.iso -fda out/floppy_disk.img -m 512
obj/%.o: src/%.cpp
	mkdir -p $(@D)
	$(CC) $(CCPARAMS) -c -o $@ $<

obj/%.o: src/%.s
	mkdir -p out
	mkdir -p $(@D)
	$(AS) -o $@ $<

out/kernel.bin: linker.ld $(objects)
	mkdir -p out
	$(LD) -T $< -o $@ $(objects)

out/clarinaos.iso: out/kernel.bin
	mkdir -p out
	mkdir -p iso
	mkdir -p iso/boot
	mkdir -p iso/boot/grub
	cp out/kernel.bin iso/boot/kernel.bin
	echo 'set timeout=0'                      > iso/boot/grub/grub.cfg
	echo 'set default=0'                     >> iso/boot/grub/grub.cfg
	echo ''                                  >> iso/boot/grub/grub.cfg
	echo 'menuentry "ClarinaOS" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/kernel.bin'    >> iso/boot/grub/grub.cfg
	echo '  boot'                            >> iso/boot/grub/grub.cfg
	echo '}'                                 >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=out/clarinaos.iso iso
	rm -rf iso

.PHONY: clean
clean:
	rm -rf obj out