`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [4-1:0] in1, in2, in3, in4;
input [5-1:0] control;
output [4-1:0] out1, out2, out3, out4;

wire [4-1:0] c1out1, c1out2, c2out1, c2out2, c3out1, c3out2, c4out1, c4out2, c5out1, c5out2;

Crossbar_2x2_4bit Crossbar1(in1, in2, control[0], c1out1, c1out2);
Crossbar_2x2_4bit Crossbar2(in3, in4, control[3], c2out1, c2out2);
Crossbar_2x2_4bit Crossbar3(c1out2, c2out1, control[2], c3out1, c3out2);
Crossbar_2x2_4bit Crossbar4(c1out1, c3out1, control[1], out1, out2);
Crossbar_2x2_4bit Crossbar5(c3out2, c2out2, control[4], out3, out4);


endmodule
