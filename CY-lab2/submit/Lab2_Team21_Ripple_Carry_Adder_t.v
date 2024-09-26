`timescale 1ns/1ps

module Ripple_Carry_Adder_t;

    reg [8-1:0] a, b;
    wire [8-1:0] sum;
    wire cout;
    reg cin;

    Ripple_Carry_Adder RCA (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );

    initial begin
        a = 0;
        b = 0;
        cin = 0;
        repeat(2)begin
            repeat(2**8) begin
                repeat(2**8) begin
                    #1;
                    $display("a: %d, b: %d, cin: %d, sum: %d, cout: %d", a, b, cin, sum, cout);
                    if (a + b + cin != sum) begin
                        $display("Error: %d + %d + %d != %d", a, b, cin, sum);
                        $finish;
                    end
                    a = a + 1;
                end
                b = b + 1;
            end
            cin = 1;
        end
        $finish;
    end
endmodule
