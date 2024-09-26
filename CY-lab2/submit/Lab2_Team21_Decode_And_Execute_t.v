`timescale 1ns/1ps

module Decode_And_Execute_t;

reg [4-1:0] rs = 4'b0000, rt = 4'b0000;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;

Decode_And_Execute ugate(.rd(rd), .rs(rs), .rt(rt), .sel(sel));

initial begin
    repeat (2**11) begin
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
                    $finish;
                end
            end
            3'b010: begin
                $display("%d | %d = %d", rs, rt, rd);
                if (rd != (rs | rt)) begin
                    $display("Error: rd != rs | rt, expeted: %d, got: %d", rs | rt, rd);
                    $finish;
                end
            end
            3'b011: begin
                $display("%d & %d = %d", rs, rt, rd);
                if (rd != (rs & rt)) begin
                    $display("Error: rd != rs & rt, expeted: %d, got: %d", rs & rt, rd);
                    $finish;
                end
            end
            3'b100: begin
                $display("%d >> 1 = %d", rt, rd);
                if (rd != {rt[0], rt[3], rt[2], rt[1]}) begin
                    $display("Error: rd != rt >> 1, expeted: %d, got: %d", {rt[0], rt[3], rt[2], rt[1]}, rd);
                    $finish;
                end
            end
            3'b101: begin
                $display("%d << 1 = %d", rs, rd);
                if (rd != {rs[2], rs[1], rs[0], rs[3]}) begin
                    $display("Error: rd != rs << 1, expeted: %d, got: %d", {rs[2], rs[1], rs[0], rs[3]}, rd);
                    $finish;
                end
            end
            3'b110: begin
                $display("%d < %d = %d", rs, rt, rd);
                if (rd != 4'b1010 + (rs < rt)) begin
                    $display("Error: rd != rs < rt, expeted: %d, got: %d", 4'b1010 + (rs < rt), rd);
                    $finish;
                end
            end
            3'b111: begin
                $display("%d == %d = %d", rs, rt, rd);
                if (rd != 4'b1110 + (rs == rt)) begin
                    $display("Error: rd != rs == rt, expeted: %d, got: %d", 4'b1110 + (rs == rt), rd);
                    $finish;
                end 
            end
            default: 
                $display("Error: unknown sel");
        endcase
    end
    $finish;
end

initial begin
    repeat (2**3) begin
        repeat (2**4) begin
            repeat (2**4) begin
                rs = rs + 1;
                #1;
            end
            rt = rt + 1;
        end
        sel = sel + 1;
    end
end

endmodule
