`timescale 1ns/1ps

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;

XOR xor1(sum, a, b);
AND and1(cout, a, b);

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

