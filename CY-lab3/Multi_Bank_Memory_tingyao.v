`timescale 1ns/1ps

module Multi_Bank_Memory_ting_yao();
    reg clk = 0, ren , wen;
    reg [11-1:0] waddr, raddr;
    reg [8-1:0] din;
    wire [8-1:0] dout;

    Multi_Bank_Memory MBM(clk, ren, wen, waddr, raddr, din, dout);
    
    always #5 clk = !clk;

    initial begin
        #10 ren = 0;
        #20 ren = 1;
        #50 ren = 0;
        #10 $finish;
    end

    initial begin
        #10 wen = 1;
        #10 wen = 0;
        #20 wen = 1;
        #30 wen = 0;
    end

    initial begin
        #30 raddr = 11'h057;
        #20 raddr = 11'h28F;
        #10 raddr = 11'h299;
        #10 raddr = 11'h77F;
    end

    initial begin
        #10 waddr = 11'h057;
        #30 waddr = 11'h28F;
        #10 waddr = 11'h299;
        #10 waddr = 11'h57F;
    end

    initial begin
        #10 din = 8'h57;
        #30 din = 8'h55;
        #10 din = 8'h64;
        #10 din = 8'h4D;
    end
endmodule