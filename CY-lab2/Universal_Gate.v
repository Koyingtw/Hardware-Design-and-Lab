module Universal_Gate(out, a, b);
input a, b;
output out;

wire _b;
not not1(_b, b);
and and1(out, a, _b);

endmodule