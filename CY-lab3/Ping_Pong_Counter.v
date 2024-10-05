`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output reg direction;
output reg [4-1:0] out;

reg started = 0;

always @(posedge clk) begin
    if (!rst_n) begin
        started <= 1;
        direction <= 1;
        out <= 0;
    end else if (started && enable) begin
        if (out == 15 && direction == 1) begin
            direction <= 0;
            out <= out - 1;
        end
        else if (out == 0 && direction == 0) begin
            direction <= 1;
            out <= out + 1;
        end
        else if (direction) begin
            out <= out + 1;
        end 
        else begin
            out <= out - 1;
        end
    end
end

endmodule
