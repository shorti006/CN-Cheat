address $00080000

//j $000af900

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

_codes:
lui t0, $8008

lw t4, $1000(t0)
lw t4, $0000(t4)
beq t4, zero, :_exit
lw t2, $1000(t0)
lw t5, $0000(t2)
lw t6, $0004(t2)

srl t7, t5, 25
sll t8, t7, 25
subu t5, t5, t8
srl t7, t8, 24

sw t6, $0000(t5)

lw t2, $1000(t0)
addiu t2, t2, $0010
sw t2, $1000(t0)
//jal :_procCodes
beq zero, zero, :_codes

/*
_procCodes:

beq t7, zero, :_8
nop

addiu t8, zero, $0010
beq t7, t8, :_16
nop

addiu t8, zero, $0020
beq t7, t8, :_32
nop

beq zero, zero, :_codes
nop

_8:
sb t6, $0000(t5)

beq zero, zero, :_codes
nop

_16:
sh t6, $0000(t5)

beq zero, zero, :_codes
nop

_32:
sw t6, $0000(t5)

beq zero, zero, :_codes
nop
*/

_exit:
lui t0, $8008
addiu t1, t0, $1010
sw t1, $1000(t0)
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

/*

2012715c 0802BE40 //hook

200af010 209FB12D
200af014 00000000 //Multiplayer string
200af020 20347E8C
200af024 00000000 //rapid fire

*/

