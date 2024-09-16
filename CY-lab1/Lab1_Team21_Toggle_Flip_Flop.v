`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;

wire xorout, _rst_n, qq;
not n1(_rst_n, rst_n);


XOR xor1(xorout, t, q);
and(andout, xorout, rst_n);
D_Flip_Flop DFF(clk, andout, q);

// and a1(q, qq, rst_n);

endmodule

module XOR(out, a, b);
input a, b;
output out;

wire _a, _b, a_b, _ab;
not n1(_a, a);
not n2(_b, b);
and a1(a_b, a, _b);
and a2(_ab, _a, b);
or o1(out, a_b, _ab);

endmodule