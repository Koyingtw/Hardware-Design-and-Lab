`timescale 1ns/1ps

module Ping_Pong_Counter_t;

reg clk, rst_n, enable;
wire direction;
wire [4-1:0] out;

reg started = 0;

Ping_Pong_Counter PPC(clk, rst_n, enable, direction, out);

always begin
    #1 clk = ~clk;
end

initial begin
    #4 rst_n = 0;
    #4 rst_n = 1;
end

initial begin
    clk = 0;
    rst_n = 1;
    enable = 0;
    started = 1;
    #2
    repeat (2**8) begin
        #5;
        enable = enable ^ 1;
    end
    $finish;
end

endmodule
