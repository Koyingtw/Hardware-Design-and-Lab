`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter_t;

reg clk, rst_n, enable;
reg flip;
reg [4-1:0] max;
reg [4-1:0] min;

wire direction;
wire [4-1:0] out;


reg started = 0;

Parameterized_Ping_Pong_Counter PPC(clk, rst_n, enable, flip, max, min, direction, out);


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
    enable = 1;
    started = 1;
    min = 0;
    max = 4;
    flip = 0;
    #8


    repeat(3) begin
        #2;
        $display("min: %d, max: %d", min, max);
        $display("out: %d, direction: %d", out, direction);
    end

    flip = 1;
    #2
    flip = 0;
    repeat(3) begin
        #2;
        $display("min: %d, max: %d", min, max);
        $display("out: %d, direction: %d", out, direction);
    end

    flip = 1;
    #2
    flip = 0;

    repeat(3) begin
        #2;
        $display("min: %d, max: %d", min, max);
        $display("out: %d, direction: %d", out, direction);
    end

    // repeat (2**8) begin
    //     #5;
    //     enable = enable ^ 1;
    // end

    max = 10;
    repeat(20) begin
        #2;
        $display("min: %d, max: %d", min, max);
        $display("out: %d, direction: %d", out, direction);
    end
    
    min = out;
    max = out;

    repeat(5) begin
        #2;
        $display("min: %d, max: %d", min, max);
        $display("out: %d, direction: %d", out, direction);
    end

    $finish;
end

endmodule
