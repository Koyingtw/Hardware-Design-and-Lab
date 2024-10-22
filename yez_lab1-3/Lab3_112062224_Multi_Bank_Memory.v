`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output [8-1:0] dout;

wire [8-1:0] out [3:0];
assign dout = out[0] | out[1] | out[2] | out[3];

Bank bank0(clk, ren && raddr[10:9] == 2'b00, (wen && waddr[10:9] == 2'b00), waddr[8:0], raddr[8:0], din, out[0]);
Bank bank1(clk, ren && raddr[10:9] == 2'b01, (wen && waddr[10:9] == 2'b01), waddr[8:0], raddr[8:0], din, out[1]);
Bank bank2(clk, ren && raddr[10:9] == 2'b10, (wen && waddr[10:9] == 2'b10), waddr[8:0], raddr[8:0], din, out[2]);
Bank bank3(clk, ren && raddr[10:9] == 2'b11, (wen && waddr[10:9] == 2'b11), waddr[8:0], raddr[8:0], din, out[3]);

endmodule

module Bank (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [8:0] waddr, raddr;
input [8-1:0] din;
output [8-1:0] dout;

wire [8-1:0] out [3:0];
assign dout = out[0] | out[1] | out[2] | out[3];

Memory bank0(clk, ren && raddr[8:7] == 2'b00, (wen && waddr[8:7] == 2'b00 && (!ren || raddr[8:7] != waddr[8:7])), waddr[6:0], raddr[6:0], din, out[0]);
Memory bank1(clk, ren && raddr[8:7] == 2'b01, (wen && waddr[8:7] == 2'b01 && (!ren || raddr[8:7] != waddr[8:7])), waddr[6:0], raddr[6:0], din, out[1]);
Memory bank2(clk, ren && raddr[8:7] == 2'b10, (wen && waddr[8:7] == 2'b10 && (!ren || raddr[8:7] != waddr[8:7])), waddr[6:0], raddr[6:0], din, out[2]);
Memory bank3(clk, ren && raddr[8:7] == 2'b11, (wen && waddr[8:7] == 2'b11 && (!ren || raddr[8:7] != waddr[8:7])), waddr[6:0], raddr[6:0], din, out[3]);

endmodule

module Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [7-1:0] waddr, raddr;
input [8-1:0] din;
output [8-1:0] dout;
reg [8-1:0] dout;

reg [8-1:0] mem[128-1:0];

always @(posedge clk) begin 
    if(ren) begin
        dout = mem[raddr];
    end 
    else begin
        if(wen) begin
            mem[waddr] <= din;
        end
        dout = 0;
    end
end

endmodule