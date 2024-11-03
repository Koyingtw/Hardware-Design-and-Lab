`timescale 1ns/1ps
`include "BoothMultiplier.v"


module booth_multiplier_tb();

// 測試訊號宣告
reg clk;
reg rst_n;
reg start;
reg signed [3:0] a;
reg signed [3:0] b;
wire signed [7:0] p;

// 實例化被測試模組
booth_multiplier booth_inst (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .a(a),
    .b(b),
    .p(p)
);

// 時鐘產生
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// 測試向量
integer i;
reg signed [3:0] test_a [0:7];
reg signed [3:0] test_b [0:7];
reg signed [7:0] expected_p [0:7];

// 監控輸出
initial begin
    $monitor("Time=%0t rst_n=%b start=%b a=%d b=%d p=%d", 
             $time, rst_n, start, a, b, p);
end

// 主要測試程序
initial begin
    // 初始化測試向量
    test_a[0] = 4'd3;  test_b[0] = 4'd2;  expected_p[0] = 8'd6;   // 正數 × 正數
    test_a[1] = -4'd2; test_b[1] = 4'd3;  expected_p[1] = -8'd6;  // 負數 × 正數
    test_a[2] = 4'd3;  test_b[2] = -4'd2; expected_p[2] = -8'd6;  // 正數 × 負數
    test_a[3] = -4'd2; test_b[3] = -4'd3; expected_p[3] = 8'd6;   // 負數 × 負數
    test_a[4] = 4'd7;  test_b[4] = 4'd7;  expected_p[4] = 8'd49;  // 最大正數 × 最大正數
    test_a[5] = -4'd8; test_b[5] = 4'd7;  expected_p[5] = -8'd56; // 最小負數 × 正數
    test_a[6] = 4'd0;  test_b[6] = 4'd5;  expected_p[6] = 8'd0;   // 零測試
    test_a[7] = 4'd1;  test_b[7] = 4'd1;  expected_p[7] = 8'd1;   // 單位測試

    // 初始化訊號
    rst_n = 1;
    start = 0;
    a = 0;
    b = 0;

    // 重置測試
    #10 rst_n = 0;
    #10 rst_n = 1;

    // 執行所有測試案例
    for (i = 0; i < 8; i = i + 1) begin
        // 設置輸入值
        a = test_a[i];
        b = test_b[i];
        start = 1;
        #10 start = 0;

        // 等待計算完成（WAIT + 4個CAL + 2個FINISH = 7個週期）
        #60;

        // // 驗證結果
        // if (p === expected_p[i]) begin
        //     $display("Test Case %0d PASSED: %d * %d = %d", 
        //             i, test_a[i], test_b[i], p);
        // end else begin
        //     $display("Test Case %0d FAILED: %d * %d = %d (Expected: %d)", 
        //             i, test_a[i], test_b[i], p, expected_p[i]);
        // end

        // 等待一些時間再開始下一個測試
        #10;
    end

    // 額外的錯誤測試案例：在計算過程中改變輸入值
    a = 4'd3;
    b = 4'd2;
    start = 1;
    #10 start = 0;
    #20 a = 4'd5; // 在計算過程中改變輸入值
    #50;

    // 完成測試
    #100;
    $display("All tests completed!");
    $finish;
end

// 檢查重置功能
initial begin
    // 在隨機時間點觸發重置
    #200;
    rst_n = 0;
    #10;
    rst_n = 1;
    
    // 驗證重置後的狀態
    if (p !== 8'd0) begin
        $display("Reset test FAILED: Output not zero after reset");
    end else begin
        $display("Reset test PASSED");
    end
end

// 產生波形檔
initial begin
    $dumpfile("booth_multiplier_tb.vcd");
    $dumpvars(0, booth_multiplier_tb);
end

endmodule