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
    $dumpfile("CLA.vcd");
    $dumpvars(0, Carry_Look_Ahead_Adder_8bit_t);
    c0 = 1'b0;
    a = 8'b00000000;
    b = 8'b00000000;
    repeat (30) begin
        #1
        a = a + 5;
        b = b + 7;
        c0 = c0 + 1;
        #1;
        $display("%d + %d + %d = %d, c8 = %d", c0, a, b, s, c8);
        if (s != a + b + c0) begin
            $display("Error: s != a + b, expeted: %d, got: %d", a + b, s);
        end
        
        if (c8 != ((a + b + c0) / 256)) begin
            $display("Error: c8 != a[7] + b[7], expeted: %d, got: %d", a[7] + b[7], c8);
        end
    end
    #1 $finish;
end
endmodule

