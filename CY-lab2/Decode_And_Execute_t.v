`timescale 1ns/1ps

module Decode_And_Execute_t;

reg [4-1:0] rs = 4'b000, rt = 4'b000;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;

Decode_And_Execute ugate(.rd(rd), .rs(rs), .rt(rt), .sel(sel));

initial begin
    repeat (8 * 5) begin
        #1;
        case (sel)
            3'b000: begin
                $display("%d - %d = %d", rs, rt, rd);
                if (rd != (rs - rt)) begin
                    $display("Error: rd != rs - rt, expeted: %d, got: %d", rs - rt, rd);
                end
            end
            3'b001: begin
                $display("%d + %d = %d", rs, rt, rd);
                if (rd != (rs + rt)) begin
                    $display("Error: rd != rs + rt, expeted: %d, got: %d", rs + rt, rd);
                end
            end
            3'b010: begin
                $display("%d | %d = %d", rs, rt, rd);
                if (rd != (rs | rt)) begin
                    $display("Error: rd != rs | rt, expeted: %d, got: %d", rs | rt, rd);
                end
            end
            3'b011: begin
                $display("%d & %d = %d", rs, rt, rd);
                if (rd != (rs & rt)) begin
                    $display("Error: rd != rs & rt, expeted: %d, got: %d", rs & rt, rd);
                end
            end
            3'b100: begin
                $display("%d >> 1 = %d", rt, rd);
                if (rd != {rt[0], rt[3], rt[2], rt[1]}) begin
                    $display("Error: rd != rt >> 1, expeted: %d, got: %d", {rt[0], rt[3], rt[2], rt[1]}, rd);
                end
            end
            3'b101: begin
                $display("%d << 1 = %d", rs, rd);
                if (rd != {rs[2], rs[1], rs[0], rs[3]}) begin
                    $display("Error: rd != rs << 1, expeted: %d, got: %d", {rs[2], rs[1], rs[0], rs[3]}, rd);
                end
            end
            3'b110: begin
                $display("%d < %d = %d", rs, rt, rd);
                if (rd != 4'b1010 + (rs < rt)) begin
                    $display("Error: rd != rs < rt, expeted: %d, got: %d", 4'b1010 + (rs < rt), rd);
                end
            end
            3'b111: begin
                $display("%d == %d = %d", rs, rt, rd);
                if (rd != 4'b1110 + (rs == rt)) begin
                    $display("Error: rd != rs == rt, expeted: %d, got: %d", 4'b1110 + (rs == rt), rd);
                end 
            end
            default: 
                $display("Error: unknown sel");
        endcase
        #1;
        sel = sel + 1;
        #1;
    end;
    $finish;
end

initial begin
    while (5) begin
        #24;
        rs = rs + 3;
        rt = rt + 5;
    end
end

endmodule
