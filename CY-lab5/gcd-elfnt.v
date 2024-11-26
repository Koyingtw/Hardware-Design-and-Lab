`timescale 1ns/1ps

module Greatest_Common_Divisor_elfnt (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output reg done;
output reg [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;
parameter PRE_FINISH = 2'b11;

reg [1:0] state, next_state;
reg [15:0] tmp_a, tmp_b, next_a, next_b, next_gcd;
reg next_done;

always @(posedge clk) begin
    state <= next_state;
    gcd <= next_gcd;
    done <= next_done;
    tmp_a <= next_a;
    tmp_b <= next_b;
end
always @(*) begin
    if(!rst_n) begin
        next_state = WAIT;
        next_a = 16'b0;
        next_b = 16'b0;
        next_gcd = 16'b0;
        next_done = 1'b0;
    end
    else begin
        case (state)
            WAIT: begin
                if (start) begin
                    next_state = CAL;
                    next_a = a;
                    next_b = b;
                end
                else begin
                    next_state = WAIT;
                    next_a = 16'b0;
                    next_b = 16'b0;
                    next_gcd = 16'b0;
                end
            end
            CAL: begin
                if(tmp_a == 0) begin
                    next_gcd = tmp_b;
                    next_done = 1'b1;
                    next_state = PRE_FINISH;
                end
                else if(tmp_b == 0) begin
                    next_gcd = tmp_a;
                    next_done = 1'b1;
                    next_state = PRE_FINISH;
                end
                else if(tmp_a > tmp_b) begin
                    next_a = tmp_a - tmp_b;
                    next_b = tmp_b;
                    next_state = CAL;
                end
                else begin
                    next_a = tmp_a;
                    next_b = tmp_b - tmp_a;
                    next_state = CAL;
                end
            end
            FINISH: begin
                next_done = 1'b0;
                next_gcd = 16'b0;
                next_state = WAIT;
            end
            PRE_FINISH: begin
                next_state = FINISH;
            end
            default: begin
                next_state = WAIT;
                next_a = 16'b0;
                next_b = 16'b0;
                next_gcd = 16'b0;
                next_done = 1'b0;
            end
        endcase
    end
end
endmodule