address $000af900

_start:

lui t0, $000b
addiu t7, t0, $f000
addiu t7, t7, $0010

lw t4, $f008(t0)
lw t4, $0000(t4)
beq t4, zero, :_exit
lw t1, $f008(t0)
lw t5, $0000(t1)
lw t6, $0004(t1)
sw t6, $0000(t5)
addiu t1, t1, $0010
sw t1, $f008(t0)
//addiu t4, t4, $0001
//sw t4, $f004(t0)
bne t4, zero, :_start

_exit:
sw zero, $f004(t0)
sw t7, $f008(t0)
jr ra

//j $000af900 //Hook for codemajic - deadlocked

/*
For CodeMajic

200af000 000000002 //If I use this method - write how many codes

200af008 000af010 //If I use this method - analyze how many codes

200af010 00347d9c //Airwalk address
200af014 00000000 //Airwalk value
200af020 00347e8c //Rapidfire address
200af024 00000000 //Rapidfire value

2012715c 0802BE40 //hook

200af020 009FB12C //MULTIPLAYER string address
200af024 00000000 //MULTIPLAYER string value

*/