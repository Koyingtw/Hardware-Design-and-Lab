`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [2-1:0] out;
output reg [3-1:0] state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg started = 1'b0;

always @(posedge clk) begin

    if ((!rst_n) && (!started)) begin
        state <= S0;
        started <= 1'b1;
        out <= 2'b11;
    end

    else if (started) begin
        case(state)
            S0: begin
                if (in) begin
                    state <= S2;
                    out <= 2'b11;
                end
                else begin
                    state <= S1;
                    out <= 2'b01;
                end
            end
            S1: begin
                if (in) begin
                    state <= S5;
                    out <= 2'b00;
                end
                else begin
                    state <= S4;
                    out <= 2'b10;
                end
            end
            S2: begin
                if (in) begin
                    state <= S3;
                    out <= 2'b10;
                end
                else begin
                    state <= S1;
                    out <= 2'b01;
                end
            end
            S3: begin
                if (in) begin
                    state <= S0;
                    out <= 2'b11;
                end
                else begin
                    state <= S1;
                    out <= 2'b01;
                end
            end
            S4: begin
                if (in) begin
                    state <= S5;
                    out <= 2'b00;
                end
                else begin
                    state <= S4;
                    out <= 2'b10;
                end
            end
            S5: begin
                if (in) begin
                    state <= S0;
                    out <= 2'b11;
                end
                else begin
                    state <= S3;
                    out <= 2'b10;
                end
            end
        endcase
    end

end

endmodule
