`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [8-1:0] out;

reg started = 0;

always @(posedge clk) begin
    if ((!rst_n) && (!started)) begin
        out <= 8'b10111101;
        started <= 1;
    end
    else if (started) begin
        out[0] <= out[7];
        out[1] <= out[0];
        out[2] <= (out[1] ^ out[7]);
        out[3] <= (out[2] ^ out[7]);
        out[4] <= (out[3] ^ out[7]);
        out[5] <= out[4];
        out[6] <= out[5];
        out[7] <= out[6];
    end
end

endmodule
