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

module D_Flip_Flop(clk, d, q);
input clk;
input d;
output q;

wire _clk;
not n1(_clk, clk);

wire tmpq;

D_Latch Master(_clk, d, tmpq);
D_Latch Slave(clk, tmpq, q);

endmodule

module D_Latch(e, d, q);
input e;
input d;
output q;


wire _d, NAND1_out, NAND2_out, qn;

not n1(_d, d);
nand NAND1(NAND1_out, e, d);
nand NAND2(NAND2_out, e, _d);
nand NAND3(q, NAND1_out, qn);
nand NAND4(qn, NAND2_out, q);

endmodule