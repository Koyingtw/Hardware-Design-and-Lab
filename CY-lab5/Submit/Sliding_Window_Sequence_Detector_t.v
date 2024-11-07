`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector_t;
reg clk = 0, rst_n;
reg in;
wire dec;

always #5 clk = ~clk;

Sliding_Window_Sequence_Detector SWSD(clk, rst_n, in, dec);

initial begin
    rst_n = 0;
    in = 0;
    clk = 1;
    
    // match
    @(negedge clk)
        in = 1;
        rst_n = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 0;
    @(negedge clk) in = 0;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 0;
    @(negedge clk) in = 0;
    @(negedge clk) in = 1;
    @(negedge clk) in = 0;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 1;
    @(negedge clk) in = 0;
    @(negedge clk) in = 0;

    // mismatch
    // @(negedge clk) 
    //     in = 0;
    //     rst_n = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 1;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;
    // @(negedge clk) in = 0;

    $finish;
end

always @(posedge clk) begin
    // if(dec) begin
        #0.5
        $display("rst_n=%b in=%b dec=%b", rst_n, in, dec);
    // end
end

endmodule 