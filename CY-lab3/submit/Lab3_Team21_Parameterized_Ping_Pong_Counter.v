`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
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
    else if (flip && out > min && out < max) begin
        direction <= ~direction;
        started <= started;
        if (direction ^ flip) begin
            out <= out + 1;
        end
        else begin
            out <= out - 1;
        end
    end
    else if (started && enable && out <= max && out >= min) begin
        if (out == max && (direction ^ flip) == 1) begin
            direction <= 0;
            out <= out - 1;
        end
        else if (out == min && (direction ^ flip) == 0) begin
            direction <= 1;
            out <= out + 1;
        end
        else if (direction ^ flip) begin
            direction <= direction;
            out <= out + 1;
        end 
        else begin
            direction <= direction;
            out <= out - 1;
        end
        started <= started;
    end
    else begin
        direction <= direction;
        out <= out;
        started <= started;
    end
end

endmodule

