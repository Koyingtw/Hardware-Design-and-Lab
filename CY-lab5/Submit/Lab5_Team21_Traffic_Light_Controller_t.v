`timescale 1ns/1ps

module Traffic_Light_Controller_t;
reg clk = 1, rst_n;
reg lr_has_car;
wire [2:0] hw_light;
wire [2:0] lr_light;

always #10 clk = ~clk;

Traffic_Light_Controller TLC(clk, rst_n, lr_has_car, hw_light, lr_light);

initial begin
    rst_n = 1;
    lr_has_car = 0;
    #10
    rst_n = 0;
    #10
    @(negedge clk)
        rst_n = 1;

    @(negedge clk)
    @(negedge clk)
        lr_has_car = 1;

    repeat(2) @(negedge clk);
    
    // State C
    @(negedge clk);
    
    // State D
    repeat(3) @(negedge clk);
    
    // State E
    repeat(2) @(negedge clk);
    
    // State F
    @(negedge clk);
    
    // State A
    @(negedge clk);
    
    repeat(3) @(negedge clk);

    // repeat(3) @(negedge clk);
    // @(negedge clk)
    //     lr_has_car = 1;

    // repeat(2) @(negedge clk);
    // repeat(1) @(negedge clk);
    // repeat(3) @(negedge clk);
    // repeat(2) @(negedge clk);
    // repeat(1) @(negedge clk);

    $finish;
end

endmodule