`timescale 1ns/1ps

module Crossbar_2x2_4bit_fpga_t;

reg [4-1:0] in1 = 4'b0000;
reg [4-1:0] in2 = 4'b0010;
reg control = 1'b0;
wire [4-1:0] out1, out2, out11, out22;

Crossbar_2x2_4bit_fpga Crossbar(in1, in2, control, out1, out2, out11, out22);

initial begin
    repeat (2 ** 3) begin
        #1 $display("control = %d, output = %d %d %d %d", control, out1, out2, out11, out22);
        #1 control = ~control;
        in1 = in1 + 4'b1;
        in2 = in2 + 4'b1;
    end
    #1 $finish;
end
endmodule