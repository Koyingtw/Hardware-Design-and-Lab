`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [4-1:0] wen;
input [8-1:0] a, b, c, d;
output [8-1:0] dout;
output valid;

reg [4-1:0] ren;
wire [8-1:0] out[3:0];
wire [3:0] error;

reg wenc;
reg [1:0] counter;

assign valid = (~(error[(counter + 3) % 4] || wenc));
assign dout = valid ? out[(counter + 3) % 4] : 0;

FIFO_8 q0(clk, rst_n, wen[0], ren[0] & (!wen[0]), a, out[0], error[0]);
FIFO_8 q1(clk, rst_n, wen[1], ren[1] & (!wen[1]), b, out[1], error[1]);
FIFO_8 q2(clk, rst_n, wen[2], ren[2] & (!wen[2]), c, out[2], error[2]);
FIFO_8 q3(clk, rst_n, wen[3], ren[3] & (!wen[3]), d, out[3], error[3]);


always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 0;
        ren <= 0;
        wenc <= 1;
    end
    else begin
        ren <= 4'b0001 << (counter + 1) % 4;
        counter <= counter + 1;
        wenc <= wen[counter];
    end
end
endmodule

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
Memory_8 mem(clk, rst_n, ren & ~next_error, wen & ~next_error, addr, din, dout);

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
    if(!rst_n) begin
        dout <= 0;
    end
    else if (ren) begin
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