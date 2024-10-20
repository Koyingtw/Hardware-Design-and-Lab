`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output reg [3:0] dout;
output reg hit;

reg [7:0] mem[15:0];
reg started = 0;
reg [15:0] enable;

assign next_hit = (h != 16'd0);
wire [15:0] h;
Comparator_Array CA0(din, enable[0], mem[0], h[0]);
Comparator_Array CA1(din, enable[1], mem[1], h[1]);
Comparator_Array CA2(din, enable[2], mem[2], h[2]);
Comparator_Array CA3(din, enable[3], mem[3], h[3]);
Comparator_Array CA4(din, enable[4], mem[4], h[4]);
Comparator_Array CA5(din, enable[5], mem[5], h[5]);
Comparator_Array CA6(din, enable[6], mem[6], h[6]);
Comparator_Array CA7(din, enable[7], mem[7], h[7]);
Comparator_Array CA8(din, enable[8], mem[8], h[8]);
Comparator_Array CA9(din, enable[9], mem[9], h[9]);
Comparator_Array CA10(din, enable[10], mem[10], h[10]);
Comparator_Array CA11(din, enable[11], mem[11], h[11]);
Comparator_Array CA12(din, enable[12], mem[12], h[12]);
Comparator_Array CA13(din, enable[13], mem[13], h[13]);
Comparator_Array CA14(din, enable[14], mem[14], h[14]);
Comparator_Array CA15(din, enable[15], mem[15], h[15]);

wire [3:0] out;
Priority_Encoder PE(h, out);

always @(posedge clk) begin
    if(!started) begin
        started <= 1;
        enable <= 16'd0;
        dout <= 4'd0;
        hit <= 1'd0;
    end
    if(ren) begin
        if(next_hit) begin
            dout <= out;
            hit <= 1'd1;
        end
        else begin
            dout <= 4'd0;
            hit <= 1'd0;
        end
    end
    else begin
        if(!ren && wen) begin
            mem[addr] <= din;
            enable[addr] <= 1'd1;
        end
        dout <= 4'd0;
        hit <= 1'd0;
    end
end

endmodule

module Comparator_Array(din, enable, mem, hit);
input [7:0] din, mem;
input enable;
output hit;

assign hit = (din == mem) && enable;

endmodule

module Priority_Encoder(hit, dout);
input [15:0] hit;
output reg [3:0] dout;

always @(*) begin
    if(hit[15]) dout <= 4'd15;
    else if(hit[14]) dout <= 4'd14;
    else if(hit[13]) dout <= 4'd13;
    else if(hit[12]) dout <= 4'd12;
    else if(hit[11]) dout <= 4'd11;
    else if(hit[10]) dout <= 4'd10;
    else if(hit[9]) dout <= 4'd9;
    else if(hit[8]) dout <= 4'd8;
    else if(hit[7]) dout <= 4'd7;
    else if(hit[6]) dout <= 4'd6;
    else if(hit[5]) dout <= 4'd5;
    else if(hit[4]) dout <= 4'd4;
    else if(hit[3]) dout <= 4'd3;
    else if(hit[2]) dout <= 4'd2;
    else if(hit[1]) dout <= 4'd1;
    else dout <= 4'd0;
end

endmodule