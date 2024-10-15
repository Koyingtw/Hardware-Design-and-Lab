`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;

wire [4-1:0] d1out1, d1out2, d2out1, d2out2, d3out1, d3out2, d4out1, d4out2;
wire _control;

not not1(_control, control);

Dmux_1x2_4bit Dmux1(in1, d1out1, d1out2, control);
Dmux_1x2_4bit Dmux2(in2, d2out1, d2out2, _control);
Mux_2x1_4bit Mux1(d1out1, d2out1, out1, control);
Mux_2x1_4bit Mux2(d1out2, d2out2, out2, _control);


endmodule

module Dmux_1x2_4bit(in, a, b, sel);
input [4-1:0] in;
input sel;
output [4-1:0] a, b;
wire _sel;
not not1(_sel, sel);

and and1(a[0], in[0], _sel);
and and2(a[1], in[1], _sel);
and and3(a[2], in[2], _sel);
and and4(a[3], in[3], _sel);

and and5(b[0], in[0], sel);
and and6(b[1], in[1], sel);
and and7(b[2], in[2], sel);
and and8(b[3], in[3], sel);


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

