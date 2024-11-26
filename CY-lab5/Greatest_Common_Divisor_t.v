`timescale 1ps/1ps
`include "gcd-elfnt.v"


module gcd_t();
reg clk, rst_n, start;
reg [15:0] inputa, inputb, nowa, nowb;
wire [15:0] gcd;
wire done;

Greatest_Common_Divisor gcd_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(inputa),
    .b(inputb),
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
    nowa = 10;
    nowb = 15;
    #10;
    start = 1;
    #10;
    start = 0;
    #100;
    inputa = 16'd245;
    nowa = 245;
    inputb = 16'd105;
    nowb = 105;
    #10;
    start = 1;
    #10;
    start = 0;
    #100;
    repeat(10) begin
        inputa = $random;
        inputb = $random;
        nowa = inputa;
        nowb = inputb;
        #10;
        start = 1;
        #10;
        start = 0;
        inputa = $random;
        inputb = $random;
        #1000;
    end
    $finish;

end

always @(posedge done) begin
    $display("GCD(%d, %d) = %d", nowa, nowb, gcd);
end


endmodule