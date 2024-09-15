`timescale 1ns/1ps

module Toggle_Flip_Flop_t;
reg clk = 1'b0;
reg t = 1'b0;
reg rst_n = 1'b0;
reg [1:0] state = 2'b00;

Toggle_Flip_Flop TFF(clk, q, t, rst_n);
wire q;

always begin
    #2 clk = ~clk;
end

// reg x;
// wire xx;
// and a1(xx, x, 0);
// $display("X and 0", xx);

initial begin;
    #3
    repeat (4**2) begin
        #3 state = state + 2'b1;
        t = state[0];
        rst_n = state[1];
    end
    #3 $finish;
end
endmodule
