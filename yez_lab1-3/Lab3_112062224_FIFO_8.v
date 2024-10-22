`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output reg [8-1:0] dout;
output reg error;

reg [3-1:0] raddr, waddr;
reg [4-1:0] size;
reg [8-1:0] mem[3-1:0];

assign empty = (size == 0);
assign full = (size == 8);

always @(posedge clk) begin
    if(!rst_n) begin
        dout <= 0;
        error <= 0;
        size <= 0;
        raddr <= 0;
        waddr <= 0;
    end
    else begin
        if(ren) begin
            if(!empty) begin
                dout <= mem[raddr];
                raddr <= raddr + 1;
                size <= size - 1;
                error <= 0;
            end
            else begin
                error <= 1;
            end
        end
        else begin
            if(wen) begin
                if(!full) begin
                    mem[waddr] <= din;
                    waddr <= waddr + 1;
                    size <= size + 1;
                    error <= 0;
                end
                else begin
                    error <= 1;
                end
            end
        end
    end
end

endmodule