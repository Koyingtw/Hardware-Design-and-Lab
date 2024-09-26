`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit_t;
reg [8-1:0] a, b;
reg c0;
wire [8-1:0] s;
wire c8;


Carry_Look_Ahead_Adder_8bit CLA(
    .a(a), 
    .b(b), 
    .c0(c0), 
    .s(s),
    .c8(c8)
);

initial begin
    c0 = 1'b0;
    a = 8'b00000000;
    b = 8'b00000000;
    repeat (2) begin
        repeat(2**8) begin
            repeat(2**8) begin
            #1;
            $display("a: %b, b: %b, c0: %b, s: %b, c8: %b", a, b, c0, s, c8);
            if (a + b + c0 != s) begin
                $display("Error: %b + %b + %b != %b", a, b, c0, s);
                $finish;
            end
            a = a + 1;
            end
            b = b + 1;
        end
        c0 = 1'b1;
    end
    #1;
    $finish;
end
endmodule

