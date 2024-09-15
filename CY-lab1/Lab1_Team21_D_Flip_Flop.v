`timescale 1ns/1ps

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