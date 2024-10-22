`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;

always @(posedge clk) begin
    if(!rst_n) begin
        out <= min;
        direction <= 1'b1;
    end
    else if (enable) begin
        if(flip) begin
            direction <= !direction;
        end
        if(direction ^ flip) begin
            if(out < max && out >= min) begin
                out <= out + 1;
            end
            else if(out == max && out != min) begin
                out <= out - 1;
                direction <= 0;
            end
        end
        else begin
            if(out <= max && out > min) begin
                out <= out - 1;
            end
            else if(out == min && out != max) begin
                out <= out + 1;
                direction <= 1;
            end
        end
    end
end

endmodule