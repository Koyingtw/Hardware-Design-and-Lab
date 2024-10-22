`timescale 1ns/1ps

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;

Many_To_One_LFSR LFSR(clk, rst_n, scan_in);
Scan_Chain_Design SCD(clk, rst_n, scan_in, scan_en, scan_out);

endmodule

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;

wire [8-1:0] p;
wire [4-1:0] a, b;

assign scan_out = b[0];

SDFF sdff7(clk, rst_n, scan_in, scan_en, p[7], a[3]);
SDFF sdff6(clk, rst_n, a[3], scan_en, p[6], a[2]);
SDFF sdff5(clk, rst_n, a[2], scan_en, p[5], a[1]);
SDFF sdff4(clk, rst_n, a[1], scan_en, p[4], a[0]);
SDFF sdff3(clk, rst_n, a[0], scan_en, p[3], b[3]);
SDFF sdff2(clk, rst_n, b[3], scan_en, p[2], b[2]);
SDFF sdff1(clk, rst_n, b[2], scan_en, p[1], b[1]);
SDFF sdff0(clk, rst_n, b[1], scan_en, p[0], b[0]);
assign p = a * b;


always @(posedge clk) begin
    $display("%d %d %d", a, b, p);
end


endmodule

module SDFF(clk, rst_n, scan_in, scan_en, data, out);
input clk, rst_n, scan_in, scan_en, data;
output reg out;


always @(posedge clk) begin
    if (!rst_n) begin
        out <= 1'b0;
    end
    else begin
        if (scan_en) begin
            out <= scan_in;
        end
        else begin
            out <= data;
        end
    end
end

endmodule


module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output out;
reg [8-1:0] mem;

assign out = mem[7];

reg started = 0;

always @(posedge clk) begin
    if ((!rst_n) && (!started)) begin
        mem <= 8'b10111101;
        started <= 1;
    end
    else if (started) begin
        mem[0] <= (mem[1] ^ mem[2]) ^ (mem[3] ^ mem[7]);
        mem[1] <= mem[0];
        mem[2] <= mem[1];
        mem[3] <= mem[2];
        mem[4] <= mem[3];
        mem[5] <= mem[4];
        mem[6] <= mem[5];
        mem[7] <= mem[6];
    end
end


endmodule