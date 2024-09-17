`timescale 1ns/1ps

module Mux_4x1_4bit(a, b, c, d, sel, f);
input [4-1:0] a, b, c, d;
input [2-1:0] sel;
output [4-1:0] f;

wire [4-1:0] f1, f2;

Mux_2x1_4bit m1(a, b, f1, sel[0]);
Mux_2x1_4bit m2(c, d, f2, sel[0]);
Mux_2x1_4bit m3(f1, f2, f, sel[1]);

endmodule

module Mux_2x1_4bit(a, b, f, sel);
input [4-1:0] a, b;
output [4-1:0] f;
input sel;

wire [4-1:0] aa, bb;
wire _sel;
not(_sel, sel);

and g1(aa[0], a[0], _sel);
and g2(aa[1], a[1], _sel);
and g3(aa[2], a[2], _sel);
and g4(aa[3], a[3], _sel);

and g5(bb[0], b[0], sel);
and g6(bb[1], b[1], sel);
and g7(bb[2], b[2], sel);
and g8(bb[3], b[3], sel);

or g9(f[0], aa[0], bb[0]);
or g10(f[1], aa[1], bb[1]);
or g11(f[2], aa[2], bb[2]);
or g12(f[3], aa[3], bb[3]);

endmodule
