`timescale 1ns/1ps

module Display_Control_t;

reg clk, rst_n, enable, flip;
reg [3:0] min, max;

wire direction;
wire [3:0] an;
wire [6:0] seg;
wire [3:0] digit;

reg [15:0] SW;

Display_Control DC(
    .SW(SW),
    .clk(clk),
    .DOWN(flip),
    .UP(~rst_n),
    .seg_out(seg),
    .an(an)
);

always begin
    #1 clk = ~clk;
end

always @(posedge clk) begin
    SW[15] = enable;
    SW[14] = max[3];
    SW[13] = max[2];
    SW[12] = max[1];
    SW[11] = max[0];
    SW[10] = min[3];
    SW[9] = min[2];
    SW[8] = min[1];
    SW[7] = min[0];    
end         


initial begin
    clk <= 0;
    rst_n <= 1;
    enable <= 1;
    flip <= 0;
    min <= 0;
    max <= 15;
    #5
    rst_n <= 0;
    #10
    rst_n <= 1;
    #10000;
    $finish;
end

endmodule

