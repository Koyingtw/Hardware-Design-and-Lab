`timescale 1ns/1ps

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
LSHIFT lshift1(lshift, rt);
LT lt1(lt, rs, rt);
EQ eq1(eq, rs, rt);

wire [3-1:0] _sel;
NOT3b notsel(_sel, sel);

wire [8-1:0][4-1:0] choose;
AND4x1 and1(choose[0], sub, _sel[0]);
AND4x1 and2(choose[1], add, sel[0]);
AND4x1 and3(choose[2], bitor, _sel[0]);
AND4x1 and4(choose[3], bitand, sel[0]);
AND4x1 and5(choose[4], rshift, _sel[0]);
AND4x1 and6(choose[5], lshift, sel[0]);
AND4x1 and7(choose[6], lt, _sel[0]);
AND4x1 and8(choose[7], eq, sel[0]);

wire [4-1:0][4-1:0] stage2;

BITOR bor1(stage2[0], choose[0], choose[1]);
BITOR bor2(stage2[1], choose[2], choose[3]);
BITOR bor3(stage2[2], choose[4], choose[5]);
BITOR bor4(stage2[3], choose[6], choose[7]);

wire [4-1:0][4-1:0] choose2;
AND4x1 and9(choose2[0], stage2[0], _sel[1]);
AND4x1 and10(choose[1], stage2[0], sel[1]);
AND4x1 and11(choose2[2], stage2[1], _sel[1]);
AND4x1 and12(choose[3], stage2[1], sel[1]);

wire [2-1:0][4-1:0] stage3;
BITOR bor5(stage3[0], choose2[0], choose2[1]);
BITOR bor6(stage3[1], choose2[2], choose2[3]);

wire [2-1:0][4-1:0] choose3;
AND4x1 and13(choose3[0], stage3[0], _sel[2]);
AND4x1 and14(choose3[1], stage3[0], sel[2]);

BITOR bor7(rd, choose3[0], choose3[1]);


endmodule

module SUB(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

wire SUB, gnd;
wire [4-1:0] neg_rt;
NOT not1(neg_rt[0], rt[0]);
NOT not2(neg_rt[1], rt[1]);
NOT not3(neg_rt[2], rt[2]);
NOT not4(neg_rt[3], rt[3]);

Full_Adder fasub(
    .a(rs),
    .b(neg_rt),
    .cin(1'b1),
    .cout(gnd),
    .sum(out)
);
endmodule

module ADD(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;
wire gnd;

Full_Adder fa(
    .a(a),
    .b(b),
    .cin(1'b0),
    .cout(gnd),
    .sum(out[3:0])
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
AND and4(out[3], 1'b0, 1'b1);
endmodule

module LSHIFT(out, a);
input [4-1:0] a;
output [4-1:0] out;

AND and1(out[0], 1'b0, 1'b1);
AND and2(out[1], a[0], 1'b1);
AND and3(out[2], a[1], 1'b1);
AND and4(out[3], a[2], 1'b1);
endmodule

module LT(out, a, b);
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

wire [4-1:0] LT;
AND and4(LT[0], _a[0], b[0]);
AND and5(LT[1], _a[1], b[1]);
AND and6(LT[2], _a[2], b[2]);
AND and7(LT[3], _a[3], b[3]);

// LT[3] or (LT[2] and _LT[3]) or (LT[1] and _LT[2] and _LT[3]) 
// or (LT[0] and _LT[1] and _LT[2] and _LT[3])

wire [4-1:0] _LT;
NOT not9(_LT[0], LT[0]);
NOT not10(_LT[1], LT[1]);
NOT not11(_LT[2], LT[2]);
NOT not12(_LT[3], LT[3]);

wire [4-1:0] res;
AND and8(res[0], LT[3], 1'b1);

wire LT2_LT3;
AND and9(LT2_LT3, LT[2], _LT[3]);
OR or1(res[1], LT2_LT3, res[0]);

wire LT1_LT2, LT1_LT2_LT3;
AND and10(LT1_LT2, LT[1], _LT[2]);
AND and11(LT1_LT2_LT3, LT1_LT2, _LT[3]);
OR or2(res[2], LT1_LT2_LT3, res[1]);

wire LT0_LT1, LT0_LT1_LT2, LT0_LT1_LT2_LT3;
AND and12(LT0_LT1, LT[0], _LT[1]);
AND and13(LT0_LT1_LT2, LT0_LT1, _LT[2]);
AND and14(LT0_LT1_LT2_LT3, LT0_LT1_LT2, _LT[3]);
OR or3(out[0], LT0_LT1_LT2_LT3, res[2]);


endmodule

module EQ(out, a, b);
input [4-1:0] a, b;
output [4-1:0] out;

AND and1(out[3], 1'b1, 1'b1);
AND and2(out[2], 1'b1, 1'b1);
AND and3(out[1], 1'b1, 1'b1);

wire EQ [3:0];
wire [4-1:0] _a, _b;
NOT not1(_a[0], a[0]);
NOT not2(_a[1], a[1]);
NOT not3(_a[2], a[2]);
NOT not4(_a[3], a[3]);

NOT not5(_b[0], b[0]);
NOT not6(_b[1], b[1]);
NOT not7(_b[2], b[2]);
NOT not8(_b[3], b[3]);

wire [4-1:0] ab, _a_b;
AND and4(ab[0], a[0], b[0]);
AND and5(ab[1], a[1], b[1]);
AND and6(ab[2], a[2], b[2]);
AND and7(ab[3], a[3], b[3]);

AND and8(_a_b[0], _a[0], _b[0]);
AND and9(_a_b[1], _a[1], _b[1]);
AND and10(_a_b[2], _a[2], _b[2]);
AND and11(_a_b[3], _a[3], _b[3]);

AND and12(EQ[0], ab[0], _a_b[0]);
AND and13(EQ[1], ab[1], _a_b[1]);
AND and14(EQ[2], ab[2], _a_b[2]);
AND and15(EQ[3], ab[3], _a_b[3]);

wire res[2:0];
OR or1(res[0], EQ[0], EQ[1]);
OR or2(res[1], res[0], EQ[2]);
OR or3(out[0], res[1], EQ[3]);

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

module NOT3(out, a);
input [4-1:0] a;
output [4-1:0] out;

NOT not1(out[0], a[0]);
NOT not2(out[1], a[1]);
NOT not3(out[2], a[2]);
endmodule