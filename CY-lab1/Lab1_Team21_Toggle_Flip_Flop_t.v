`timescale 1ns/1ps

module Toggle_Flip_Flop_t;
reg clk = 1'b0;
reg t = 1'b0;
reg rst_n = 1'b0;
wire q;

Toggle_Flip_Flop TFF(clk, q, t, rst_n);

always begin
    #2 clk = ~clk;
end

// reg x;
// wire xx;
// and a1(xx, x, 0);
// $display("X and 0", xx);

always begin
    #3 t = ~t;
end

initial begin
    repeat (4**2) begin
        #5 rst_n = ~rst_n;
    end
    #3 $finish;
end

always @(posedge clk) begin
    #0.5 $display("t = %d, rst_n = %d, q = %d", t, rst_n, q);
end
endmodule
