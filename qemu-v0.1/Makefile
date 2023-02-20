SRC=qemu-start.s
CHIP=t13
FLASHHEX=$(SRC).hex
EEPHEX=$(SRC).eep.hex
FLASHBIN=flash.bin
PROG=usbasp

CFLAGS=-o $(FLASHHEX) -e $(EEPHEX)

CC=avra
BURNER=avrdude


#################################
#################################
all: $(SRC) compile burnflash
	echo re-compile and burn

burnflash: $(FLASHHEX) $(EEPHEX)
	@echo '[burning flash & eeprom]'
	$(BURNER) -c $(PROG) -p $(CHIP) -U flash:w:$(FLASHHEX)

qemubin: compile
	@echo '[generate bin for QEMU]'
	@objcopy --input-target=ihex --output-target=binary $(FLASHHEX) $(FLASHBIN)

compile: $(SRC)
	@echo '[compile]'
	$(CC) $(CFLAGS) $(SRC)

edit:
	vim $(SRC)

clean:
	rm -rfv *.obj *.cof *.hex *.bin
