`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output [2:0] hw_light;
output [2:0] lr_light;

reg [6:0] cnt;
reg [2:0] state;

assign hw_light = {state == 3'd0, state == 3'd1, state != 3'd0 && state != 3'd1};
assign lr_light = {state == 3'd3, state == 3'd4, state != 3'd3 && state != 3'd4};

always @(posedge clk) begin
    if(!rst_n) begin
        state <= 3'd0;
        cnt <= 7'd1;
    end
    else begin
        case(state)
            3'd0: begin
                if(cnt >= 7'd70 && lr_has_car) begin
                    state <= 3'd1;
                    cnt <= 7'd1;
                end
                else begin
                    state <= state;
                    cnt <= cnt + 7'd1;
                end
            end
            3'd1: begin
                if(cnt == 7'd25) begin
                    state <= 3'd2;
                    cnt <= 7'd1;
                end
                else begin
                    state <= state;
                    cnt <= cnt + 7'd1;
                end
            end
            3'd2: begin
                if(cnt == 7'd1) begin
                    state <= 3'd3;
                    cnt <= 7'd1;
                end
                else begin
                    state <= state;
                    cnt <= cnt + 7'd1;
                end
            end
            3'd3: begin
                if(cnt == 7'd70) begin
                    state <= 3'd4;
                    cnt <= 7'd1;
                end
                else begin
                    state <= state;
                    cnt <= cnt + 7'd1;
                end
            end
            3'd4: begin
                if(cnt == 7'd25) begin
                    state <= 3'd5;
                    cnt <= 7'd1;
                end
                else begin
                    state <= state;
                    cnt <= cnt + 7'd1;
                end
            end
            3'd5: begin
                if(cnt == 7'd1) begin
                    state <= 3'd0;
                    cnt <= 7'd1;
                end
                else begin
                    state <= state;
                    cnt <= cnt + 7'd1;
                end
            end
        endcase
    end
end
endmodule