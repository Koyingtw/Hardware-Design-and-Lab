`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output reg direction;
output reg [4-1:0] out;

always @(posedge clk) begin
    if(!rst_n) begin
        out <= 4'b0000;
        direction <= 1'b1;
    end
    else if(enable) begin
        if(direction) begin
            if(out != 15) begin
                out <= out + 1;
            end
            else begin
                out <= out - 1;
                direction <= 0;
            end
        end
        else if(!direction) begin
            if(out != 0) begin
                out <= out - 1;
            end
            else begin
                out <= out + 1;
                direction <= 1;
            end
        end
    end
end

endmodule
