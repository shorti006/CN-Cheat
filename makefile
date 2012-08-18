EE_BIN = CN-Cheat.ELF
EE_OBJS = main.o Obj/cdvdinit_irx.o Obj/usbd.o Obj/usbhdfsd.o Obj/SMAP_IRX.o Obj/PS2IP_IRX.o Obj/PS2IPS_IRX.o Obj/PS2DEV9_IRX.o Obj/DNS_IRX.o Obj/POWEROFF_IRX.o
EE_LIBS = -lgraph -ldma -lc -lpacket -lpad -ldebug -lcdvd -lps2ip

all: $(EE_BIN)
	ee-strip --strip-all $(EE_BIN)
	rm -f main.o

clean:
	rm -f *.elf *.o *.a $(EE_ELF) $(EE_ELF) $(EE_OBJS)

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal
