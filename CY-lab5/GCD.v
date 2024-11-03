`timescale 1ps/1ps

module gcd(clk, rst_n, start, inputa, inputb, gcd, done);
input clk, rst_n, start;
input [15:0] inputa, inputb; 

output reg [15:0] gcd;
output reg done;

localparam WAIT   = 2'b00;
localparam CAL    = 2'b01;
localparam FINISH = 2'b10;

reg [1:0] state, next_state;
reg [15:0] a, b;
reg [1:0] counter;


always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 2'd0;
        gcd <= 16'd0;
        done <= 1'b0;
        state <= 2'b00;
        next_state <= 2'b00;
        counter <= 2'b00;
    end
    else begin
        case(state)
            WAIT: begin
                if (start) begin
                    state <= CAL;
                end
                a <= inputa;
                b <= inputb;
                counter <= 2'd0;
                gcd <= 16'd0;
                done <= 1'b0;
            end
            CAL: begin
                if (a == 0 || b == 0) begin
                    state <= FINISH;
                    gcd <= a | b;
                    done <= 1'b1;
                end
                else begin
                    state <= CAL;
                    if (a > b) begin
                        a <= a - b;
                    end
                    else
                        b <= b - a;
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
end

endmodule