#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <packet.h>
#include <dma.h>
#include <kernel.h>
#include <libpad.h>
#include <sifrpc.h>
#include <debug.h>
#include <tamtypes.h>
#include <iopcontrol.h>
#include <loadfile.h>
#include <fileio.h>
#include "malloc.h"
#include "libcdvd.h"
#include "r5900_regs.h"
#include "Engine.c"

#define _RESIDENT_	__attribute__((section(".resident")))
#define DEBUG

char *bootFileName;

#define ERROR_SYSTEMCNF_PARSE	-6
#define ERROR_SYSTEMCNF_FILEIO	-7
#define ERROR_SYSTEMCNF_MEMORY	-8

/*
	
	Keep in mind the pad initialization and execution of the
	game was directly taken from cYs Driver's Cora Dumper.
	Therefore, credit is his for making that both of those
	very critical features.
	
*/

int LoadModule(void);
void ExecGame(void);

//PAD VARIABLES
	//check for multiple definitions
	#if !defined(ROM_PADMAN) && !defined(NEW_PADMAN)
	#define ROM_PADMAN
	#endif

	#if defined(ROM_PADMAN) && defined(NEW_PADMAN)
	#error Only one of ROM_PADMAN & NEW_PADMAN should be defined!
	#endif

	#if !defined(ROM_PADMAN) && !defined(NEW_PADMAN)
	#error ROM_PADMAN or NEW_PADMAN must be defined!
	#endif
	//pad buffer
	static char padBuf[256] __attribute__((aligned(64)));
	//rumblers
	static char actAlign[6];
	static int actuators;
	//button status
	struct padButtonStatus buttons;
		u32 paddata;
		u32 old_pad;
		u32 new_pad;
	int port, slot;

typedef struct {
	u8	ident[16];
	u16	type;
	u16	machine;
	u32	version;
	u32	entry;
	u32	phoff;
	u32	shoff;
	u32	flags;
	u16	ehsize;
	u16	phentsize;
	u16	phnum;
	u16	shentsize;
	u16	shnum;
	u16	shstrndx;
} elf_header_t;

typedef struct {
	u32	type;
	u32	offset;
	void	*vaddr;
	u32	paddr;
	u32	filesz;
	u32	memsz;
	u32	flags;
	u32	align;
} elf_pheader_t;

elf_header_t elfh;

static void loadModules(void)
{
    int ret;
#ifdef ROM_PADMAN
    ret = SifLoadModule("rom0:SIO2MAN", 0, NULL);
#else
    ret = SifLoadModule("rom0:XSIO2MAN", 0, NULL);
#endif
    if (ret < 0) {
        SleepThread();
    }
	ret = SifLoadModule("rom0:CDVDMAN", 0, NULL);
	if(ret < 0) {
		SleepThread();
	}

#ifdef ROM_PADMAN
    ret = SifLoadModule("rom0:PADMAN", 0, NULL);
#else
    ret = SifLoadModule("rom0:XPADMAN", 0, NULL);
#endif
    if (ret < 0) {
        SleepThread();
    }
}

static int waitPadReady(int port, int slot)
{
    int state;
    int lastState;
    char stateString[16];

    state = padGetState(port, slot);
    lastState = -1;
    while((state != PAD_STATE_STABLE) && (state != PAD_STATE_FINDCTP1)) {
        if (state != lastState) {
            padStateInt2String(state, stateString);
        }
        lastState = state;
        state=padGetState(port, slot);
    }
    // Were the pad ever 'out of sync'?
    if (lastState != -1) {

    }
    return 0;
}

static int initializePad(int port, int slot)
{

    int ret;
    int modes;
    int i;

    waitPadReady(port, slot);
    modes = padInfoMode(port, slot, PAD_MODETABLE, -1);
    if (modes > 0) {
        for (i = 0; i < modes; i++) {
        }

    }
    if (modes == 0) {
        return 1;
    }

    i = 0;
    do {
        if (padInfoMode(port, slot, PAD_MODETABLE, i) == PAD_TYPE_DUALSHOCK)
            break;
        i++;
    } while (i < modes);
    if (i >= modes) {
        return 1;
    }

    ret = padInfoMode(port, slot, PAD_MODECUREXID, 0);
    if (ret == 0) {
        return 1;
    }
    padSetMainMode(port, slot, PAD_MMODE_DUALSHOCK, PAD_MMODE_LOCK);

    waitPadReady(port, slot);
    padInfoPressMode(port, slot);

    waitPadReady(port, slot);
    padEnterPressMode(port, slot);

    waitPadReady(port, slot);
    actuators = padInfoAct(port, slot, -1, 0);

    if (actuators != 0) {
        actAlign[0] = 0;
        actAlign[1] = 1;
        actAlign[2] = 0xff;
        actAlign[3] = 0xff;
        actAlign[4] = 0xff;
        actAlign[5] = 0xff;

        waitPadReady(port, slot);

       padSetActAlign(port, slot, actAlign);
    }
    else {
        //printf("Did not find any actuators.\n");
    }
    return 1;
}

