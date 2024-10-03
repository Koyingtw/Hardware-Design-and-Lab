`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output reg clk1_2;
output reg clk1_4;
output reg clk1_8;
output reg clk1_3;
output reg dclk;

reg [4:0] cnt;
reg started = 0;

always @(posedge clk) begin
    if ((!rst_n) && (!started)) begin
        cnt <= 5'd1;
        started <= 1'b1;
        clk1_2 <= 1'b1;
        clk1_4 <= 1'b1;
        clk1_8 <= 1'b1;
        clk1_3 <= 1'b1;
    end else if (started) begin
        cnt <= (cnt + 1'b1) % 24;
        clk1_2 <= (cnt % 2 == 0);
        clk1_4 <= (cnt % 4 == 0);
        clk1_8 <= (cnt % 8 == 0);
        clk1_3 <= (cnt % 3 == 0);
    end
end

always @(*) begin
    case(sel)
        2'b00: dclk = clk1_3;
        2'b01: dclk = clk1_2;
        2'b10: dclk = clk1_4;
        2'b11: dclk = clk1_8;
    endcase
end

endmodule
