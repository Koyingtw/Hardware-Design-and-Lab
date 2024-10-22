`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [4-1:0] in1, in2, in3, in4;
input [5-1:0] control;
output [4-1:0] out1, out2, out3, out4;

wire [4-1:0] c1_1, c1_2, c2_1, c2_2, c3_1, c3_2;

Crossbar_2x2_4bit C0(in1, in2, control[0], c1_1, c1_2);
Crossbar_2x2_4bit C3(in3, in4, control[3], c3_1, c3_2);
Crossbar_2x2_4bit C2(c1_2, c3_1, control[2], c2_1, c2_2);
Crossbar_2x2_4bit C1(c1_1, c2_1, control[1], out1, out2);
Crossbar_2x2_4bit C4(c2_2, c3_2, control[4], out3, out4);

endmodule

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;

wire [4-1:0] w1, w2, w3, w4;
wire _control;
not NOT(_control, control);
Dmux_1x2_4bit DMUX1(in1, w1, w2, control);
Dmux_1x2_4bit DMUX2(in2, w3, w4, _control);
Mux_2x1_4bit MUX1(w1, w3, control, out1);
Mux_2x1_4bit MUX2(w2, w4, _control, out2);

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

module Mux_2x1_4bit(a, b, sel, f);
    input [4-1:0] a, b;
    input sel;
    output [4-1:0] f;

    wire [4-1:0] w1, w2;
    wire _sel;
    not(_sel, sel);
    
    and(w1[0], a[0], _sel);
    and(w1[1], a[1], _sel);
    and(w1[2], a[2], _sel);
    and(w1[3], a[3], _sel);

    and(w2[0], b[0], sel);
    and(w2[1], b[1], sel);
    and(w2[2], b[2], sel);
    and(w2[3], b[3], sel);

    or(f[0], w1[0], w2[0]);
    or(f[1], w1[1], w2[1]);
    or(f[2], w1[2], w2[2]);
    or(f[3], w1[3], w2[3]);

endmodule