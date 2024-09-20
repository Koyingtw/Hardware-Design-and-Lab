module Universal_Gate(out, a, b);
input a, b;
output out;

wire _b;
not not1(_b, b);
and and1(out, a, _b);

endmodule

module NOT2(out, in);
input in;
output out;

Universal_Gate ugate(out, 1'b1, in);
endmodule

module NAND(out, a, b);
input a, b;
output out;

wire _b, uout;
not not1(_b, b);
Universal_Gate ugate(uout, a, _b);
not not2(out, uout);
// nand nand1(out, a, b);

endmodule