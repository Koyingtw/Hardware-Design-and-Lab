`timescale 1ns/1ps

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [4-1:0] in;
input [2-1:0] sel;
output [4-1:0] a, b, c, d;

wire [4-1:0] ab, cd;
Dmux_1x2_4bit Dmux1(in, ab, cd, sel[1]);
Dmux_1x2_4bit Dmux2(ab, a, b, sel[0]);
Dmux_1x2_4bit Dmux3(cd, c, d, sel[0]);

endmodule

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input [1-1:0] sel;
output [4-1:0] a, b;

and and1(a[0], in[0], ~sel[0]);
and and2(a[1], in[1], ~sel[0]);
and and3(a[2], in[2], ~sel[0]);
and and4(a[3], in[3], ~sel[0]);

and and5(b[0], in[0], sel[0]);
and and6(b[1], in[1], sel[0]);
and and7(b[2], in[2], sel[0]);
and and8(b[3], in[3], sel[0]);


endmodule
