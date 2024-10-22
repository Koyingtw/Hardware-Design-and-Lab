`timescale 1ns/1ps
`include "Scan_Chain_Design.v"
module Scan_Chain_Design_t;
reg clk;
reg rst_n;
reg scan_in;
reg scan_en;
wire scan_out;

parameter clock = 10;

reg [4-1:0] a = 3, b = 7;
reg [8-1:0] p;

Scan_Chain_Design dut (
    .clk(clk),
    .rst_n(rst_n),
    .scan_in(scan_in),
    .scan_en(scan_en),
    .scan_out(scan_out)
);

always begin
    #5 clk = ~clk;
end

always @(posedge clk) begin
    #0.1;
    if (rst_n && scan_en) begin
        p <= (p >> 1);
        p[7] <= scan_out;
    end
end

initial begin
    $dumpfile("Scan_Chain_Design_t.vcd");
    $dumpvars(0, Scan_Chain_Design_t);

    clk = 1;
    rst_n = 0;
    scan_in = 0;
    scan_en = 0;
    #15;

    repeat(1) begin
        rst_n = 1;
        scan_en = 1;
        scan_in = 1;
        a = 5;
        b = 5;
        scan_in = b[0];
        #clock;
        scan_in = b[1];
        #clock;
        scan_in = b[2];
        #clock;
        scan_in = b[3];
        #clock;
        scan_in = a[0];
        #clock;
        scan_in = a[1];
        #clock;
        scan_in = a[2];
        #clock;
        scan_in = a[3];
        
        #(clock);
        scan_en = 0;
        #(clock)
        scan_en = 1;
    end

    repeat(8) begin
        #clock;
    end

    #10;

    $finish;
end



endmodule
