`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output [8-1:0] dout;
output reg error;

wire [3-1:0] addr;
wire [7:0] memout;
assign addr = (ren) ? raddr : waddr;

// reg [8-1:0] mem [0:7];
Memory_8 mem(clk, ren & (~error), wen & (~error), addr, din, memout);

reg [3-1:0] waddr, raddr;

reg started = 0;
reg [3:0] count;

// assign error = (started && (count == 0 && ren)) || (started && (count == 8 && !ren && wen));
assign dout = rst_n ? memout : 0;

always @(posedge clk) begin
    if (!rst_n) begin
        waddr <= 0;
        raddr <= 0;
        count <= 0;
        started <= 1;
        error <= 0;
    end 
    else if (started) begin     
        error <= (started && (count == 0 && ren)) || (started && (count == 8 && !ren && wen)); 
        if (!((started && (count == 0 && ren)) || (started && (count == 8 && !ren && wen)))) begin
            if (ren) begin
                raddr <= raddr + 1;
                count <= count - 1;
            end
            else if (wen) begin
                count <= count + 1;
                waddr <= waddr + 1;
            end
            else begin
                count <= count;
                raddr <= raddr;
                waddr <= waddr;
            end
        end
        else begin
            count <= count;
            raddr <= raddr;
            waddr <= waddr;
        end
    end
end

endmodule

module Memory_8 (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [3-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout;

reg [8-1:0] mem [8-1:0];

always @(posedge clk) begin
    if (ren) begin
        dout <= mem[addr];
    end
    else if (wen) begin
        mem[addr] <= din;
        dout <= 0;
    end
    else begin
        dout <= 0;
    end

end

endmodule