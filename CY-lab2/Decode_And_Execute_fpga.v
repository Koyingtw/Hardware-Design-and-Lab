`timescale 1ns/1ps

module Display_Control(rs, rt, sel, seg, an);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [7-1:0] seg;
output [4-1:0] an;
wire [4-1:0] rd, _rd;
wire [16-1:0] num, _num;

and an1(an[0], 1'b0, 1'b0);
and an2(an[1], 1'b1, 1'b1);
and an3(an[2], 1'b1, 1'b1);
and an4(an[3], 1'b1, 1'b1);

Decode_And_Execute de(rs, rt, sel, rd);

not not1(_rd[0], rd[0]);
not not2(_rd[1], rd[1]);
not not3(_rd[2], rd[2]);
not not4(_rd[3], rd[3]);

and and1(num[0], _rd[3], _rd[2], _rd[1], _rd[0]);
and and2(num[1], _rd[3], _rd[2], _rd[1], rd[0]);
and and3(num[2], _rd[3], _rd[2], rd[1], _rd[0]);
and and4(num[3], _rd[3], _rd[2], rd[1], rd[0]);
and and5(num[4], _rd[3], rd[2], _rd[1], _rd[0]);
and and6(num[5], _rd[3], rd[2], _rd[1], rd[0]);
and and7(num[6], _rd[3], rd[2], rd[1], _rd[0]);
and and8(num[7], _rd[3], rd[2], rd[1], rd[0]);
and and9(num[8], rd[3], _rd[2], _rd[1], _rd[0]);
and and10(num[9], rd[3], _rd[2], _rd[1], rd[0]);
and and11(num[10], rd[3], _rd[2], rd[1], _rd[0]);
and and12(num[11], rd[3], _rd[2], rd[1], rd[0]);
and and13(num[12], rd[3], rd[2], _rd[1], _rd[0]);
and and14(num[13], rd[3], rd[2], _rd[1], rd[0]);
and and15(num[14], rd[3], rd[2], rd[1], _rd[0]);
and and16(num[15], rd[3], rd[2], rd[1], rd[0]);

not not5(_num[0], num[0]);
not not6(_num[1], num[1]);
not not7(_num[2], num[2]);
not not8(_num[3], num[3]);
not not9(_num[4], num[4]);
not not10(_num[5], num[5]);
not not11(_num[6], num[6]);
not not12(_num[7], num[7]);
not not13(_num[8], num[8]);
not not14(_num[9], num[9]);
not not15(_num[10], num[10]);
not not16(_num[11], num[11]);
not not17(_num[12], num[12]);
not not18(_num[13], num[13]);
not not19(_num[14], num[14]);
not not20(_num[15], num[15]);


SymbolA SA(num, _num, seg[0]);
SymbolB SB(num, _num, seg[1]);
SymbolC SC(num, _num, seg[2]);
SymbolD SD(num, _num, seg[3]);
SymbolE SE(num, _num, seg[4]);
SymbolF SF(num, _num, seg[5]);
SymbolG SG(num, _num, seg[6]);
endmodule

module SymbolA(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[2], num[3],
        num[5], num[6], num[7], num[8], num[9], num[10],
        num[12] , num[14], num[15]);
endmodule

module SymbolB(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[1], num[2], num[3], num[4],
        num[7], num[8], num[9], num[10],
        num[13]);
endmodule

module SymbolC(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[1], num[3], num[4],
        num[5], num[6], num[7], num[8], num[9], num[10],
        num[11], num[13]);
endmodule

module SymbolD(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[2], num[3], 
        num[5], num[6], num[8],
        num[11], num[12], num[13], num[14]);
endmodule

module SymbolE(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[2],
        num[6], num[8], num[10],
        num[11], num[12], num[13], num[14], num[15]);
endmodule

module SymbolF(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[4],
        num[5], num[6], num[8], num[9], num[10],
        num[11], num[12], num[14], num[15]);
endmodule

module SymbolG(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[2], num[3], num[4],
        num[5], num[6], num[8], num[9], num[10],
        num[11], num[13], num[14], num[15]);
endmodule

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;

wire [4-1:0] sub, add, bitor, bitand, rshift, lshift, lt, eq;
SUB sub1(sub, rs, rt);
ADD add1(add, rs, rt);
BITOR bitor1(bitor, rs, rt);
BITAND bitand1(bitand, rs, rt);
RSHIFT rshift1(rshift, rt);
LSHIFT lshift1(lshift, rs);
CLT lt1(lt, rs, rt);
CEQ eq1(eq, rs, rt);


wire [3-1:0] _sel;
NOT3b notsel(_sel, sel);

wire [4-1:0] choose0, choose1, choose2, choose3, choose4, choose5, choose6, choose7;
AND4x1 and1(choose0, sub, _sel[0]);
AND4x1 and2(choose1, add, sel[0]);
AND4x1 and3(choose2, bitor, _sel[0]);
AND4x1 and4(choose3, bitand, sel[0]);
AND4x1 and5(choose4, rshift, _sel[0]);
AND4x1 and6(choose5, lshift, sel[0]);
AND4x1 and7(choose6, lt, _sel[0]);
AND4x1 and8(choose7, eq, sel[0]);

wire [4-1:0] stage20, stage21, stage22, stage23;

BITOR bor1(stage20, choose0, choose1);
BITOR bor2(stage21, choose2, choose3);
BITOR bor3(stage22, choose4, choose5);
BITOR bor4(stage23, choose6, choose7);

wire [4-1:0] choose20, choose21, choose22, choose23;
AND4x1 and9(choose20, stage20, _sel[1]);
AND4x1 and10(choose21, stage21, sel[1]);
AND4x1 and11(choose22, stage22, _sel[1]);
AND4x1 and12(choose23, stage23, sel[1]);

wire [4-1:0] stage30, stage31;
BITOR bor5(stage30, choose20, choose21);
BITOR bor6(stage31, choose22, choose23);

wire [4-1:0] choose30, choose31;
AND4x1 and13(choose30, stage30, _sel[2]);
AND4x1 and14(choose31, stage31, sel[2]);

BITOR bor7(rd, choose30, choose31);


endmodule

module SUB(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

wire SUB, gnd;
wire [4-1:0] neg_b;
NOT not1(neg_b[0], b[0]);
NOT not2(neg_b[1], b[1]);
NOT not3(neg_b[2], b[2]);
NOT not4(neg_b[3], b[3]);

Ripple_Carry_Adder_4bit RCAsub(
    .a(a),
    .b(neg_b),
    .cin(1'b1),
    .cout(gnd),
    .sum(out)
);
endmodule

module ADD(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;
wire gnd;

Ripple_Carry_Adder_4bit RCA(
    .a(a),
    .b(b),
    .cin(1'b0),
    .cout(gnd),
    .sum(out)
);
endmodule

module BITOR(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

OR or1(out[0], a[0], b[0]);
OR or2(out[1], a[1], b[1]);
OR or3(out[2], a[2], b[2]);
OR or4(out[3], a[3], b[3]);
endmodule

module BITAND(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

AND and1(out[0], a[0], b[0]);
AND and2(out[1], a[1], b[1]);
AND and3(out[2], a[2], b[2]);
AND and4(out[3], a[3], b[3]);
endmodule

module RSHIFT(out, a);
input [4-1:0] a;
output [4-1:0] out;

AND and1(out[0], a[1], 1'b1);
AND and2(out[1], a[2], 1'b1);
AND and3(out[2], a[3], 1'b1);
AND and4(out[3], a[3], 1'b1);
endmodule

module LSHIFT(out, a);
input [4-1:0] a;
output [4-1:0] out;

AND and1(out[0], a[3], 1'b1);
AND and2(out[1], a[0], 1'b1);
AND and3(out[2], a[1], 1'b1);
AND and4(out[3], a[2], 1'b1);
endmodule

module CLT(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

AND and1(out[3], 1'b1, 1'b1);
AND and2(out[2], 1'b0, 1'b1);
AND and3(out[1], 1'b1, 1'b1);

wire [4-1:0] _a, _b;
NOT not1(_a[0], a[0]);
NOT not2(_a[1], a[1]);
NOT not3(_a[2], a[2]);
NOT not4(_a[3], a[3]);

NOT not5(_b[0], b[0]);
NOT not6(_b[1], b[1]);
NOT not7(_b[2], b[2]);
NOT not8(_b[3], b[3]);

wire [4-1:0] EQ, preEQ;

BITEQ eq1(EQ, a, b);

AND andpreEQ0(preEQ[3], EQ[3], 1'b1);
AND andpreEQ1(preEQ[2], EQ[2], EQ[3]);
AND andpreEQ2(preEQ[1], EQ[1], preEQ[2]);
AND andpreEQ3(preEQ[0], EQ[0], preEQ[1]);

wire [4-1:0] LT;
AND and4(LT[0], _a[0], b[0]);
AND and5(LT[1], _a[1], b[1]);
AND and6(LT[2], _a[2], b[2]);
AND and7(LT[3], _a[3], b[3]);

// LT[3] or (LT[2] and preEQ[3]) or (LT[1] and preEQ[2]) 
// or (LT[0] and preEQ[1])

wire [4-1:0] res;
AND and8(res[0], LT[3], 1'b1);

wire LT2EQ3;
AND and9(LT2EQ3, LT[2], EQ[3]);
OR or1(res[1], LT2EQ3, res[0]);

wire LT1preEQ2;
AND and10(LT1preEQ2, LT[1], preEQ[2]);
OR or2(res[2], LT1preEQ2, res[1]);

wire LT0preEQ1;
AND and12(LT0preEQ1, LT[0], preEQ[1]);
OR or3(out[0], LT0preEQ1, res[2]);


endmodule

module CEQ(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

AND and1(out[3], 1'b1, 1'b1);
AND and2(out[2], 1'b1, 1'b1);
AND and3(out[1], 1'b1, 1'b1);

wire [4-1:0] EQ;

BITEQ eq1(EQ, a, b);

wire res[2:0];
AND and4(res[0], EQ[0], EQ[1]);
AND and5(res[1], EQ[2], res[0]);
AND and6(out[0], EQ[3], res[1]);

endmodule

module BITEQ(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

wire [4-1:0] AB, _A_B, _a, _b;

NOT not1(_a[0], a[0]);
NOT not2(_a[1], a[1]);
NOT not3(_a[2], a[2]);
NOT not4(_a[3], a[3]);

NOT not5(_b[0], b[0]);
NOT not6(_b[1], b[1]);
NOT not7(_b[2], b[2]);
NOT not8(_b[3], b[3]);

AND and1(AB[0], a[0], b[0]);
AND and2(AB[1], a[1], b[1]);
AND and3(AB[2], a[2], b[2]);
AND and4(AB[3], a[3], b[3]);

AND and5(_A_B[0], _a[0], _b[0]);
AND and6(_A_B[1], _a[1], _b[1]);
AND and7(_A_B[2], _a[2], _b[2]);
AND and8(_A_B[3], _a[3], _b[3]);

OR or1(out[0], AB[0], _A_B[0]);
OR or2(out[1], AB[1], _A_B[1]);
OR or3(out[2], AB[2], _A_B[2]);
OR or4(out[3], AB[3], _A_B[3]);
endmodule

module AND4x1(out, a, b);
input [4-1:0] a;
input b;
output [4-1:0] out;

AND and1(out[0], a[0], b);
AND and2(out[1], a[1], b);
AND and3(out[2], a[2], b);
AND and4(out[3], a[3], b);
endmodule

module NOT3b(out, a);
input [3-1:0] a;
output [3-1:0] out;

NOT not1(out[0], a[0]);
NOT not2(out[1], a[1]);
NOT not3(out[2], a[2]);
endmodule

module NAND(out, a, b);
    input a, b;
    output out;
    nand nand1(out, a, b);
endmodule

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

module Ripple_Carry_Adder_4bit(a, b, cin, cout, sum);
input [4-1:0] a, b;
input cin;
output cout;
output [4-1:0] sum;

wire [3:0] C;

Full_Adder fa0(a[0], b[0], cin, C[0], sum[0]);
Full_Adder fa1(a[1], b[1], C[0], C[1], sum[1]);
Full_Adder fa2(a[2], b[2], C[1], C[2], sum[2]);
Full_Adder fa3(a[3], b[3], C[2], cout, sum[3]);
endmodule

module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire sum1, sum2;
    wire car1;
    XOR xor1(sum1, a, b);
    XOR xor2(sum, sum1, cin);
    Majority maj1(a, b, cin, cout);
endmodule


module Majority(a, b, c, out);
input a, b, c;
output out;

wire and1out, and2out, and3out;
AND and1(and1out, a, b);
AND and2(and2out, a, c);
AND and3(and3out, b, c);

wire or1out;
OR or1(or1out, and1out, and2out);
OR or2(out, or1out, and3out);

endmodule