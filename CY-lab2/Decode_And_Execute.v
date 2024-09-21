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
LSHIFT lshift1(lshift, rs);
CLT lt1(lt, rs, rt);
CEQ eq1(eq, rs, rt);
// assign sub = 4'b0000;
// assign add = 4'b0001;
// assign bitor = 4'b0010;
// assign bitand = 4'b0011;
// assign rshift = 4'b0100;
// assign lshift = 4'b0101;
// assign lt = 4'b0110;
// assign eq = 4'b0111;


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
AND and4(out[3], a[0], 1'b1);
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