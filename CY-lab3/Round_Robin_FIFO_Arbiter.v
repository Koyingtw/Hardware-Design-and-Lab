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

assign valid = (~(error[(counter + 3) % 4] || wenc));
assign dout = valid ? out[(counter + 3) % 4] : 0;

FIFO_8 q0(clk, rst_n, wen[0], ren[0] & (!wen[0]), a, out[0], error[0]);
FIFO_8 q1(clk, rst_n, wen[1], ren[1] & (!wen[1]), b, out[1], error[1]);
FIFO_8 q2(clk, rst_n, wen[2], ren[2] & (!wen[2]), c, out[2], error[2]);
FIFO_8 q3(clk, rst_n, wen[3], ren[3] & (!wen[3]), d, out[3], error[3]);

reg [1:0] counter;

always @(posedge clk) begin
    $display("counter: %d, valid: %d, error[counter]: %d, wen[counter]: %d", counter, valid, error[counter], wen[counter]);
    if (!rst_n) begin
        counter <= 0;
        ren <= 0;
        wenc <= 1;
    end
    else begin
        $display("counter: %d, valid: %d, error[counter]: %d, wen[counter]: %d, ren[counter]: %d", counter, valid, error[counter], wen[counter], ren[counter]);

        $display("out[0]: %d, out[1]: %d, out[2]: %d, out[3]: %d", out[0], out[1], out[2], out[3]);
        ren <= 4'b0001 << (counter + 1) % 4;
        counter <= counter + 1;
        wenc <= wen[counter];
    end
end
endmodule
