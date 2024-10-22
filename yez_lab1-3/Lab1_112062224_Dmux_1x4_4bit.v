`timescale 1ns/1ps

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [4-1:0] in;
input [2-1:0] sel;
output [4-1:0] a, b, c, d;

wire [4-1:0] ab, cd;
Dmux_1x2_4bit M1(in, ab, cd, sel[1]);
Dmux_1x2_4bit M2(ab, a, b, sel[0]);
Dmux_1x2_4bit M3(cd, c, d, sel[0]);

endmodule

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;

wire _sel;

not(_sel, sel);
and a1(a[0], in[0], _sel);
and a2(a[1], in[1], _sel);
and a3(a[2], in[2], _sel);
and a4(a[3], in[3], _sel);

and b1(b[0], in[0], sel);
and b2(b[1], in[1], sel);
and b3(b[2], in[2], sel);
and b4(b[3], in[3], sel);

endmodule