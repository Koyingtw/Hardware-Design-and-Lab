`timescale 1ps/1ps

module Universal_Gate_t;

reg a, b;
wire out;
wire _out;
wire nandout;

Universal_Gate ugate(out, a, b);
NOT2 not1(_out, out);
NAND nand1(nandout, a, b);

initial begin
    a = 0; b = 0;
    #1 a = 0; b = 1;
    #1 a = 1; b = 0;
    #1 a = 1; b = 1;
    #1 $finish;
end

endmodule