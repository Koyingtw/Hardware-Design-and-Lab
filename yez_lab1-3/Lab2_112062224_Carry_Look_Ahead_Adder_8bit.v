`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [8-1:0] a, b;
input c0;
output [8-1:0] s;
output c8;

wire [3:0] p1, p2, g1, g2;
PGgenerator_4bit pg1(a[3:0], b[3:0], p1, g1);
PGgenerator_4bit pg2(a[7:4], b[7:4], p2, g2);
wire [2:0] c1_3, c5_7;
wire c4;
Carry_Look_Ahead_Adder_4bit CLA_4bit_1(p1, g1, c0, c1_3);
Carry_Look_Ahead_Adder_2bit CLA_2bit(p1, g1, p2, g2, c0, c4, c8);
Carry_Look_Ahead_Adder_4bit CLA_4bit_2(p2, g2, c4, c5_7);

adder add0(a[0], b[0], c0, s[0]);
adder add1(a[1], b[1], c1_3[0], s[1]);
adder add2(a[2], b[2], c1_3[1], s[2]);
adder add3(a[3], b[3], c1_3[2], s[3]);
adder add4(a[4], b[4], c4, s[4]);
adder add5(a[5], b[5], c5_7[0], s[5]);
adder add6(a[6], b[6], c5_7[1], s[6]);
adder add7(a[7], b[7], c5_7[2], s[7]);

endmodule

module Carry_Look_Ahead_Adder_4bit(p, g, c0, c);
input [4-1:0] p, g;
input c0;
output [3-1:0] c;

wire [3-1:0] pc;

AND a0(pc[0], p[0], c0);
OR o0(c[0], g[0], pc[0]);
AND a1(pc[1], p[1], c[0]);
OR o1(c[1], g[1], pc[1]);
AND a2(pc[2], p[2], c[1]);
OR o2(c[2], g[2], pc[2]);

endmodule

module Carry_Look_Ahead_Adder_2bit(p1, g1, p2, g2, c0, c4, c8);
input [4-1:0] p1, g1, p2, g2;
input c0;
output c4, c8;

wire [8-1:0] c, pc;
AND a0(pc[0], p1[0], c0);
OR o0(c[0], g1[0], pc[0]);
AND a1(pc[1], p1[1], c[0]);
OR o1(c[1], g1[1], pc[1]);
AND a2(pc[2], p1[2], c[1]);
OR o2(c[2], g1[2], pc[2]);
AND a3(pc[3], p1[3], c[2]);
OR o3(c4, g1[3], pc[3]);

AND a_0(pc[4], p2[0], c4);
OR o_0(c[4], g2[0], pc[4]);
AND a_1(pc[5], p2[1], c[4]);
OR o_1(c[5], g2[1], pc[5]);
AND a_2(pc[6], p2[2], c[5]);
OR o_2(c[6], g2[2], pc[6]);
AND a_3(pc[7], p2[3], c[6]);
OR o_3(c8, g2[3], pc[7]);

endmodule

module adder(a, b, c, s);
input a, b;
input c;
output s;

wire sum;
XOR x1(sum, a, b);
XOR x2(s, sum, c);

endmodule

module PGgenerator_4bit(a, b, p, g);
input [4-1:0] a, b;
output [4-1:0] p, g;

OR OR_p0(p[0], a[0], b[0]);
OR OR_p1(p[1], a[1], b[1]);
OR OR_p2(p[2], a[2], b[2]);
OR OR_p3(p[3], a[3], b[3]);
AND AND_g0(g[0], a[0], b[0]);
AND AND_g1(g[1], a[1], b[1]);
AND AND_g2(g[2], a[2], b[2]);
AND AND_g3(g[3], a[3], b[3]);

endmodule

module AND(out, a, b);
input a, b;
output out;

wire w1;
nand nand1(w1, a, b);
nand nand2(out, w1, w1);

endmodule

module OR(out, a, b);
input a, b;
output out;

wire w1, w2;
nand nand1(w1, a, a);
nand nand2(w2, b, b);
nand nand3(out, w1, w2);

endmodule

module XOR(out, a, b);
input a, b;
output out;

wire w1, w2, w3, w4;
nand nand1(w1, a, a);
nand nand2(w2, b, b);
nand nand3(w3, w1, b);
nand nand4(w4, a, w2);
nand nand5(out, w3, w4);

endmodule