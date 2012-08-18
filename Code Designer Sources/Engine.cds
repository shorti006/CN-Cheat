address $00080000

_init:
addiu sp, sp, $FFF0
sq ra, $0000(sp)
jalr k0
nop
call _start
lq ra, $0000(sp)
jr ra
addiu sp, sp, $0010

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

lui t0, $8008

sw zero, $1008(t0)
sw zero, $1004(t0)

jal :_codemanage

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

_codemanage:
addiu sp, sp, $FF00
sq ra, $0000(sp)
sq s0, $0010(sp)
sq s1, $0020(sp)
sq s2, $0030(sp)
sq s3, $0040(sp)
sq s4, $0050(sp)
sq s5, $0060(sp)
sq s6, $0070(sp)
sq s7, $0080(sp)
sq a0, $0090(sp)
sq a1, $00A0(sp)
sq a2, $00B0(sp)
sq a3, $00C0(sp)

lui t0, $8008

_code:
lw t1, $1000(t0)
lw t2, $0000(t1)
beq t2, zero, :_exit
nop
lw t3, $1000(t0)
lw s0, $0000(t3)
lw s1, $0004(t3)

srl t7, s0, 25 //00000020 - Everything
sll t8, t7, 25 //20000000 - Everything
srl t7, t8, 24 //00000020 - Everything
subu s0, s0, t8 //20347E8C -> 00347E8C - Everything

beq zero, zero, :_procCodes
nop

_procCodes:

beq t7, zero, :_8
nop

addiu t8, zero, $0010
beq t7, t8, :_16
nop

addiu t8, zero, $0020
beq t7, t8, :_32
nop

addiu t8, zero, $00D0
beq t7, t8, :_D
nop

addiu t8, zero, $00E0
beq t7, t8, :_E
nop

beq zero, zero, :_ERROR
nop

_ERROR:
lw t3, $1000(t0)
addiu t4, t3, $0010
sw t4, $1000(t0)
beq zero, zero, :_code
nop

_8:

sb s1, $0000(s0)

addiu t4, t3, $0010
sw t4, $1000(t0)

lw s6, $1008(t0)

beq s6, zero, :_code
nop

beq zero, zero, :_ELoop
nop

_16:
sh s1, $0000(s0)

addiu t4, t3, $0010
sw t4, $1000(t0)

lw s6, $1008(t0)

beq s6, zero, :_code
nop

beq zero, zero, :_ELoop
nop


_32:
sw s1, $0000(s0)

lw s6, $1008(t0)

beq s6, zero, :_ERROR
nop

beq zero, zero, :_ELoop
nop

_D:
lh s2, $0000(s0)
lui s7, $FFFF
addu s1, s7, s1
bne s2, s1, :_DExit
lw s0, $0010(t3)
lw s1, $0014(t3)

addiu t4, t3, $0010
sw t4, $1000(t0)

srl t7, s0, 24
sll t8, t7, 24 
srl t7, t8, 24 
subu s0, s0, t8

beq t7, zero, :_8
nop

addiu t8, zero, $0010
beq t7, t8, :_16
nop

addiu t8, zero, $0020
beq t7, t8, :_32
nop

beq zero, zero, :_DExit
nop

_DExit:
addiu t4, t3, $0020
sw t4, $1000(t0)

beq zero, zero, :_code
nop

_E:
// Example of E: E002F3FF 001EE682
//0000???? a0 - Joker value
//0000000? t9 - joker multiplier

sll t7, s0, 8 //E001???? -> 01????00 - E joker
srl t7, t7, 24 //01????00 -> 00000001 - E joker
sll a0, s0, 16 //E001???? -> ????0000 - E joker
srl a0, a0, 16 //????0000 -> 0000???? - E joker


lh s2, $0000(s1)
lui s7, $FFFF
addu a0, s7, a0

bne s2, a0, :_EEExit
nop

_ELoop:

lw s3, $1004(t0)

beq s3, t7, :_EExit
nop

lui s6, $0001
addiu s6, zero, s6
sw s6, $1008(t0)

lw t3, $1000(t0)
addiu a1, t3, $0010
sw a1, $1000(t0)

lw s0, $0000(a1)
lw s1, $0004(a1)

srl v0, s0, 25
sll v1, v0, 25
srl v0, v1, 24
subu s0, s0, v1

addiu a2, s3, $0001
sw a2, $1004(t0)

beq v0, zero, :_8
nop

addiu t8, zero, $0010
beq v0, t8, :_16
nop

addiu t8, zero, $0020
beq v0, t8, :_32
nop

beq zero, zero, :_ELoop
nop

_EEExit:

sll t9, s0, 8 //E001???? -> 01????00 - E joker
srl t9, t9, 24 //01????00 -> 00000001 - E joker

sw zero, $1004(t0)

lw t3, $1000(t0)
addiu a3, zero, $0010
mult s7, a3, t9
mflo s7
add a3, s7, a3
add t4, t3, a3
sw t4, $1000(t0)

beq zero, zero, :_code
nop

_EExit:

sw zero, $1004(t0)
sw zero, $1008(t0)

lw t3, $1000(t0)
addiu a3, t3, $0010
sw a3, $1000(t0)

beq zero, zero, :_code
nop


_exit:
addiu s6, t0, $1010
sw s6, $1000(t0)

lq ra, $0000(sp)
lq s0, $0010(sp)
lq s1, $0020(sp)
lq s2, $0030(sp)
lq s3, $0040(sp)
lq s4, $0050(sp)
lq s5, $0060(sp)
lq s6, $0070(sp)
lq s7, $0080(sp)
sq a0, $0090(sp)
sq a1, $00A0(sp)
sq a2, $00B0(sp)
sq a3, $00C0(sp)
jr ra
addiu sp, sp, $0100

