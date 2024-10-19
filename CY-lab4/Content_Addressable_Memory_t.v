`timescale 1ns/1ps

module Content_Addressable_Memory_t;
reg clk = 0;
reg wen, ren;
reg [7:0] din;
reg [3:0] addr;
wire [3:0] dout;
wire hit;

always #(1) clk = !clk;

Content_Addressable_Memory CAM(clk, wen, ren, din, addr, dout, hit);

initial begin
    wen = 0;
    ren = 0;
    din = 0;
    addr = 0;
    #2
    @(negedge clk)
    wen = 0; addr = 0; din = 0; ren = 0;

    @(negedge clk)
    wen = 0; addr = 0; din = 0; ren = 1;
    
    @(negedge clk)
    wen = 1; addr = 0; din = 4; ren = 0;

    @(negedge clk)
    wen = 1; addr = 7; din = 8; ren = 0;
    
    @(negedge clk)
    wen = 1; addr = 15; din = 35; ren = 0;
    
    @(negedge clk)
    wen = 1; addr = 9; din = 8; ren = 0;

    repeat(3) @(negedge clk)
    wen = 0; addr = 0; din = 0; ren = 0;
    
    @(negedge clk)
    wen = 0; addr = 0; din = 4; ren = 1;

    @(negedge clk)
    wen = 0; addr = 0; din = 8; ren = 1;
    
    @(negedge clk)
    wen = 0; addr = 0; din = 35; ren = 1;
    
    @(negedge clk)
    wen = 0; addr = 0; din = 87; ren = 1;
    
    @(negedge clk)
    wen = 0; addr = 0; din = 45; ren = 1;
    
    @(negedge clk)
    wen = 1; addr = 0; din = 8; ren = 1;
    
    @(negedge clk)
    wen = 1; addr = 0; din = 8; ren = 1;
    
    @(negedge clk)
    wen = 1; addr = 0; din = 8; ren = 1;
    
    // 讀取操作結束
    @(negedge clk)
    wen = 0; addr = 0; din = 0; ren = 0;
    
    // 等待幾個時鐘週期後結束仿真
    repeat(3) @(negedge clk);
    $finish;
end

always @(posedge clk) 
    #0.5 $display("din: %d, dout: %d, hit: %b", din, dout, hit);

endmodule