`timescale 1ps/1ps
`include "GCD.v"


module gcd_t();
reg clk, rst_n, start;
reg [15:0] inputa, inputb;
wire [15:0] gcd;
wire done;

gcd gcd_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .inputa(inputa),
    .inputb(inputb),
    .gcd(gcd),
    .done(done)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("gcd_t.vcd");
    $dumpvars(0, gcd_t);
    rst_n = 1;
    start = 0;
    inputa = 0;
    inputb = 0;
    #10;
    rst_n = 0;
    #10;
    rst_n = 1;
    inputa = 16'd10;
    inputb = 16'd15;
    #10;
    start = 1;
    #10;
    start = 0;
    #100;
    inputa = 16'd245;
    inputb = 16'd105;
    #10;
    start = 1;
    #10;
    start = 0;
    #100;
    $finish;

end


endmodule