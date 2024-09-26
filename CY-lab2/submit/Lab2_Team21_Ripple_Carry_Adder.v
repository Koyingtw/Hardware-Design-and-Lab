`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output cout;
output [8-1:0] sum;

wire [7:0] C;

Full_Adder fa0(a[0], b[0], cin, C[0], sum[0]);
Full_Adder fa1(a[1], b[1], C[0], C[1], sum[1]);
Full_Adder fa2(a[2], b[2], C[1], C[2], sum[2]);
Full_Adder fa3(a[3], b[3], C[2], C[3], sum[3]);
Full_Adder fa4(a[4], b[4], C[3], C[4], sum[4]);
Full_Adder fa5(a[5], b[5], C[4], C[5], sum[5]);
Full_Adder fa6(a[6], b[6], C[5], C[6], sum[6]);
Full_Adder fa7(a[7], b[7], C[6], cout, sum[7]);
endmodule

module Ripple_Carry_Adder_4bit(a, b, cin, cout, sum);
input [4-1:0] a, b;
input cin;
output cout;
output [4-1:0] sum;

wire [3:0] C;

Full_Adder fa0(a[0], b[0], cin, C[0], sum[0]);
Full_Adder fa1(a[1], b[1], C[0], C[1], sum[1]);
Full_Adder fa2(a[2], b[2], C[1], C[2], sum[2]);
Full_Adder fa3(a[3], b[3], C[2], cout, sum[3]);
endmodule


module Full_Adder (a, b, cin, cout, sum);
    input a, b, cin;
    output cout, sum;
    wire sum1, sum2;
    wire car1;
    XOR xor1(sum1, a, b);
    XOR xor2(sum, sum1, cin);
    Majority maj1(a, b, cin, cout);
endmodule

module NAND(out, a, b);
    input a, b;
    output out;
    nand nand1(out, a, b);
endmodule

module AND(out, a, b);
input a, b;
output out;
wire nand_out1, nand_out2;

NAND nand1(nand_out1, a, b);
NAND nand2(nand_out2, a, b);
NAND nand3(out, nand_out1, nand_out2);
endmodule

module OR(out, a, b);
input a, b;
output out;

wire a1, a2;
wire b1, b2;


wire nandout1, nandout2;
NAND nand1(nandout1, a, a);
NAND nand2(nandout2, b, b);
NAND nand3(out, nandout1, nandout2);

endmodule

module NOT(out, a);
input a;
output out;

NAND nand1(out, a, a);
endmodule

module NOR(out, a, b);
input a, b;
output out;

wire orout;
OR or1(orout, a, b);
NOT not1(out, orout);

endmodule

module XOR(out, a, b); // a_b or _ab
input a, b;
output out;

wire _a, _b, a_b, _ab;
NOT not1(_a, a);
NOT not2(_b, b);
AND and1(a_b, a, _b);
AND and2(_ab, _a, b);
OR or1(out, a_b, _ab);
endmodule

module XNOR(out, a, b); 
input a, b;
output out;

wire xorout;
XOR xor1(xorout, a, b);
NOT not1(out, xorout);
endmodule

`timescale 1ns/1ps

module Majority(a, b, c, out);
input a, b, c;
output out;

wire and1out, and2out, and3out;
AND and1(and1out, a, b);
AND and2(and2out, a, c);
AND and3(and3out, b, c);

wire or1out;
OR or1(or1out, and1out, and2out);
OR or2(out, or1out, and3out);

endmodule