`timescale 1ps/1ps

module booth_multiplier(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire signed [3:0] a,
    input wire signed [3:0] b,
    output reg signed [7:0] p
);

// 狀態定義
localparam WAIT   = 2'b00;
localparam CAL    = 2'b01;
localparam FINISH = 2'b10;

// 內部寄存器
reg [1:0] state, next_state;
reg signed [7:0] multiplicand;    // 被乘數
reg signed [7:0] multiplier;      // 乘數
reg signed [7:0] acc, temp_acc;            // 累加器
reg [2:0] count;                 // 計數器
reg q_1;                         // multiplier的最低位之下一位
reg [1:0] finish_count;          // FINISH狀態計數器


// 主要運算邏輯
always @(posedge clk) begin
    if (!rst_n) begin
        multiplicand <= 4'b0;
        multiplier <= 4'b0;
        acc <= 8'b0;
        count <= 3'b0;
        q_1 <= 1'b0;
        p <= 8'b0;
        finish_count <= 2'b0;
        state <= WAIT;
    end 
    else begin
        case (state)
            WAIT: begin
                p <= 8'b0;
                if (start) begin
                    state <= CAL;
                    multiplicand <= {{4{a[3]}}, a};
                    multiplier <= {{4{b[3]}}, b};
                    acc <= 8'b0;
                    count <= 3'b0;
                    q_1 <= 1'b0;
                    finish_count <= 2'b0;
                end
                else begin
                    state <= WAIT;
                end
            end
            CAL: begin
                if (count == 3'd3) begin
                    state <= FINISH;
                    p <= acc;
                    finish_count <= 2'b0;
                end
                else begin
                    case ({multiplier[0], q_1})
                        2'b01: begin
                            $display("acc=%d + %d", acc, {{4{multiplicand[3]}}, multiplicand});
                            acc <= (acc + {{4{multiplicand[3]}}, multiplicand});
                        end
                        2'b10: begin
                            $display("acc=%d - %d", acc, {{4{multiplicand[3]}}, multiplicand});
                            acc <= (acc - {{4{multiplicand[3]}}, multiplicand});
                        end 
                        default: acc <= acc; // 2'b00 或 2'b11
                    endcase
                    
                    // 更新狀態
                    q_1 <= multiplier[0];
                    multiplier <= (multiplier >>> 1);
                    multiplicand <= (multiplicand <<< 1);
                    count <= count + 1'b1;
                    state <= CAL;
                end
            end
            
            FINISH: begin
                if (finish_count == 2'd1) begin
                    state <= WAIT;
                    finish_count <= 2'b0;
                end
                else begin
                    finish_count <= finish_count + 1'b1;
                    state <= FINISH;
                end
            end
        
        endcase
    end
end

endmodule