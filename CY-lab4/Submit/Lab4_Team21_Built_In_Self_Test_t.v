`timescale 1ns/1ps

module Built_In_Self_Test_t;
reg clk;
reg rst_n;
reg scan_en;
wire scan_in;
wire scan_out;

always begin
    #5 clk = ~clk;
end
reg [3:0] cnt;

Built_In_Self_Test dut (
    .clk(clk),
    .rst_n(rst_n),
    .scan_en(scan_en),
    .scan_in(scan_in),
    .scan_out(scan_out)
);

initial begin
    clk = 1;
    rst_n = 0;
    scan_en = 0;
    #15;
    rst_n = 1;

    repeat(20) begin
        #10;
        cnt = {$random} % 4;
        scan_en = (cnt != 0);
    end
    $finish;
end

endmodule