void initalise(void)
{
	int ret;
	
	// load all modules
	loadModules();
	// init pad
	padInit(0);
	if((ret = padPortOpen(0, 0, padBuf)) == 0) {
		#if defined DEBUG
			scr_printf("padOpenPort failed: %d\n", ret);
		#endif
		SleepThread();
	}

	if(!initializePad(0, 0)) {
		#if defined DEBUG
			scr_printf("pad initalization failed!\n");
		#endif
		SleepThread();
	}
}

/////////////////////////////////////////////////////////////////////
//waitPadReady

/////////////////////////////////////////////////////////////////////
//buttonStatts
/////////////////////////////////////////////////////////////////////
static void buttonStatts(int port, int slot)
{
	int ret;
		ret = padRead(port, slot, &buttons);

        if (ret != 0) {
            paddata = 0xffff ^ buttons.btns;

            new_pad = paddata & ~old_pad;
            old_pad = paddata;
		}
}

/////////////////////////////////////////////////////////////////////
//checkPadConnected
/////////////////////////////////////////////////////////////////////
void checkPadConnected(void)
{
	int ret, i;
	ret=padGetState(0, 0);
	while((ret != PAD_STATE_STABLE) && (ret != PAD_STATE_FINDCTP1)) {
		if(ret==PAD_STATE_DISCONN) {
			#if defined DEBUG
	           scr_printf("	Pad(%d, %d) is disconnected\n", 0, 0);
			#endif
		}
		ret=padGetState(0, 0);
	}
	if(i==1) {
		//scr_printf("	Pad: OK!\n");
	}
}

/////////////////////////////////////////////////////////////////////
//pad_wat_button
/////////////////////////////////////////////////////////////////////
void pad_wait_button(u32 button)
{
	while(1)
	{
		buttonStatts(0, 0);
		if(new_pad & button) return;
	}
}

void waitCdReady()
{
	// Block until the dvdrom is ready to take commands
	cdDiskReady(0);

	// Spin up the cd/dvd
	cdStandby();
}

char *parseSystemCnf()
{
	char *buffer;
	int fd, fdSize;
	int i;

	// Open SYSTEM.CNF on the cdrom, allocate memory for it, terminate the array
	fd = fioOpen("cdrom0:\\SYSTEM.CNF;1", O_RDONLY);
	if(fd < 0) return (char *)ERROR_SYSTEMCNF_FILEIO;

	fdSize = fioLseek(fd, 0, SEEK_END);
	fioLseek(fd, 0, SEEK_SET);

	buffer = malloc(fdSize + 1);
	if(!buffer) return (char *)ERROR_SYSTEMCNF_MEMORY;

	if(fioRead(fd, buffer, fdSize) != fdSize) return (char *)ERROR_SYSTEMCNF_FILEIO;
	fioClose(fd);
	buffer[fdSize] = '\0';

	// Find boot file substring
	buffer = strstr(buffer, "BOOT2");
	buffer += 5;
	while((*buffer == ' ') || (*buffer == '\t')) buffer++;
	buffer++; // bypass '=' character
	while((*buffer == ' ') || (*buffer == '\t')) buffer++;

	i = 0;
	while((buffer[i] != '\n') && (buffer[i] != '\r')) i++;

	// Terminate string at end of boot elf filename
	buffer[i] = '\0';

	// Return pointer to boot elf filename string
	return buffer;
}

int BinRead(char *filename)
{
	int State = 0;
	u32 Addr = 0x80081010;
	u32 Addr2 = 0x80081014;
	char result[5];
	FILE *fd;
	fd = fopen(filename, "r");

	while ( fread(result, sizeof fd, 1, fd) == 1) {
	//scr_printf("	%s\n", result);

	if (State == 0) //Alternates between writing the address and writing the value
	{
	ee_kmode_enter();
	*(u32*)Addr = *(u32*)result;
	ee_kmode_exit();

	State = 1;

	Addr = Addr + 0x00000010;
	}
	else if (State == 1)
	{
	ee_kmode_enter();
	*(u32*)Addr2 = *(u32*)result;
	ee_kmode_exit();

	State = 0;

	Addr2 = Addr2 + 0x00000010;
	}

	}

	fclose(fd);
	return 0;
}

int WriteCheats()
{

	int a = 0;
	FILE *fp;
	fp = fopen("mc0:/cheat.bin", "r");

	if (fp < 0)
	{
		printf("Could not open cheat.txt");
		scr_printf("Could not open mc0:/cheat.bin");
		return 0;
		fclose(fp);
	}

	if (fp > 0)
	{
	
	a = BinRead("mc0:/cheat.bin");
	
	if ( a < 0 )
	{
		scr_printf("	Did not successfully write cheats!\n");
	}
	scr_printf("\n	Cheats activated\n");
	}

	fclose(fp);
	return 0;

}

int StartMenu(void)
{
	int state = 1;
	//int x = 0;

	scr_printf("	CN-Cheat Shell Menu.\n	Press (X) to boot, Press SELECT for credits,	SQUARE to load cheats, Press UP to go into server mode\n");
	while (1)
	{

	
   if (padRead(0, 0, &buttons));
		{

		checkPadConnected();
		//read pad 1
		buttonStatts(0, 0);

			if (new_pad & PAD_SELECT)
			{
				state = 2;
				scr_clear();
				scr_printf("\n\n	CREDITS:\n");
				scr_printf("\n		Gtlcpimp: Basic Hook Concept (From His Sources), Code Designer (Tool Used For MIPS)");
				scr_printf("\n		Pyriel: Help On All The Troubleshooting With The Hook");
				scr_printf("\n		Badger41: Teaching Me MIPS Assembly");
				scr_printf("\n		cYs Driver: Source code For Cora Dumper (Initializing The Pad)\n");
				scr_printf("\n	END OF CREDITS\n 	Press (X) To Return To Menu\n");
			}

			if (state == 2)
			{
					if (new_pad & PAD_CROSS)
					{
						scr_clear();
						state = 1;
						StartMenu();
					}					

			}

			if (new_pad & PAD_SQUARE)
			{

			WriteCheats();

			}
			if (new_pad & PAD_CROSS)
			{
			
			ExecGame();
			
			}
			
		}
	}

   return 0;

}

void ExecGame(void)
{

			int i;

			scr_printf("	Installing Engine...\n");
			u32 EngineStore = 0x80080000;
			u32 EngineRead = (void*)Engine;

			for (i = 0; i < sizeof(Engine); i += 4)
			{
			//scr_printf("A");
			ee_kmode_enter();
			*(u32*)EngineStore = *(u32*)EngineRead;
			ee_kmode_exit();
			EngineStore += 4;
			EngineRead += 4;
			}

			ee_kmode_enter();
			*(u32*)0x80081000 = 0x80081010; //Writes the initial storage of the codes
			ee_kmode_exit();

			waitCdReady();
			scr_printf("	Loading...\n");
			//for (a = 0; a < 40000000; a++)
			{
			}

			if(strlen(bootFileName = parseSystemCnf()) <= 0)
			{
				scr_printf("	== Fatal Error ==\n");
				SleepThread();
			}

			scr_printf("\n	Loaded Game!\n");
			u32 HookValue = (0x00080000 / 4) + 0x0C000000;
			padPortClose(0, 0);
			//scr_printf("	Shut down PAD, shutting down RPC\n	GOODBYE!!!");
			SifExitRpc();
			ee_kmode_enter();
			*(u32*)0x800002FC = HookValue;
			ee_kmode_exit();
			LoadExecPS2((const char *)bootFileName, 0, NULL);

			SleepThread();

}

int main(void)
{
	SifInitRpc(0);
	init_scr();
	
	//LoadIRX();
	initalise();
	if (remove("mc0:/cheat.bin") < 0)
	{
		scr_printf("	Could not delete mc0:/cheat.bin");
	}
	scr_printf("	CN-CHEAT!\n");
	StartMenu();

	return 0;
}

