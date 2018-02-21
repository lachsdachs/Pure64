VERSION ?= 0.9.0

.PHONY: all clean install
all clean install:
	$(MAKE) -C src/lib $@
	$(MAKE) -C src/bootsectors $@
	$(MAKE) -C src $@
	$(MAKE) -C src/util $@
	$(MAKE) -C include/pure64 $@

pure64-$(VERSION).tar.gz: pure64-$(VERSION)
	tar -pcvzf $@ $<

pure64-$(VERSION):
	$(MAKE) install DESTDIR=$(PWD)/$@ PREFIX=/

.PHONY: test
test: pure64.img
	./test.sh

pure64.img: all testing/kernel
	./src/util/pure64 mkfs
	./src/util/pure64 mkdir /boot
	./src/util/pure64 cp testing/kernel /boot/kernel

testing/kernel: testing/kernel.o
	ld $< -o $@

testing/kernel.o: testing/kernel.asm
	nasm $< -f elf64 -o $@

$(V).SILENT:
