/*
  ==========================================================
 CheatersLounge CheatsEngine v1.3r03b Cheat Engine v2.1
 CodeDesigner v2.0 Source Copyright ©
 Created by Gtlcpimp

  ==========================================================
*/
address $80078910
//address $0107F010

_init:
addiu sp, sp, $FFF0
sq ra, $0000(sp)
jalr k0
nop
//call _debugGenerate
call _start
lq ra, $0000(sp)
jr ra
addiu sp, sp, $0010

//==========================================================
_start:
addiu sp, sp, $FE00
sq at, $0000(sp)
sq v0, $0010(sp)
sq v1, $0020(sp)
sq a0, $0030(sp)
sq a1, $0040(sp)
sq a2, $0050(sp)
sq a3, $0060(sp)
sq t0, $0070(sp)
sq t1, $0080(sp)
sq t2, $0090(sp)
sq t3, $00a0(sp)
sq t4, $00b0(sp)
sq t5, $00c0(sp)
sq t6, $00d0(sp)
sq t7, $00e0(sp)
sq s0, $00f0(sp)
sq s1, $0100(sp)
sq s2, $0110(sp)
sq s3, $0120(sp)
sq s4, $0130(sp)
sq s5, $0140(sp)
sq s6, $0150(sp)
sq s7, $0160(sp)
sq t8, $0170(sp)
sq t9, $0180(sp)
sq k0, $0190(sp)
sq k1, $01a0(sp)
sq fp, $01b0(sp)
sq gp, $01c0(sp)
sq ra, $01d0(sp)

lui v0, $8008
lb v1, $8900(v0)
bne v1, zero, 7
nop
addiu v1, zero, 1
sb v1, $8900(v0)

call _main

lui v0, $8008
sb zero, $8900(v0)


lq at, $0000(sp)
lq v0, $0010(sp)
lq v1, $0020(sp)
lq a0, $0030(sp)
lq a1, $0040(sp)
lq a2, $0050(sp)
lq a3, $0060(sp)
lq t0, $0070(sp)
lq t1, $0080(sp)
lq t2, $0090(sp)
lq t3, $00a0(sp)
lq t4, $00b0(sp)
lq t5, $00c0(sp)
lq t6, $00d0(sp)
lq t7, $00e0(sp)
lq s0, $00f0(sp)
lq s1, $0100(sp)
lq s2, $0110(sp)
lq s3, $0120(sp)
lq s4, $0130(sp)
lq s5, $0140(sp)
lq s6, $0150(sp)
lq s7, $0160(sp)
lq t8, $0170(sp)
lq t9, $0180(sp)
lq k0, $0190(sp)
lq k1, $01a0(sp)
lq fp, $01b0(sp)
lq gp, $01c0(sp)
lq ra, $01d0(sp)
jr ra
addiu sp, sp, $0200


//==========================================================
_main:

addiu sp, sp, $FFF0
sq ra, $0000(sp)

//lui s0, $0108
lui s0, $8008
addiu s0, s0, $8250

_mainLoop:


lw a0, $0000(s0)
bne a0, zero, 3
nop
goto _mainQuit


/*
Chunk Style

00000000

TTWWAAAA

T: Type
   00 Normal Code
   01 Embeded Data -------------> Not Implemented Yet
   02 Embeded Routine ----------> Not Implemented Yet
W: Write
   00 Normal Code Write
   01 Embeded Data Write -------> Not Implemented Yet
   02 Embeded Routine No Write -> Not Implemented Yet
A: Address on stack

*/


lh a0, $0000(s0)
addiu a0, a0, -1

sll a0, a0, 2

//lui v0, $0103
lui v0, $8003
addu a0, v0, a0

call _processChunk

addiu s0, s0, 4
goto _mainLoop
nop

_mainQuit:
lq ra, $0000(sp)
jr ra
addiu sp, sp, $0010


//==========================================================
_processChunk:

addiu sp, sp, $FFE0
sq ra, $0000(sp)
sq s0, $0010(sp)

addu s0, a0, zero

_processChunkLoop:

lw v0, $0000(s0)
bne v0, zero, 3
nop
goto _processChunkQuit

daddu a2, s0, zero
srl a0, v0, 28
srl a1, v0, 24
call _writeCode


addiu a0, zero, -1
bne a0, v0, 3
nop
goto _processChunkQuit

addu s0, s0, v0
goto _processChunkLoop



_processChunkQuit:
lq s0, $0010(sp)
lq ra, $0000(sp)
jr ra
addiu sp, sp, $0020


//==========================================================
_handleBoolean:

// a0 = List Pointer

addiu sp, sp, $FFF0
sq ra, $0000(sp)

lw v1, $0000(a0)

srl a1, v1, 28

addiu v1, zero, $0007
bne a1, v1, 3
nop
goto _hb_7

addiu v1, zero, $000D
bne a1, v1, 3
nop
goto _hb_D

addiu v1, zero, $000E
bne a1, v1, 3
nop
goto _hb_E

lb v1, $0003(a0)
addiu v1, zero, $00FD
bne v0, v1, 3
nop
goto _hb_FD


addiu v0, zero, -1
goto _handleBooleanQuit

// ---------------------------
_hb_7:

lw v0, $0000(a0)
sll v1, v1, 28
subu v0, v0, v1

lw a1, $0000(v0)
lw v1, $0004(a0)
bne a1, v1, 4
nop
addiu v0, zero, 8
goto _handleBooleanQuit

addiu v0, zero, -1
goto _handleBooleanQuit

// ---------------------------
_hb_D:

lw v0, $0000(a0)
sll v1, a1, 28
subu v0, v0, v1
lh a1, $0000(v0)

lb v1, $0006(a0)
beq v1, zero, 10
nop
lh v1, $0004(a0)
beq a1, v1, 4
nop
addiu v0, zero, 8
goto _handleBooleanQuit
addiu v0, zero, -1
goto _handleBooleanQuit

lh v1, $0004(a0)
bne a1, v1, 4
nop
addiu v0, zero, 8
goto _handleBooleanQuit
addiu v0, zero, -1
goto _handleBooleanQuit

// ---------------------------
_hb_E:

lw v0, $0000(a0)
lh t0, $0004(a0)
sll v1, a1, 28
subu v0, v0, v1
lh t2, $0006(a0)
srl t1, t2, 4
sll t1, t1, 4
subu t2, t2, t1
srl t1, t1, 8
sll t1, t1, 3
addiu t1, t1, 8

lh t3, $0000(v0)

beq t2, zero, 4
nop
addiu t4, zero, 1
beq t2, t4, 9
nop

bne t3, t0, 4
nop
addiu v0, zero, 8
goto _handleBooleanQuit
addu v0, t1, zero
goto _handleBooleanQuit

beq t3, t0, 4
nop
addiu v0, zero, 8
goto _handleBooleanQuit
addu v0, t1, zero
goto _handleBooleanQuit

// ---------------------------
_hb_FD:



addiu v0, zero, -1
goto _handleBooleanQuit


_handleBooleanQuit:
lq ra, $0000(sp)
jr ra
addiu sp, sp, $0010




//==========================================================
_writeCode:


addiu sp, sp, $FFF0
sq ra, $0000(sp)


// a0 = 8 Bit command (0xD)
// a1 = 16 Bit command (0xFD)
// a2 = List Pointer
// v0 = Size return

addu v0, zero, zero


// ---------------------------
addiu v1, zero, $0000
bne v1, a0, 3
nop
goto _cw_8

// ---------------------------
addiu v1, zero, $0001
bne v1, a0, 3
nop
goto _cw_16

// ---------------------------
addiu v1, zero, $0002
bne v1, a0, 3
nop
goto _cw_32

// ---------------------------
addiu v1, zero, $0003
bne v1, a0, 3
nop
goto _cw_inc_dec

// ---------------------------
addiu v1, zero, $0004
bne v1, a0, 3
nop
goto _cw_maw_32

// ---------------------------
addiu v1, zero, $0005
bne v1, a0, 3
nop
goto _cw_copy

// ---------------------------
addiu v1, zero, $0006
bne v1, a0, 3
nop
goto _cw_pointer

// ---------------------------
addiu v1, zero, $0007
bne v1, a0, 6
nop
addu a0, a2, zero
call _handleBoolean
goto _cw_exit

// ---------------------------
addiu v1, zero, $0008
bne v1, a0, 3
nop
goto _cw_replace

// ---------------------------
addiu v1, zero, $0009
bne v1, a0, 14
nop
lw a1, $0000(a2)
srl a0, a1, 28
sll a0, a0, 28
subu a1, a1, a0
lw v1, $0000(a1)
lw a0, $0004(a2)
beq v1, zero, 3
nop
call _execRoutine
addiu v0, zero, 8
goto _cw_exit

// ---------------------------
addiu v1, zero, $000A
bne v1, a0, 3
nop
goto _cw_A

// ---------------------------
addiu v1, zero, $000B
bne v1, a0, 3
nop
goto _cw_delay

// ---------------------------
addiu v1, zero, $000C
bne v1, a0, 3
nop
goto _cw_stopper

// ---------------------------
addiu v1, zero, $000D
bne v1, a0, 6
nop
daddu a0, a2, zero
call _handleBoolean
goto _cw_exit

// ---------------------------
addiu v1, zero, $000E
bne v1, a0, 6
nop
daddu a0, a2, zero
call _handleBoolean
goto _cw_exit

// ---------------------------
addiu v1, zero, $000F
bne v1, a0, 3
nop
goto _cw_extended


addiu v0, zero, -1
goto _cw_exit

_cw_extended:

// ---------------------------
addiu v1, zero, $00F0
bne v1, a1, 3
nop
goto _cw_iop_8

// ---------------------------
addiu v1, zero, $00F1
bne v1, a1, 3
nop
goto _cw_iop_16

// ---------------------------
addiu v1, zero, $00F2
bne v1, a1, 3
nop
goto _cw_iop_32


addiu v0, zero, -1
goto _cw_exit

// ---------------------------
_cw_8:
lw t0, $0000(a2)
lb t1, $0004(a2)
lui v0, $2000
addu t0, t0, v0
sb t1, $0000(t0)
addiu v0, zero, 8
goto _cw_exit

// ---------------------------
_cw_16:
sll t2, a0, 28
lw t0, $0000(a2)
subu t0, t0, t2
lh t1, $0004(a2)
lui v0, $2000
addu t0, t0, v0
sh t1, $0000(t0)
addiu v0, zero, 8
goto _cw_exit

// ---------------------------
_cw_32:
sll t2, a0, 28
lw t0, $0000(a2)
subu t0, t0, t2
lw t1, $0004(a2)
lui v0, $2000
addu t0, t0, v0
sw t1, $0000(t0)
addiu v0, zero, 8
goto _cw_exit

// ---------------------------
_cw_inc_dec:

lw t0, $0004(a2)
lb t1, $0002(a2)

bne t1, zero, 3
nop
goto _cw_inc_dec_0

addiu v1, zero, $0010
bne t1, v1, 3
nop
goto _cw_inc_dec_1

addiu v1, zero, $0020
bne t1, v1, 3
nop
goto _cw_inc_dec_2

addiu v1, zero, $0030
bne t1, v1, 3
nop
goto _cw_inc_dec_3

addiu v1, zero, $0040
bne t1, v1, 3
nop
goto _cw_inc_dec_4

addiu v1, zero, $0050
bne t1, v1, 3
nop
goto _cw_inc_dec_5

addiu v0, zero, -1
goto _cw_exit

// -------------------
_cw_inc_dec_0:

lb t1, $0000(t0)
lb t2, $0000(a2)
addu t1, t1, t2
sb t1, $0000(t0)

addiu v0, zero, 8
goto _cw_exit

// -------------------
_cw_inc_dec_1:

lb t1, $0000(t0)
lb t2, $0000(a2)
subu t1, t1, t2
sb t1, $0000(t0)

addiu v0, zero, 8
goto _cw_exit

// -------------------
_cw_inc_dec_2:

lh t1, $0000(t0)
lh t2, $0000(a2)
addu t1, t1, t2
sh t1, $0000(t0)

addiu v0, zero, 8
goto _cw_exit

// -------------------
_cw_inc_dec_3:

lh t1, $0000(t0)
lh t2, $0000(a2)
subu t1, t1, t2
sh t1, $0000(t0)

addiu v0, zero, 8
goto _cw_exit

// -------------------
_cw_inc_dec_4:

lw t1, $0000(t0)
lw t2, $0008(a2)
addu t1, t1, t2
sw t1, $0000(t0)

addiu v0, zero, 16
goto _cw_exit

// -------------------
_cw_inc_dec_5:

lw t1, $0000(t0)
lw t2, $0008(a2)
subu t1, t1, t2
sw t1, $0000(t0)

addiu v0, zero, 16
goto _cw_exit

// ---------------------------
_cw_maw_32:

lw t0, $0000(a2)
sll t2, a0, 28
subu t0, t0, t2
lh t1, $0004(a2)
lh t2, $0006(a2)
lw t3, $0008(a2)
lw t4, $000C(a2)

sll t1, t1, 2

_cw_maw_32_loop:

bne t2, zero, 3
nop
goto _cw_maw_32_exit

sw t3, $0000(t0)

addu t3, t3, t4
addiu t0, t0, 4
addu t0, t0, t1
addiu t2, t2, -1
goto _cw_maw_32_loop

_cw_maw_32_exit:
addiu v0, zero, 16
goto _cw_exit

// ---------------------------
_cw_copy:

lw t0, $0000(a2)
sll t1, a0, 28
subu t0, t0, t1
lw t1, $0008(a2)
lw t2, $0004(a2)

_cw_copy_loop:
bne t2, zero, 3
nop
goto _cw_copy_exit


lb t3, $0000(t0)
sb t3, $0000(t1)

addiu t0, t0, 1
addiu t1, t1, 1
addiu t2, t2, -1
goto _cw_copy_loop

_cw_copy_exit:
addiu v0, zero, 16
goto _cw_exit

// ---------------------------
_cw_pointer:
addu v0, zero, zero
addu v1, a2, zero
addu t8, zero, zero

lw t0, $0000(a2)
sll t1, a0, 28
subu t0, t0, t1
lw t1, $0004(a2)

lw t0, $0000(t0)

addiu v0, v0, 8
addiu v1, v1, 8

_cw_pointer_loop:

addiu t5, zero, -1
bne t1, t5, 3
nop
goto _cw_pointer_exit

lb t3, $0003(v1)

addiu t4, zero, $0006
bne t3, t4, 3
nop
goto _cw_pointer_point

addiu t4, zero, $0001
bne t3, t4, 3
nop
goto _cw_pointer_write_0

addiu t4, zero, $0002
bne t3, t4, 3
nop
goto _cw_pointer_write_1

addiu t4, zero, $0003
bne t3, t4, 3
nop
goto _cw_pointer_write_2

addiu v0, zero, -1
goto _cw_pointer_exit

// -------------------
_cw_pointer_point:

lh t4, $0000(v1)
sll t4, t4, 2
addu t0, t0, t4
lw t0, $0000(t0)

goto _cw_pointer_skip

// -------------------
_cw_pointer_write_0:

lh t4, $0000(v1)
addu t0, t0, t4
lb t2, $0004(v1)
sb t2, $0000(t0)

goto _cw_pointer_skip

// -------------------
_cw_pointer_write_1:

lh t4, $0000(v1)
sll t4, t4, 1
addu t0, t0, t4
lh t2, $0004(v1)
sh t2, $0000(t0)


goto _cw_pointer_skip

// -------------------
_cw_pointer_write_2:

lh t4, $0000(v1)
sll t4, t4, 2
addu t0, t0, t4
lw t2, $0004(v1)
sw t2, $0000(t0)

goto _cw_pointer_skip


_cw_pointer_skip:

addiu t5, zero, 1
subu t8, t5, t8

addiu v0, v0, 4
addiu v1, v1, 4
addiu t1, t1, -1
goto _cw_pointer_loop


_cw_pointer_exit:
bne t8, zero, 2
nop
addiu v0, v0, 4
addiu v0, v0, 4
goto _cw_exit

// ---------------------------
_cw_replace:

lw t0, $0000(a2)
sll t1, a0, 28
subu t0, t0, t1
lh t3, $000C(a2)
lb t4, $000E(a2)

bne t4, zero, 3
nop
goto _cw_replace_0

addiu t1, zero, $0010
bne t4, t1, 3
nop
goto _cw_replace_1

addiu t1, zero, $0020
bne t4, t1, 3
nop
goto _cw_replace_2

addiu v0, zero, -1
goto _cw_exit

// -------------------
_cw_replace_0:
lb t1, $0004(a2)
lb t2, $0008(a2)

_cw_replace_0_loop:

bne t3, zero, 3
nop
goto _cw_replace_exit

lb v1, $0000(t0)
bne t1, v1, 2
nop
sb t2, $0000(t0)

addiu t0, t0, 1
addiu t3, t3, -1
goto _cw_replace_0_loop

// -------------------
_cw_replace_1:
lh t1, $0004(a2)
lh t2, $0008(a2)
sll t3, t3, 1

_cw_replace_1_loop:

bne t3, zero, 3
nop
goto _cw_replace_exit

lh v1, $0000(t0)
bne t1, v1, 2
nop
sh t2, $0000(t0)

addiu t0, t0, 2
addiu t3, t3, -2
goto _cw_replace_1_loop

// -------------------
_cw_replace_2:
lw t1, $0004(a2)
lw t2, $0008(a2)
sll t3, t3, 2

_cw_replace_2_loop:

bne t3, zero, 3
nop
goto _cw_replace_exit

lw v1, $0000(t0)
bne t1, v1, 2
nop
sw t2, $0000(t0)

addiu t0, t0, 4
addiu t3, t3, -4
goto _cw_replace_2_loop

_cw_replace_exit:
addiu v0, zero, 16
goto _cw_exit

// ---------------------------
/* Used to be DNAS Patch
   command, but was removed
   since manual IOP writes
   were easier to use.
*/
_cw_A:


_cw_A_exit:

lq ra, $0000(sp)
jr ra
addiu sp, sp, $0010


// ---------------------------
_cw_delay:
addu v0, zero, zero
goto _cw_exit

// ---------------------------
_cw_stopper:


addu v0, zero, zero
goto _cw_exit

// ---------------------------
_cw_iop_8:

lw t0, $0000(a2)
sll t1, a1, 24
subu t0, t0, t1
lui t1, $BC00
addu t1, t1, t0

lb t2, $0004(a2)
sb t2, $0000(t1)

addiu v0, zero, 8
goto _cw_exit


// ---------------------------
_cw_iop_16:

lw t0, $0000(a2)
sll t1, a1, 24
subu t0, t0, t1
lui t1, $BC00
addu t1, t1, t0

lh t2, $0004(a2)
sh t2, $0000(t1)

addiu v0, zero, 8
goto _cw_exit


// ---------------------------
_cw_iop_32:

lw t0, $0000(a2)
sll t1, a1, 24
subu t0, t0, t1
lui t1, $BC00
addu t1, t1, t0

lw t2, $0004(a2)
sw t2, $0000(t1)

addiu v0, zero, 8
goto _cw_exit


_cw_exit:
lq ra, $0000(sp)
jr ra
addiu sp, sp, $0010

//==========================================================
_execRoutine:

addiu sp, sp, $FE00
sq at, $0000(sp)
sq v0, $0010(sp)
sq v1, $0020(sp)
sq a0, $0030(sp)
sq a1, $0040(sp)
sq a2, $0050(sp)
sq a3, $0060(sp)
sq t0, $0070(sp)
sq t1, $0080(sp)
sq t2, $0090(sp)
sq t3, $00a0(sp)
sq t4, $00b0(sp)
sq t5, $00c0(sp)
sq t6, $00d0(sp)
sq t7, $00e0(sp)
sq s0, $00f0(sp)
sq s1, $0100(sp)
sq s2, $0110(sp)
sq s3, $0120(sp)
sq s4, $0130(sp)
sq s5, $0140(sp)
sq s6, $0150(sp)
sq s7, $0160(sp)
sq t8, $0170(sp)
sq t9, $0180(sp)
sq k0, $0190(sp)
sq k1, $01a0(sp)
sq fp, $01b0(sp)
sq gp, $01c0(sp)
sq ra, $01d0(sp)

jalr a1
nop

lq at, $0000(sp)
lq v0, $0010(sp)
lq v1, $0020(sp)
lq a0, $0030(sp)
lq a1, $0040(sp)
lq a2, $0050(sp)
lq a3, $0060(sp)
lq t0, $0070(sp)
lq t1, $0080(sp)
lq t2, $0090(sp)
lq t3, $00a0(sp)
lq t4, $00b0(sp)
lq t5, $00c0(sp)
lq t6, $00d0(sp)
lq t7, $00e0(sp)
lq s0, $00f0(sp)
lq s1, $0100(sp)
lq s2, $0110(sp)
lq s3, $0120(sp)
lq s4, $0130(sp)
lq s5, $0140(sp)
lq s6, $0150(sp)
lq s7, $0160(sp)
lq t8, $0170(sp)
lq t9, $0180(sp)
lq k0, $0190(sp)
lq k1, $01a0(sp)
lq fp, $01b0(sp)
lq gp, $01c0(sp)
lq ra, $01d0(sp)
jr ra
addiu sp, sp, $0200


//==========================================================
_debugGenerate:


nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop