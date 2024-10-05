`timescale 1ns/1ps

module FIFO_8_t;
reg clk;
reg rst_n;
reg wen, ren;
reg [8-1:0] din;
wire [8-1:0] dout;
wire error;

reg started = 0;
wire [3:0] counter;

FIFO_8 FIFO_8(clk, rst_n, wen, ren, din, dout, error);

always begin
    #5 clk = ~clk;
end

initial begin
    #10 rst_n = 0;

    #20 rst_n = 1;
end

reg [3:0] count = 0;

always @(posedge clk) begin
    if (rst_n == 0) begin
        started <= 1;
    end    

    #1;
    // display time
    
    $display("%t: count = %d, counter = %d", $time, count, counter);

    if (started) begin
        if (ren) begin
            if (count == 0) begin
                if (error != 1) begin
                    $display("Error: empty, error should be 1");
                    #10;
                    $finish;
                end
            end
            else begin
                count = count - 1;
            end
        end 
        else if (wen) begin
            if (count == 8) begin
                if (error != 1) begin
                    $display("Error: full, error should be 1");
                    #10;
                    $finish;
                end
            end
            else begin
                count = count + 1;
            end
        end
    end
end

initial begin
    clk = 0;
    rst_n = 1;
    wen = 0;
    ren = 0;
    din = 0;
    started = 0;
    #20
    repeat (2**10) begin
        #10;
        wen = {$random} % 2;
        ren = {$random} % 2;
        din = {$random} % 256;

    end
    $finish;
end

endmodule
