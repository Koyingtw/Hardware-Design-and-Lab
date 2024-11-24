`timescale 1ps/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output reg done;
output reg [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg [1:0] state;
reg [15:0] inputa, inputb;
reg counter;


always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 2'd0;
        gcd <= 16'd0;
        done <= 1'b0;
        state <= 2'b00;
        counter <= 2'b00;
    end
    else begin
        case(state)
            WAIT: begin
                if (start) begin
                    state <= CAL;
                end
                counter <= 2'd0;
                gcd <= 16'd0;
                done <= 1'b0;
            end
            CAL: begin
                if (inputa == 0 || inputb == 0) begin
                    state <= FINISH;
                    gcd <= inputa | inputb;
                    done <= 1'b1;
                end
                else begin
                    state <= CAL;
                    if (inputa > inputb) begin
                        inputa <= inputa - inputb;
                    end
                    else
                        inputb <= inputb - inputa;
                    gcd <= 0;
                    done <= 0;
                    counter <= 2'd0;
                end
            end
            FINISH: begin
                if (counter == 2'd1) begin
                    state <= WAIT;
                    gcd <= 0;
                    done <= 0;
                end
                else begin
                    state <= FINISH;
                    gcd <= gcd;
                    counter <= counter + 1;
                end
            end
        endcase

    end
    if (start && state != CAL) begin
        inputa <= a;
        inputb <= b;
    end
    else if (state != CAL) begin
        inputa <= inputa;
        inputb <= inputb;
    end
end

endmodule