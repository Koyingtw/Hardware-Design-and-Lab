`timescale 1ns/1ps

module NAND_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;

wire nandout, andout, orout, norout, xorout, xnorout, notout;
wire nandout2, andout2, orout2, norout2, xorout2, xnorout2, notout2;
wire [3-1:0] _sel;
wire [8-1:0] res, ans, cal;

NOT notsel1(_sel[0], sel[0]);
NOT notsel2(_sel[1], sel[1]);
NOT notsel3(_sel[2], sel[2]);


NAND nand1(nandout, a, b);
AND and1(andout, a, b);
OR or1(orout, a, b);
NOR nor1(norout, a, b);
XOR xor1(xorout, a, b);
XNOR xnor1(xnorout, a, b);
NOT not1(notout, a);

wire nandorand, orornor, xororxor, notornot;
wire [7:0] choose;
wire [3:0] choose2;
wire [1:0] half;
AND and2(choose[0], nandout, _sel[0]);
AND and3(choose[1], andout, sel[0]);
AND and4(choose[2], orout, _sel[0]);
AND and5(choose[3], norout, sel[0]);
AND and6(choose[4], xorout, _sel[0]);
AND and7(choose[5], xnorout, sel[0]);
AND and8(choose[6], notout, _sel[0]);
AND and9(choose[7], notout, sel[0]);

OR or2(nandorand, choose[0], choose[1]);
OR or3(orornor, choose[2], choose[3]);
OR or4(xororxor, choose[4], choose[5]);
OR or5(notornot, choose[6], choose[7]);

AND and10(choose2[0], nandorand, _sel[1]);
AND and11(choose2[1], orornor, sel[1]);
AND and12(choose2[2], xororxor, _sel[1]);
AND and13(choose2[3], notornot, sel[1]);

OR or6(half[0], choose2[0], choose2[1]);
OR or7(half[1], choose2[2], choose2[3]);

wire tmp1, tmp2;
AND and14(tmp1, half[0], _sel[2]);
AND and15(tmp2, half[1], sel[2]);

OR or8(out, tmp1, tmp2);




endmodule

// module NAND(out, a, b);
//     input a, b;
//     output out;
//     nand nand1(out, a, b);
// endmodule

module AND(out, a, b);
input a, b;
output out;
wire nand_out1, nand_out2;

NAND nand1(nand_out1, a, b);
NAND nand2(nand_out2, a, b);
NAND nand3(out, nand_out1, nand_out2);
endmodule

module OR(out, a, b);
input a, b;
output out;

wire a1, a2;
wire b1, b2;


wire nandout1, nandout2;
NAND nand1(nandout1, a, a);
NAND nand2(nandout2, b, b);
NAND nand3(out, nandout1, nandout2);

endmodule

module NOT(out, a);
input a;
output out;

NAND nand1(out, a, a);
endmodule

module NOR(out, a, b);
input a, b;
output out;

wire orout;
OR or1(orout, a, b);
NOT not1(out, orout);

endmodule

module XOR(out, a, b); // a_b or _ab
input a, b;
output out;

wire _a, _b, a_b, _ab;
NOT not1(_a, a);
NOT not2(_b, b);
AND and1(a_b, a, _b);
AND and2(_ab, _a, b);
OR or1(out, a_b, _ab);
endmodule

module XNOR(out, a, b); 
input a, b;
output out;

wire xorout;
XOR xor1(xorout, a, b);
NOT not1(out, xorout);
endmodule