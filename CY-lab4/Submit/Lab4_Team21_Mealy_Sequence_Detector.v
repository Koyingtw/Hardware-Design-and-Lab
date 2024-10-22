`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

reg[2:0] state;
reg[1:0] cnt;
assign dec = (state == 3'd3 && in) || (state == 3'd5 && !in);

always @(posedge clk) begin
    if(!rst_n || cnt == 3'd0) begin
        state <= 3'd0;
        cnt <= 3'd1;
    end
    else begin
        cnt <= cnt + 3'd1;
        case(state)
            3'd0: begin
                if(in) state <= 3'd1;
                else state <= 3'd6;
            end
            3'd1: begin
                if(in) state <= 3'd4;
                else state <= 3'd2;
            end
            3'd2: begin
                if(in) state <= 3'd0;
                else state <= 3'd3;
            end
            3'd3: state <= 3'd0;
            3'd4: begin
                if(in) state <= 3'd5;
                else state <= 3'd0;
            end
            3'd5: state <= 3'd0;
            3'd6: begin
                if(in) state <= 3'd7;
                else state <= 3'd0;
            end
            3'd7: begin
                if(in) state <= 3'd3;
                else state <= 3'd0;
            end
        endcase
    end
end


endmodule
