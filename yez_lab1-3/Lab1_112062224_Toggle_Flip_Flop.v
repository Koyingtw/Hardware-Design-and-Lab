`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;

wire xor_out, and_out;

XOR x1(xor_out, q, t);
and a1(and_out, rst_n, xor_out);

D_Flip_Flop DFF(clk, and_out, q);

endmodule

module XOR(out, a, b);
input a, b;
output out;

wire a_b, _ab, _a, _b;
not n1(_a, a);
not n2(_b, b);

and a1(a_b, a, _b);
and a2(_ab, _a, b);
or o1(out, a_b, _ab);

endmodule

module D_Flip_Flop(clk, d, q);
    input clk;
    input d;
    output q;

    wire w1, _clk;
    not(_clk, clk);
    D_Latch D1(_clk, d, w1);
    D_Latch D2(clk, w1, q);

endmodule

module D_Latch(e, d, q);
    input e;
    input d;
    output q;

    wire _d;
    not(_d, d);

    wire w1, w2;
    nand(w1, e, d);
    nand(w2, e, _d);

    wire _q;
    nand(q, w1, _q);
    nand(_q, w2, q);


endmodule