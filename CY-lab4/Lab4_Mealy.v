`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output wire out;
output reg [3-1:0] state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg started = 0;

assign out = (state == S0 && in) || (state == S1) || (state == S2 && !in) || (state == S3 && !in) || (state == S4);


always @(posedge clk) begin
    if ((!rst_n) && (!started)) begin
        state <= S0;
        started <= 1'b1;
        if (in) begin
            state <= S2;
        end
        else begin
            state <= S0;
        end
    end
    if (started) begin
        case(state)
            S0: begin
                if (in) begin
                    state <= S2;
                end
                else begin
                    state <= S0;
                end
            end
            S1: begin
                if (in) begin
                    state <= S4;
                end
                else begin
                    state <= S0;
                end
            end
            S2: begin
                if (in) begin
                    state <= S1;
                end
                else begin
                    state <= S5;
                end
            end
            S3: begin
                if (in) begin
                    state <= S2;
                end
                else begin
                    state <= S3;
                end
            end
            S4: begin
                if (in) begin
                    state <= S4;
                end
                else begin
                    state <= S2;
                end
            end
            S5: begin
                if (in) begin
                    state <= S4;
                end
                else begin
                    state <= S3;
                end
            end
        endcase
    end
end
endmodule
