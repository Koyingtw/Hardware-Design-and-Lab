`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;

wire [3:0] sub_out, add_out, bitOR, bitAND, Rshift, Lshift, cmpLT, cmpEQ;
SUB s(sub_out, rs, rt);
ADD a(add_out, rs, rt);
BITWISE_OR BOR(bitOR, rs, rt);
BITWISE_AND BAND(bitAND, rs, rt);
RT_ARI r(Rshift, rt);
RS_CIR l(Lshift, rs);
COMPARE_LT lt(cmpLT, rs, rt);
COMPARE_EQ eq(cmpEQ, rs, rt);

wire [4-1:0] w0, w1, w2, w3, w4, w5;
Mux_2x1_4bit m0(w0, sub_out, add_out, sel[0]);
Mux_2x1_4bit m1(w1, bitOR, bitAND, sel[0]);
Mux_2x1_4bit m2(w2, Rshift, Lshift, sel[0]);
Mux_2x1_4bit m3(w3, cmpLT, cmpEQ, sel[0]);

Mux_2x1_4bit m4(w4, w0, w1, sel[1]);
Mux_2x1_4bit m5(w5, w2, w3, sel[1]);

Mux_2x1_4bit m6(rd, w4, w5, sel[2]);

endmodule

module Mux_2x1_4bit(out, a, b, sel);
input [4-1:0] a, b;
input sel;
output [4-1:0] out;

wire [4-1:0] w1, w2;
wire _sel;
NOT n1(_sel, sel);

AND and1_0(w1[0], a[0], _sel);
AND and1_1(w1[1], a[1], _sel);
AND and1_2(w1[2], a[2], _sel);
AND and1_3(w1[3], a[3], _sel);
AND and2_0(w2[0], b[0], sel);
AND and2_1(w2[1], b[1], sel);
AND and2_2(w2[2], b[2], sel);
AND and2_3(w2[3], b[3], sel);

BITWISE_OR or0(out, w1, w2);

endmodule

module SUB(out, rs, rt);
input [4-1:0] rs, rt;
output [4-1:0] out;

wire [4-1:0] _rt, w1;

NOT n0(_rt[0], rt[0]);
NOT n1(_rt[1], rt[1]);
NOT n2(_rt[2], rt[2]);
NOT n3(_rt[3], rt[3]);
ADD a1(w1, _rt, 4'b0001);
ADD a2(out, rs, w1);

endmodule

module ADD(out, rs, rt);
input [4-1:0] rs, rt;
output [4-1:0] out;

wire cout;
Ripple_Carry_Adder RCA(rs, rt, 1'b0, cout, out);

endmodule

module BITWISE_OR(rd, rs, rt);
input [4-1:0] rs, rt;
output [4-1:0] rd;

OR OR_0(rd[0], rs[0], rt[0]);
OR OR_1(rd[1], rs[1], rt[1]);
OR OR_2(rd[2], rs[2], rt[2]);
OR OR_3(rd[3], rs[3], rt[3]);

endmodule

module BITWISE_AND(rd, rs, rt);
input [4-1:0] rs, rt;
output [4-1:0] rd;

AND AND_0(rd[0], rs[0], rt[0]);
AND AND_1(rd[1], rs[1], rt[1]);
AND AND_2(rd[2], rs[2], rt[2]);
AND AND_3(rd[3], rs[3], rt[3]);

endmodule

module RT_ARI(rd, rt);
input [4-1:0] rt;
output [4-1:0] rd;

AND AND_0(rd[0], rt[1], 1'b1);
AND AND_1(rd[1], rt[2], 1'b1);
AND AND_2(rd[2], rt[3], 1'b1);
AND AND_3(rd[3], rt[3], 1'b1);

endmodule

module RS_CIR(rd, rs);
input [4-1:0] rs;
output [4-1:0] rd;

AND AND_0(rd[0], rs[3], 1'b1);
AND AND_1(rd[1], rs[0], 1'b1);
AND AND_2(rd[2], rs[1], 1'b1);
AND AND_3(rd[3], rs[2], 1'b1);

endmodule

module COMPARE_LT(rd, rs, rt);
input [4-1:0] rs, rt;
output [4-1:0] rd;

AND rd1(rd[3], 1'b1, 1'b1);
AND rd2(rd[2], 1'b0, 1'b1);
AND rd3(rd[1], 1'b1, 1'b1);

wire [4-1:0] lt, eq;
Universal_Gate lt0(lt[0], rt[0], rs[0]);
Universal_Gate lt1(lt[1], rt[1], rs[1]);
Universal_Gate lt2(lt[2], rt[2], rs[2]);
Universal_Gate lt3(lt[3], rt[3], rs[3]);
COMPARE_EQ_1bit eq0(eq[0], rs[0], rt[0]);
COMPARE_EQ_1bit eq1(eq[1], rs[1], rt[1]);
COMPARE_EQ_1bit eq2(eq[2], rs[2], rt[2]);

wire w1, w2, w3;
AND and_0(rd[0], lt[0], 1'b1);
AND and2_0(w1, lt[1], eq[0]);
OR or_0(rd[0], rd[0], w1);
AND and2_1(w2, lt[2], eq[1]);
OR or_1(rd[0], rd[0], w2);
AND and2_2(w3, lt[3], eq[2]);
OR or_2(rd[0], rd[0], w3);

endmodule

module COMPARE_EQ(rd, rs, rt);
input [4-1:0] rs, rt;
output [4-1:0] rd;

AND rd1(rd[3], 1'b1, 1'b1);
AND rd2(rd[2], 1'b1, 1'b1);
AND rd3(rd[1], 1'b1, 1'b1);

wire [4-1:0] eq;
wire w1, w2;

COMPARE_EQ_1bit eq0(eq[0], rs[0], rt[0]);
COMPARE_EQ_1bit eq1(eq[1], rs[1], rt[1]);
COMPARE_EQ_1bit eq2(eq[2], rs[2], rt[2]);
COMPARE_EQ_1bit eq3(eq[3], rs[3], rt[3]);

AND a1(w1, eq[0], eq[1]);
AND a2(w2, w1, eq[2]);
AND a3(rd[0], w2, eq[3]);

endmodule

module COMPARE_EQ_1bit(out, a, b);
input a, b;
output out;

wire w1;
XOR x1(w1, a, b);
NOT n1(out, w1);

endmodule

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [4-1:0] a, b;
input cin;
output cout;
output [4-1:0] sum;

wire [3-1:0] c;

Full_Adder f0(a[0], b[0], cin, c[0], sum[0]);
Full_Adder f1(a[1], b[1], c[0], c[1], sum[1]);
Full_Adder f2(a[2], b[2], c[1], c[2], sum[2]);
Full_Adder f3(a[3], b[3], c[2], cout, sum[3]);

endmodule

module Full_Adder(a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire s, ab, bc, ac, w1;
XOR x1(s, a, b);
XOR x2(sum, cin, s);

AND a1(ab, a, b);
AND a2(ac, a, c);
AND a3(bc, b, c);
OR o1(w1, ab, ac);
OR o2(out, w1, bc);

endmodule

module AND(out, a, b);
input a, b;
output out;

wire _b;
NOT n1(_b, b);
Universal_Gate u1(out, a, _b);

endmodule

module OR(out, a, b);
input a, b;
output out;

wire _a, _b, a_b, _ab, w1;
NOT n1(_a, a);
NOT n2(_b, b);
Universal_Gate u1(a_b, a, _b);
Universal_Gate u2(w1, 1'b1, a_b);
Universal_Gate u3(_ab, _a, b);
Universal_Gate u4(out, w1, _ab);

endmodule

module NOT(out, a);
input a;
output out;
Universal_Gate u1(out, 1'b1, a);

endmodule

module XOR(out, a, b);
input a, b;
output out;

wire _a, _b, a_b, _ab;
NOT n1(_a, a);
NOT n2(_b, b);
AND a1(a_b, a, _b);
AND a2(_ab, _a, b);
OR o1(out, a_b, _ab);

endmodule

module Universal_Gate(out, a, b);
input a, b;
output out;

wire _b;
not n1(_b, b);
and a1(out, a, _b);

endmodule