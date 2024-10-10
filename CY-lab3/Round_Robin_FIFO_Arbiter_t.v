`timescale 1ns/1ps

module Round_Robin_FIFO_Arbiter_t;

reg clk = 0, rst_n = 1;
reg [4-1:0] wen;
reg [8-1:0] a, b, c, d;
wire [8-1:0] dout;
wire valid;

parameter t = 5;

Round_Robin_FIFO_Arbiter arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);

always #t clk = !clk;

// initial begin
//     rst_n <= 1;
//     clk <= 0;
//     wen = 4'b0000;
//     #5 rst_n <= 0;
//     #5 rst_n <= 1;
//     repeat (10) begin
//         #(2 * t);
//         wen = $random;
//         if (wen[0]) a = $random;
//         else a = 0;
//         if (wen[1]) b = $random;
//         else b = 0;
//         if (wen[2]) c = $random;
//         else c = 0;
//         if (wen[3]) d = $random;
//         else d = 0;
//     end
//     #10 $finish;
// end

initial begin
    rst_n = 0;
    #(2*t);
    rst_n = 1;
end

reg x;

initial begin
    #(2*t);
    wen = 4'b1111;
    a = 87;
    b = 56;
    c = 9;
    d = 13;
    #(2*t);
    wen = 4'b1000;
    a = x;
    b = x;
    c = x;
    d = 85;
    #(2*t);
    wen = 4'b0100;
    a = x;
    b = x;
    c = 139;
    d = x;
    #(2*t);
    wen = 4'b0000;
    a = x;
    b = x;
    c = x;
    d = x;
    #(6*t);
    wen = 4'b0001;
    a = 51;
    b = x;
    c = x;
    d = x;
    #(2*t);
    wen = 4'b0000;
    a = x;
    b = x;
    c = x;
    d = x;
    #(5*t);

    repeat(100) begin
        wen = $random;
        a = $random;
        b = $random;
        c = $random;
        d = $random;
        #(2*t);
    end
    $finish;
end

endmodule
