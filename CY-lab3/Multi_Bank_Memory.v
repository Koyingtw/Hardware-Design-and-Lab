`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output [8-1:0] dout;

wire [8-1:0] out [3:0];
reg [11-1:0] waddr_reg, raddr_reg;

assign dout = out[0] | out[1] | out[2] | out[3];
// assign dout = clk ? out[raddr[10:9]] : dout;
wire write = wen && (ren == 0 || (waddr[10:7] != raddr[10:7]));

Bank bank0(clk, ren && (raddr[10:9] == 0), write && (waddr[10:9] == 0), 
        waddr[8:0], raddr[8:0], din, out[0]);
Bank bank1(clk, ren && (raddr[10:9] == 1), write && (waddr[10:9] == 1),
        waddr[8:0], raddr[8:0], din, out[1]);
Bank bank2(clk, ren && (raddr[10:9] == 2), write && (waddr[10:9] == 2),
        waddr[8:0], raddr[8:0], din, out[2]);
Bank bank3(clk, ren && (raddr[10:9] == 3), write && (waddr[10:9] == 3),
        waddr[8:0], raddr[8:0], din, out[3]);

endmodule

module Bank(clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [8:0] waddr;
input [8:0] raddr;
input [8-1:0] din;
output [8-1:0] dout;

wire [8-1:0] out [3:0];

assign dout = out[0] | out[1] | out[2] | out[3];
// assign dout = clk ? out[raddr[8:7]] : dout;

wire read, write;
wire [6:0] address;

assign address = ren ? raddr[6:0] : waddr[6:0];
assign write = wen;


Memory sub1(clk, ren && (raddr[8:7] == 0), write && (waddr[8:7] == 0), ren && (raddr[8:7] == 0) ? raddr[6:0] : waddr[6:0], din, out[0]);
Memory sub2(clk, ren && (raddr[8:7] == 1), write && (waddr[8:7] == 1), addren && (raddr[8:7] == 1) ? raddr[6:0] : waddr[6:0], din, out[1]);
Memory sub3(clk, ren && (raddr[8:7] == 2), write && (waddr[8:7] == 2), ren && (raddr[8:7] == 2) ? raddr[6:0] : waddr[6:0], din, out[2]);
Memory sub4(clk, ren && (raddr[8:7] == 3), write && (waddr[8:7] == 3), ren && (raddr[8:7] == 3) ? raddr[6:0] : waddr[6:0], din, out[3]);

endmodule

