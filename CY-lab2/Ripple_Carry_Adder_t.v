`timescale 1ns/1ps

module Ripple_Carry_Adder_t;

    reg [8-1:0] a = 0, b = 0;
    wire [8-1:0] sum;
    wire cout;
    reg cin = 0;

    Ripple_Carry_Adder RCA (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );

    initial begin
        repeat(10) begin
            #1;
            if (a + b + cin != sum) begin
                $display("Error: %d + %d + %d != %d", a, b, cin, sum);
            end
            a = a + 23;
            b = b + 17;
        end
        $finish;
    end

    // initial begin
    //     for (b = 0; b < 256; b = b + 25) begin
    //         #1;
    //         if ((a + b + cin) != sum) begin
    //             $display("Error: %d + %d + %d = %d != %d", a, b, cin, a + b + cin, sum);
    //         end
    //         cin = ^cin;
    //     end
    //     $finish;
    // end
    
endmodule
