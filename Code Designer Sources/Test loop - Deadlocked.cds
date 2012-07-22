/*

Keep in mind that this source is a test to make a operable loop.
All it does is store the value of 00000000 at 00347E8C (rapid fire hack for Deadlocked). Then makes the address 0012715c (hook address for Deadlocked), have the value 0802bc94. That is the MIPS Assembly equivalent of: j $000af250.
The hook is a cheat engine. This was just a test to make a working loop.

*/

address $000af250

//Actual code: 00347E8C 00000000
lui t1, $0034
add t6, zero, zero
sw t6, $7e8c(t1) //stores 00347E8C as 00000000

// hook Loop: 0012715c 0802bc94 (j $000af250)
lui t3, $0803
addiu t4, t3, $bc94
lui t5, $0012
sw t4, $715C(t5) //stores 0012715c as 0802bc94
jr ra