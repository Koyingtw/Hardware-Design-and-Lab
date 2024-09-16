`timescale 1ns/1ps

module Crossbar_2x2_4bit_fpga(in1, in2, control, out1, out2, out11, out22);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2, out11, out22;

wire [4-1:0] d1out1, d1out2, d2out1, d2out2, d3out1, d3out2, d4out1, d4out2;
wire _control;

not not1(_control, control);

Dmux_1x2_4bit Dmux1(in1, d1out1, d1out2, control);
Dmux_1x2_4bit Dmux2(in2, d2out1, d2out2, _control);
Mux_2x1_4bit Mux1(d1out1, d2out1, out1, control);
Mux_2x1_4bit Mux2(d1out2, d2out2, out2, _control);

and and1(out11[0], out1[0], 4'b1);
and and2(out11[1], out1[1], 4'b1);
and and3(out11[2], out1[2], 4'b1);
and and4(out11[3], out1[3], 4'b1);

and and5(out22[0], out2[0], 4'b1);
and and6(out22[1], out2[1], 4'b1);
and and7(out22[2], out2[2], 4'b1);
and and8(out22[3], out2[3], 4'b1);



endmodule
