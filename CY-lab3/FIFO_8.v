`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output [8-1:0] dout;
output reg error;

wire [3-1:0] addr;
reg [3-1:0] waddr, raddr;
assign addr = (ren) ? raddr : waddr;
reg [3:0] count;
assign next_error = (count == 0 && ren) || (count == 8 && !ren && wen);
// reg [8-1:0] mem [0:7];
Memory_8 mem(clk, rst_n, ren & (~next_error), wen & (~next_error) & (!ren), addr, din, dout);

always @(posedge clk) begin
    if (!rst_n) begin
        waddr <= 0;
        raddr <= 0;
        count <= 0;
        error <= 0;
    end 
    else begin     
        error <= next_error;
        if (!next_error) begin
            if (ren) begin
                raddr <= raddr + 1'b1;
                count <= count - 1'b1;
                waddr <= waddr;
            end
            else if (wen) begin
                count <= count + 1'b1;
                raddr <= raddr;
                waddr <= waddr + 1'b1;
            end
            else begin
                count <= count;
                raddr <= raddr;
                waddr <= waddr;
            end
        end
    end
end

endmodule

module Memory_8 (clk, rst_n, ren, wen, addr, din, dout);
input clk, rst_n;
input ren, wen;
input [3-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout;

reg [8-1:0] mem [8-1:0];

always @(posedge clk) begin
    if (ren) begin
        dout <= mem[addr];
    end
    else if (wen) begin
        mem[addr] <= din;
        dout <= 0;
    end
    else begin
        dout <= 0;
    end
end

endmodule