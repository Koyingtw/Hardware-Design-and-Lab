`timescale 1ns/1ps

module Multiplier_4bit_t;
reg [4-1:0] a, b;
wire [8-1:0] p;

Multiplier_4bit Multiplier_4bit(
    .a(a), 
    .b(b), 
    .p(p)
);

initial begin
    $dumpfile("Multiplier_4bit.vcd");
    $dumpvars(0, Multiplier_4bit_t);
    a = 4'b0000;
    b = 4'b0000;
    repeat (2 ** 4) begin
        #1
        a = a + 1;
        repeat (2 ** 4) begin
            #1
            b = b + 1;
            #1;
            $display("%d * %d = %d = %b", a, b, p, p);
            if (p != a * b) begin
                $display("Error: p != a * b, expeted: %d, got: %d", a * b, p);
            end
        end
    end
    #1 $finish;
end
endmodule
