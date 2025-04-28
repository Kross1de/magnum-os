GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore -fno-stack-protector
ASPARAMS  =  --32
LDPARAMS  = -melf_i386

objects = loader.o gdt.o kernel.o

%.o: %.cpp
	g++ $(GPPPARAMS) -o $@ -c $<
	
%.o: %.s
	as $(ASPARAMS) -o $@ $<
	
maker.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)
	
install: maker.bin
	sudo cp $< boot/maker.bin
	
iso: maker.bin
	mkdir -p isodir/boot/grub
	cp maker.bin isodir/boot/
	cp boot/grub/grub.cfg isodir/boot/grub/
	grub-mkrescue -o magnum.iso isodir
	rm -rf isodir

.PHONY: clean
clean:
	rm -rf *.o maker.bin magnum.iso isodir