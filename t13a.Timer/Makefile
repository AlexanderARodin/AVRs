SRC=Timer.t13.s
CHIP=t13
FLASHHEX=flash.hex
EEPHEX=eep.hex
PROG=usbasp

CFLAGS=-o $(FLASHHEX) -e $(EEPHEX)
#CHIP=$(suffix $(SRC:.s=))

CC=avra
BURNER=avrdude


#################################
#################################
all: $(SRC) compile burnflash
	echo re-compile and burn

burnflash: $(FLASHHEX) $(EEPHEX)
	$(BURNER) -c $(PROG) -p $(CHIP) -U flash:w:$(FLASHHEX)

compile: $(SRC)
	$(CC) $(CFLAGS) $(SRC)

edit:
	vim $(SRC)

clean:
	rm -rf *.obj *.hex
