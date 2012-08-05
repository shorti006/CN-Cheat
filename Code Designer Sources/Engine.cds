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

lui t0, $8008

_code:
lw t1, $1000(t0)
lw t2, $0000(t1)
beq t2, zero, :_exit
nop
lw t3, $1000(t0)
lw s0, $0000(t3)
lw s1, $0004(t3)

srl t7, s0, 25
sll t8, t7, 25
subu s0, s0, t8
srl t7, t8, 24

jal :_procCodes
beq zero, zero, :_code
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

beq zero, zero, :_ERROR
nop

_ERROR:
addiu t4, t3, $0010
sw t4, $1000(t0)
beq zero, zero, :_code
nop

_8:
sb s1, $0000(s0)
addiu t4, t3, $0010
sw t4, $1000(t0)

beq zero, zero, :_code
nop


_16:
sh s1, $0000(s0)
addiu t4, t3, $0010
sw t4, $1000(t0)

beq zero, zero, :_code
nop


_32:
sw s1, $0000(s0)
addiu t4, t3, $0010
sw t4, $1000(t0)

beq zero, zero, :_code
nop

_D:
lh s2, $0000(s0)
lui s7, $FFFF
addu s1, s7, s1
bne s2, s1, :_DExit
lw s4, $0010(t3)
lw s5, $0014(t3)

srl t7, s4, 25
sll t8, t7, 25
subu s4, s4, t8

sw s5, $0000(s4)

_DExit:
addiu t4, t3, $0020
sw t4, $1000(t0)

beq zero, zero, :_code
nop

_exit:
addiu t9, t0, $1010
sw t9, $1000(t0)

lq ra, $0000(sp)
lq s0, $0010(sp)
lq s1, $0020(sp)
lq s2, $0030(sp)
lq s3, $0040(sp)
lq s4, $0050(sp)
lq s5, $0060(sp)
lq s6, $0070(sp)
lq s7, $0080(sp)
jr ra
addiu sp, sp, $0100


