`timescale 1ns/1ps
`include "Built_In_Self_Test_fpga.v"

module Display_Control_t;
reg clk, UP, RIGHT, scan_en;
reg [8-1:0] LFSR_v;
wire [4-1:0] an;
wire [7-1:0] seg_out;
wire [8-1:0] Q;

Display_Control dut (
    .clk(clk),
    .UP(UP),
    .RIGHT(RIGHT),
    .scan_en(scan_en),
    .LFSR_v(LFSR_v),
    .an(an),
    .seg_out(seg_out),
    .Q(Q)
);

always begin
    #5 clk = ~clk;
end

reg [3:0] cnt;

initial begin
    $dumpfile("Display_Control_t.vcd");
    $dumpvars(0, Display_Control_t);
    clk = 0;
    UP = 0;
    RIGHT = 0;
    scan_en = 0;
    LFSR_v = 8'b10111101;  
    #100;
    UP = 1;
    #100;
    UP = 0;
    repeat(20) begin
        #10;
        cnt = {$random} % 4;
        scan_en = (cnt != 0);
        RIGHT = 1;
        #100;
        RIGHT = 0;
    end
    $finish;
end


endmodule