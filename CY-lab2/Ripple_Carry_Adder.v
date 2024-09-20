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