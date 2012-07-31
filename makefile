EE_BIN = CN-Cheat.ELF
EE_OBJS = main.o Obj/cdvdinit_irx.o Obj/usbd.o Obj/usbhdfsd.o
EE_LIBS = -lgraph -ldma -lc -lpacket -lpad -ldebug -lcdvd

all: $(EE_BIN)
	ee-strip --strip-all $(EE_BIN)
	rm -f main.o

clean:
	rm -f *.elf *.o *.a $(EE_ELF) $(EE_ELF) $(EE_OBJS)

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
