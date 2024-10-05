`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout;

reg [8-1:0] mem [128-1:0];

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
