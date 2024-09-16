`timescale 1ns/1ps

module Dmux_1x4_4bit_t;

reg [3:0] in = 4'b0001;
reg [1:0] sel = 2'b00;
wire [3:0] a, b, c, d;

Dmux_1x4_4bit Dmux1(.in(in), .a(a), .b(b), .c(c), .d(d), .sel(sel));

initial begin
    repeat (2**3) begin
        $display("sel = %d, output = %d %d %d %d", sel, a, b, c, d);
        #1 in = in + 4'b1;
        sel = sel + 2'b1;
    end
    #1 $finish;
end

endmodule
