`timescale 1ns/1ps

module FIFO_8_example;
reg clk;
reg rst_n;
reg wen, ren;
reg [8-1:0] din;
wire [8-1:0] dout;
wire error;

reg started = 0;

FIFO_8 FIFO_8(clk, rst_n, wen, ren, din, dout, error);

always begin
    #1 clk = ~clk;
end

initial begin
    rst_n = 0;

    #2 rst_n = 1;
end

reg [3:0] count = 0;

initial begin
    clk = 0;
    wen = 0;
    ren = 1;
    din = 0;
    #4
    din = 56;
    ren = 0;
    wen = 1;
    #2
    din = 11;
    #2
    din = 42;
    #2
    din = 10;
    #2
    din = 23;
    #2
    din = 20;
    #2
    din = 6;
    #2
    din = 85;
    #2
    din = 45;
    ren = 1;
    #2
    din = 12;
    ren = 0;
    #2
    din = 77;
    #2
    
    $finish;
end

endmodule

// systemverilog
// `timescale 1ns/1ps

// module FIFO_8_st;
// reg clk;
// reg rst_n;
// reg wen, ren;
// reg [8-1:0] din;
// wire [8-1:0] dout;
// wire error;

// reg started = 0;

// reg [8-1:0] queue[$];

// FIFO_8 FIFO_8(clk, rst_n, wen, ren, din, dout, error);

// always begin
//     #5 clk = ~clk;
// end

// initial begin
//     #10 rst_n = 0;

//     #20 rst_n = 1;
// end

// reg [3:0] count = 0;

// always @(posedge clk) begin
//     if (rst_n == 0) begin
//         started <= 1;
//     end    

//     #1;
//     // display time
    
//     $display("%t: count = %d", $time, count);

//     if (started) begin
//         if (ren) begin
//             if (queue.size() == 0) begin
//                 if (error != 1) begin
//                     $display("Error: empty, error should be 1");
//                     #10;
//                     $finish;
//                 end
//             end
//             else begin
//                 count = count - 1;
//                 if (dout != queue.pop_front()) begin
//                     $display("Error: dout != queue.pop_front()");
//                     #10;
//                     $finish;
//                 end
//             end
//         end 
//         else if (wen) begin
//             if (queue.size() == 8) begin
//                 if (error != 1) begin
//                     $display("Error: full, error should be 1");
//                     #10;
//                     $finish;
//                 end
//             end
//             else begin
//                 count = count + 1;
//                 queue.push_back(din);
//             end
//         end
//     end
// end

// initial begin
//     clk = 0;
//     rst_n = 1;
//     wen = 0;
//     ren = 0;
//     din = 0;
//     started = 0;
//     #20
//     repeat (2**10) begin
//         #10;
//         wen = {$random} % 2;
//         ren = {$random} % 2;
//         din = {$random} % 256;

//     end
//     $finish;
// end

// endmodule
