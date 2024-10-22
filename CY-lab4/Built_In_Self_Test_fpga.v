`timescale 1ns/1ps

module Display_Control(clk, UP, RIGHT, scan_en, LFSR_v, an, seg_out, Q);
input clk, UP, RIGHT, scan_en;
input [8-1:0] LFSR_v;
output [4-1:0] an;
output [7-1:0] seg_out;
output [8-1:0] Q;

wire de_up, de_right;
wire d_clk_tmp, d_clk, reset, rst_n;
reg [30:0] counter;
wire [8-1:0] seg[3:0];
wire [16-1:0] num[3:0], _num[3:0];

debounce db(de_up, UP, clk);
debounce db2(de_right, RIGHT, clk);
onepulse op(de_up, clk, reset);
onepulse op2(de_right, clk, d_clk_tmp);
assign d_clk = d_clk_tmp | reset;
assign rst_n = ~reset;

wire scan_in, scan_out;
wire [8-1:0] Q;

Built_In_Self_Test BIST(clk, d_clk, rst_n, scan_en, scan_in, scan_out, LFSR_v, Q);

always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 0;
    end
    else begin
        counter <= counter + 1;
    end
end


assign num[3] = 1 << (scan_in);
assign num[2] = 1 << (Q[7:4]);
assign num[1] = 1 << (Q[3:0]);
assign num[0] = 1 << (scan_out);
assign _num[3] = ~num[3];
assign _num[2] = ~num[2];
assign _num[1] = ~num[1];
assign _num[0] = ~num[0];

SymbolA A3(num[3], _num[3], seg[3][0]);
SymbolB B3(num[3], _num[3], seg[3][1]);
SymbolC C3(num[3], _num[3], seg[3][2]);
SymbolD D3(num[3], _num[3], seg[3][3]);
SymbolE E3(num[3], _num[3], seg[3][4]);
SymbolF F3(num[3], _num[3], seg[3][5]);
SymbolG G3(num[3], _num[3], seg[3][6]);

SymbolA A2(num[2], _num[2], seg[2][0]);
SymbolB B2(num[2], _num[2], seg[2][1]);
SymbolC C2(num[2], _num[2], seg[2][2]);
SymbolD D2(num[2], _num[2], seg[2][3]);
SymbolE E2(num[2], _num[2], seg[2][4]);
SymbolF F2(num[2], _num[2], seg[2][5]);
SymbolG G2(num[2], _num[2], seg[2][6]);

SymbolA A1(num[1], _num[1], seg[1][0]);
SymbolB B1(num[1], _num[1], seg[1][1]);
SymbolC C1(num[1], _num[1], seg[1][2]);
SymbolD D1(num[1], _num[1], seg[1][3]);
SymbolE E1(num[1], _num[1], seg[1][4]);
SymbolF F1(num[1], _num[1], seg[1][5]);
SymbolG G1(num[1], _num[1], seg[1][6]);

SymbolA A0(num[0], _num[0], seg[0][0]);
SymbolB B0(num[0], _num[0], seg[0][1]);
SymbolC C0(num[0], _num[0], seg[0][2]);
SymbolD D0(num[0], _num[0], seg[0][3]);
SymbolE E0(num[0], _num[0], seg[0][4]);
SymbolF F0(num[0], _num[0], seg[0][5]);
SymbolG G0(num[0], _num[0], seg[0][6]);


assign seg_out = seg[counter[16:15]];
assign an[0] = counter[16:15] != 0;
assign an[1] = counter[16:15] != 1;
assign an[2] = counter[16:15] != 2;
assign an[3] = counter[16:15] != 3;


endmodule



module Built_In_Self_Test(clk, d_clk, rst_n, scan_en, scan_in, scan_out, LFSR_v, Q);
input clk, d_clk;
input rst_n;
input scan_en;
input [7:0] LFSR_v;
output scan_in;
output scan_out;
output [8-1:0] Q;

Many_To_One_LFSR LFSR(clk, d_clk, rst_n, scan_in, LFSR_v);
Scan_Chain_Design SCD(clk, d_clk, rst_n, scan_in, scan_en, scan_out, Q);

endmodule

module Scan_Chain_Design(clk, d_clk, rst_n, scan_in, scan_en, scan_out, Q);
input clk, d_clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;
output [8-1:0] Q;

wire [8-1:0] p;
wire [4-1:0] a, b;

assign scan_out = b[0];

SDFF sdff7(clk, d_clk, rst_n, scan_in, scan_en, p[7], a[3]);
SDFF sdff6(clk, d_clk, rst_n, a[3], scan_en, p[6], a[2]);
SDFF sdff5(clk, d_clk, rst_n, a[2], scan_en, p[5], a[1]);
SDFF sdff4(clk, d_clk, rst_n, a[1], scan_en, p[4], a[0]);
SDFF sdff3(clk, d_clk, rst_n, a[0], scan_en, p[3], b[3]);
SDFF sdff2(clk, d_clk, rst_n, b[3], scan_en, p[2], b[2]);
SDFF sdff1(clk, d_clk, rst_n, b[2], scan_en, p[1], b[1]);
SDFF sdff0(clk, d_clk, rst_n, b[1], scan_en, p[0], b[0]);
assign p = a * b;

assign Q = {a[3], a[2], a[1], a[0], b[3], b[2], b[1], b[0]};


always @(posedge clk) begin
    $display("%d %d %d", a, b, p);
end


endmodule

module SDFF(clk, d_clk, rst_n, scan_in, scan_en, data, out);
input clk, d_clk, rst_n, scan_in, scan_en, data;
output reg out;


always @(posedge clk) begin
    if (!rst_n) begin
        out <= 1'b0;
    end
    else if (d_clk) begin
        if (scan_en) begin
            out <= scan_in;
        end
        else begin
            out <= data;
        end
    end
end

endmodule


module Many_To_One_LFSR(clk, d_clk, rst_n, out, LFSR_v);
input clk, d_clk;
input rst_n;
input [8-1:0] LFSR_v;
output out;
reg [8-1:0] mem;

assign out = mem[7];

always @(posedge clk) begin
    if ((!rst_n)) begin
        mem <= LFSR_v;
    end
    else if(d_clk) begin
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

module debounce (pb_debounced, pb, clk);
output pb_debounced; // signal of a pushbutton after being debounced
input pb; // signal from a pushbutton
input clk;
reg [3:0] DFF; // use shift_reg to filter pushbutton bounce
always @(posedge clk)
begin
DFF[3:1] <= DFF[2:0];
DFF[0] <= pb;
end
assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse (PB_debounced, CLK, PB_one_pulse);
input PB_debounced;
input CLK;
output PB_one_pulse;
reg PB_one_pulse;
reg PB_debounced_delay;
always @(posedge CLK) begin
PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
PB_debounced_delay <= PB_debounced;
end
endmodule

module SymbolA(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[2], num[3],
        num[5], num[6], num[7], num[8], num[9], num[10],
        num[12] , num[14], num[15]);
endmodule

module SymbolB(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[1], num[2], num[3], num[4],
        num[7], num[8], num[9], num[10],
        num[13]);
endmodule

module SymbolC(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[1], num[3], num[4],
        num[5], num[6], num[7], num[8], num[9], num[10],
        num[11], num[13]);
endmodule

module SymbolD(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[2], num[3], 
        num[5], num[6], num[8],
        num[11], num[12], num[13], num[14]);
endmodule

module SymbolE(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[2],
        num[6], num[8], num[10],
        num[11], num[12], num[13], num[14], num[15]);
endmodule

module SymbolF(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[0], num[4],
        num[5], num[6], num[8], num[9], num[10],
        num[11], num[12], num[14], num[15]);
endmodule

module SymbolG(num, _num, out);
input [16-1:0] num, _num;
output out;

nor and1(out, num[2], num[3], num[4],
        num[5], num[6], num[8], num[9], num[10],
        num[11], num[13], num[14], num[15]);
endmodule
