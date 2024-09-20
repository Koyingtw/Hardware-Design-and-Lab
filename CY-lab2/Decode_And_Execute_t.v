`timescale 1ns/1ps

module Decode_And_Execute_t;

reg [4-1:0] rs = 4'b000, rt = 4'b000;
reg [3-1:0] sel = 3'b000;
wire [4-1:0] rd;

Decode_And_Execute ugate(.rd(rd), .rs(rs), .rt(rt), .sel(sel));

initial begin
    while (16) begin
        #1;
        rs = rs + 1;
        rt = rt + 2;
        sel = sel + 3;

        #1;
        $display("rs=%d, rt=%d, sel=%d, rd=%d", rs, rt, sel, rd);
        case (sel)
            3'b000:
                if (rd != (rs - rt)) begin
                    $display("Error: rd != rs - rt, expeted: %d, got: %d", rs - rt, rd);
                end
            3'b001:
                if (rd != (rs + rt)) begin
                    $display("Error: rd != rs + rt, expeted: %d, got: %d", rs + rt, rd);
                end
            3'b010:
                if (rd != (rs | rt)) begin
                    $display("Error: rd != rs | rt, expeted: %d, got: %d", rs | rt, rd);
                end
            3'b011:
                if (rd != rs & rt) begin
                    $display("Error: rd != rs & rt, expeted: %d, got: %d", rs & rt, rd);
                end
            3'b100:
                if (rd != {rt[0], rt[3], rt[2], rt[1]}) begin
                    $display("Error: rd != rt >> 1, expeted: %d, got: %d", {rt[0], rt[3], rt[2], rt[1]}, rd);
                end
            3'b101:
                if (rd != {rs[2], rs[1], rs[0], rs[3]}) begin
                    $display("Error: rd != rs << 1, expeted: %d, got: %d", {rs[2], rs[1], rs[0], rs[3]}, rd);
                end
            3'b110:
                if (rd != 4'b1010 + (rs < rt)) begin
                    $display("Error: rd != rs < rt, expeted: %d, got: %d", 4'b1010 + (rs < rt), rd);
                end
            3'b111:
                if (rd != 4'b1110 + (rs == rt)) begin
                    $display("Error: rd != rs == rt, expeted: %d, got: %d", 4'b1110 + (rs == rt), rd);
                end 
            default: 
                $display("Error: unknown sel");
        endcase
        #1;
    end;
    $finish;
end

endmodule
