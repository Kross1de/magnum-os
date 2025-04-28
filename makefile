GCCPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -fno-stack-protector
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = loader.o gdt.o port.o interruptstubs.o interrupts.o kernel.o


run: magnum.iso
	qemu-system-i386 -cdrom magnum.iso

%.o: %.cpp
	gcc $(GCCPARAMS) -c -o $@ $<

%.o: %.s
	as $(ASPARAMS) -o $@ $<

magnum.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)

magnum.iso: magnum.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp magnum.bin iso/boot/magnum.bin
	echo 'set timeout=0'                      > iso/boot/grub/grub.cfg
	echo 'set default=0'                     >> iso/boot/grub/grub.cfg
	echo ''                                  >> iso/boot/grub/grub.cfg
	echo 'menuentry "MagnumOS" {' >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/magnum.bin'    >> iso/boot/grub/grub.cfg
	echo '  boot'                            >> iso/boot/grub/grub.cfg
	echo '}'                                 >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=magnum.iso iso
	rm -rf iso

install: magnum.bin
	sudo cp $< /boot/magnum.bin

.PHONY: clean
clean:
	rm -f $(objects) magnum.bin magnum.iso
