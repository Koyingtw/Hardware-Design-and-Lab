`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, cin, s, cout);
input [8-1:0] a, b;
input cin;
output[8-1:0] s;
output cout;

wire [3-1:0] c13, c57;
wire [8-1:0] c;
wire c4;



wire [4-1:0] a1, a2, b1, b2;
AND and1(a1[0], a[0], 1'b1);
AND and2(a1[1], a[1], 1'b1);
AND and3(a1[2], a[2], 1'b1);
AND and4(a1[3], a[3], 1'b1);
AND and5(a2[0], a[4], 1'b1);
AND and6(a2[1], a[5], 1'b1);
AND and7(a2[2], a[6], 1'b1);
AND and8(a2[3], a[7], 1'b1);

AND and9(b1[0], b[0], 1'b1);
AND and10(b1[1], b[1], 1'b1);
AND and11(b1[2], b[2], 1'b1);
AND and12(b1[3], b[3], 1'b1);
AND and13(b2[0], b[4], 1'b1);
AND and14(b2[1], b[5], 1'b1);
AND and15(b2[2], b[6], 1'b1);
AND and16(b2[3], b[7], 1'b1);



wire [4-1:0] p1, p2, g1, g2;
PGGenerator_4bit PG1(
    .a(a1),
    .b(b1),
    .p(p1),
    .g(g1)
);

PGGenerator_4bit PG2(
    .a(a2),
    .b(b2),
    .p(p2),
    .g(g2)
);



Carry_Look_Ahead_Adder_2bit CLA1(
    .c0(cin),
    .g1(g1),
    .p1(p1),
    .g2(g2),
    .p2(p2),
    .c4(c4),
    .c8(cout)
);


// cal c
Carry_Look_Ahead_Generator_4bit RCA1(
    .p(p1),
    .g(g1),
    .cin(cin),
    .c(c13)
);

Carry_Look_Ahead_Generator_4bit RCA2(
    .p(p2),
    .g(g2),
    .cin(c4),
    .c(c57)
);



// debug

// assign s[0] = a[1];
// cal s
// assign s[4] = 1'b0;
// assign s[5] = 1'b0;
// assign s[6] = 1'b0;
// assign s[7] = 1'b0;
ADDER ADD1(a[0], b[0], cin, s[0]);
ADDER ADD2(a[1], b[1], c13[0], s[1]);
ADDER ADD3(a[2], b[2], c13[1], s[2]);
ADDER ADD4(a[3], b[3], c13[2], s[3]);
ADDER ADD5(a[4], b[4], c4, s[4]);
ADDER ADD6(a[5], b[5], c57[0], s[5]);
ADDER ADD7(a[6], b[6], c57[1], s[6]);
ADDER ADD8(a[7], b[7], c57[2], s[7]); // have problem
endmodule

module PGGenerator_4bit(a, b, p, g);
    input [4-1:0] a, b;
    output [4-1:0] g, p;

    AND and1(g[0], a[0], b[0]);
    AND and2(g[1], a[1], b[1]);
    AND and3(g[2], a[2], b[2]);
    AND and4(g[3], a[3], b[3]);

    XOR xor1(p[0], a[0], b[0]);
    XOR xor2(p[1], a[1], b[1]);
    XOR xor3(p[2], a[2], b[2]);
    XOR xor4(p[3], a[3], b[3]);
endmodule

module Carry_Look_Ahead_Generator_4bit(p, g, cin, c);
    input [4-1:0] p, g;
    input cin;

    output [3-1:0] c;

    // c[0]
    wire P0C0;
    AND p0c0(P0C0, p[0], cin);
    OR or1(c[0], g[0], P0C0);

    // c[1]
    wire P1P0;
    wire c1comp1, c1comp2;
    wire P1G0;
    AND p1p0(P1P0, p[1], p[0]);
    AND p1p0c0(c1comp2, P1P0, cin);
    AND p1g0(P1G0, p[1], g[0]);
    OR or2(c1comp1, g[1], P1G0);
    OR or3(c[1], c1comp1, c1comp2);

    // c[2]
    wire P2G1; // also c2comp1
    AND p2g1(P2G1, p[2], g[1]);
    wire c2comp2, P0G0;
    AND p0g0(P1G0, p[1], g[0]);
    AND p2p1p0(c2comp2, p[2], P1G0);
    wire P2P1;
    AND p2p1(P2P1, p[2], p[1]);
    wire c2comp3;
    AND p2p1p0c0(c2comp3, P2P1, P0C0);
    wire gc2comp1;
    OR or4(gc2comp1, g[2], P2G1);
    wire c2comp23;
    OR or5(c2comp23, c2comp2, c2comp3);
    OR or6(c[2], gc2comp1, c2comp23);
endmodule

module Carry_Look_Ahead_Adder_2bit(c0, g1, p1, g2, p2, c4, c8);
    input c0;
    input [3:0] g1, p1, g2, p2;
    output c4, c8;

    wire gp1, gp2, gg1, gg2;
    wire P01, P23;
    AND and1(P01, p1[0], p1[1]);
    AND and2(P23, p1[2], p1[3]);
    AND and3(gp1, P01, P23);

    wire P45, P67;
    AND and4(P45, p2[0], p2[1]);
    AND and5(P67, p2[2], p2[3]);
    AND and6(gp2, P45, P67);

    wire G2P3, G1P3P2, P3P2, G0P3P2P1, G0P3, P2P1;
    AND and7(G2P3, g1[2], p1[3]);
    AND and8(P3P2, p1[3], p1[2]);
    AND and9(G1P3P2, g1[1], P3P2);
    AND and10(G0P3, g1[0], p1[3]);
    AND and11(P2P1, p1[2], p1[1]);
    AND and12(G0P3P2P1, G0P3, P2P1);
    wire comp12, comp34;
    OR or1(comp12, g1[3], G2P3);
    OR or2(comp34, G1P3P2, G0P3P2P1);
    OR or3(gg1, comp12, comp34);

    wire G6P7, G5P7P6, P7P6, G4P7P6P5, G4P7, P6P5;
    AND and13(G6P7, g2[2], p2[3]);
    AND and14(P7P6, p2[3], p2[2]);
    AND and15(G5P7P6, g2[1], P7P6);
    AND and16(G4P7, g2[0], p2[3]);
    AND and17(P6P5, p2[2], p2[1]);
    AND and18(G4P7P6P5, G4P7, P6P5);
    wire comp56, comp67;
    OR or4(comp56, g2[3], G6P7);
    OR or5(comp67, G5P7P6, G4P7P6P5);
    OR or6(gg2, comp56, comp67);

    wire tmp1, tmp2;
    AND and19(tmp1, gp1, c0);
    OR or7(c4, tmp1, gg1);
    AND and20(tmp2, gp2, c4);
    OR or8(c8, tmp2, gg2);
endmodule

module ADDER(a, b, cin, s);
input a, b;
input cin;
output s;

wire tmp;
XOR xor1(tmp, a, b);
XOR xor2(s, tmp, cin);
endmodule