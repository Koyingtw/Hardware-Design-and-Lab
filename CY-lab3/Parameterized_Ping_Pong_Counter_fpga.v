`timescale 1ns/1ps

module Display_Control(SW, clk, DOWN, UP, seg_out, an);

input [15:0] SW; // SW[15]: enable, SW[14:11]: max, SW[10:7]: min
input clk;
input DOWN, UP; // DOWN: flip, UP, rst_n

wire [4-1:0] digit;

output [6:0] seg_out;
output [3:0] an;

wire direction;
reg [31:0] counter = 0; // 100MHZ, count to 100000000 = 1s
reg enable = 0;

wire [16-1:0] num [1:0];
wire [16-1:0] _num[1:0];
reg cnt_en = 0;
reg rst_n;
reg flip;
reg [3:0] min, max;
wire [6:0] seg [3:0];


wire dflip, drst_n;
wire oprst_n, opflip;

debounce De1(dflip, DOWN, clk);
debounce De2(drst_n, UP, clk);
onepulse OP1(drst_n, clk, oprst_n);
onepulse OP2(dflip, clk, opflip);

Parameterized_Ping_Pong_Counter_fpga PPC(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .cnt_en(cnt_en),
    .flip(flip),
    .max(max),
    .min(min),
    .direction(direction),
    .out(digit)
);

reg is_rst = 0;
reg is_flip = 0;
reg started = 0;

always @(posedge clk) begin
    flip <= opflip;
    rst_n <= ~oprst_n;
    if (!rst_n) begin
        started <= 1;
        counter <= 0;
    end
    if (started) begin
        $display("min: %d, max: %d", min, max);
        $display("UP: %d, DOWN: %d", UP, DOWN);
        $display("out: %d, direction: %d", digit, direction);
        $display("counter: %d", counter);
        $display("cnt_en: %d, enable: %d, rst_n: %d, flip: %d", cnt_en, enable, rst_n, flip);
        // $display("num: %b, _num: %b", num, _num);

        if (rst_n) 
            counter <= (counter + 1) % 1000000000;
        else
            counter <= 1;
        if ((counter % 50000000) == 50000000 - 1) begin
            cnt_en <= 1;
        end
        else begin
            cnt_en <= 0;
        end
        enable <= SW[15];

        min <= SW[10:7];
        max <= SW[14:11];
    end
end

assign num[1] = 1 << (digit / 10);
assign num[0] = 1 << (digit % 10);
assign _num[1] = ~(1 << (digit / 10));
assign _num[0] = ~(1 << (digit % 10));
SymbolA A3(.num(num[1]), ._num(_num[1]), .out(seg[3][0]));
SymbolB B3(.num(num[1]), ._num(_num[1]), .out(seg[3][1]));
SymbolC C3(.num(num[1]), ._num(_num[1]), .out(seg[3][2]));
SymbolD D3(.num(num[1]), ._num(_num[1]), .out(seg[3][3]));
SymbolE E3(.num(num[1]), ._num(_num[1]), .out(seg[3][4]));
SymbolF F3(.num(num[1]), ._num(_num[1]), .out(seg[3][5]));
SymbolG G3(.num(num[1]), ._num(_num[1]), .out(seg[3][6]));

SymbolA A2(.num(num[0]), ._num(_num[0]), .out(seg[2][0]));
SymbolB B2(.num(num[0]), ._num(_num[0]), .out(seg[2][1]));
SymbolC C2(.num(num[0]), ._num(_num[0]), .out(seg[2][2]));
SymbolD D2(.num(num[0]), ._num(_num[0]), .out(seg[2][3]));
SymbolE E2(.num(num[0]), ._num(_num[0]), .out(seg[2][4]));
SymbolF F2(.num(num[0]), ._num(_num[0]), .out(seg[2][5]));
SymbolG G2(.num(num[0]), ._num(_num[0]), .out(seg[2][6]));

assign seg[1] = (direction == 1) ? ~(7'b0100011) : ~(7'b0011100);
assign seg[0] = (direction == 1) ? ~(7'b0100011) : ~(7'b0011100);
assign seg_out = seg[(counter / 100000) % 4];
assign an[0] = ((counter / 100000) % 4) != 0;
assign an[1] = ((counter / 100000) % 4) != 1;
assign an[2] = ((counter / 100000) % 4) != 2;
assign an[3] = ((counter / 100000) % 4) != 3;

// always @(posedge clk) begin
//     if (started) begin
//     end
// end



endmodule

module Parameterized_Ping_Pong_Counter_fpga (clk, rst_n, enable, cnt_en, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input cnt_en;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;


reg started = 0;

always @(posedge clk) begin
    if (!rst_n) begin
        started <= 1;
        direction <= 1;
        out <= 0;
    end 
    else if (started && enable && out <= max && out >= min) begin
        if (flip) begin
            direction <= ~direction;
        end
        if (out == max && (direction ^ flip) == 1) begin
            direction <= 0;
            if (cnt_en) out <= out - 1;
        end
        else if (out == min && (direction ^ flip) == 0) begin
            direction <= 1;
            if (cnt_en) out <= out + 1;
        end
        else if (direction ^ flip) begin
            if (cnt_en) out <= out + 1;
        end 
        else begin
            if (cnt_en) out <= out - 1;
        end
    end
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