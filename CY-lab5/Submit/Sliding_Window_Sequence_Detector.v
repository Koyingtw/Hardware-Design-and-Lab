`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg [2:0] state;
assign dec = state == 3'd7 && in;

always @(posedge clk) begin
    if(!rst_n) begin
        state <= 3'd0;
    end
    else begin
        case(state)
            3'd0: begin
                if(in) state <= 3'd1;
                else state <= 3'd0;
            end
            3'd1: begin
                if(in) state <= 3'd2;
                else state <= 3'd0;
            end
            3'd2: begin
                if(in) state <= 3'd3;
                else state <= 3'd0;
            end
            3'd3: begin
                if(in) state <= 3'd3;
                else state <= 3'd4;
            end
            3'd4: begin
                if(in) state <= 3'd1;
                else state <= 3'd5;
            end
            3'd5: begin
                if(in) state <= 3'd6;
                else state <= 3'd0;
            end
            3'd6: begin
                if(in) state <= 3'd7;
                else state <= 3'd5;
            end
            3'd7: begin
                if(in) state <= 3'd3;
                else state <= 3'd0;
            end
        endcase
    end
end

endmodule 