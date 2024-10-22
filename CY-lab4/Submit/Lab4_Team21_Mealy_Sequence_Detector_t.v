`timescale 1ns/1ps

module Mealy_Sequence_Detector_t;
reg clk = 0, rst_n;
reg in;
wire dec;

always #5 clk = ~clk; // 生成時鐘信號，週期為10ns

Mealy_Sequence_Detector MSD(clk, rst_n, in, dec);

reg [3:0] cnt;
integer i, j;
initial begin
    // 初始化
    rst_n = 0;
    in = 0;
    cnt = 0;
    clk = 1;
    #5
    rst_n = 1;
    for(i=0; i < 16; i = i + 1) begin
        for(j=3; j >= 0; j = j - 1) begin
            in = cnt[j];
            // $display("cnt: %d, cnt[j]: %d, in: %d", cnt, cnt[j], in);
            #10;
        end
        cnt = cnt + 1;
    end

    // example test case
    // @(negedge clk) 
    //     in = 0;
    //     rst_n = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;
    
    // 模擬結束
    $finish;
end

always @(posedge clk) begin
    if(dec) begin
        $display("cnt: %b, in: %d, dec=%d", cnt, in, dec);
    end
end

endmodule