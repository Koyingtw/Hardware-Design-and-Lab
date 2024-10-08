`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output reg [8-1:0] dout;
output wire error;

reg [8-1:0] mem [0:7];

reg [3-1:0] waddr, raddr;

reg started = 0;
reg empty = 1;
reg full = 0;
reg [3:0] count;

assign error = (started && (count == 0 && ren)) || (started && (count == 8 && !ren && wen));

always @(posedge clk) begin
    if (!rst_n) begin
        waddr <= 0;
        raddr <= 0;
        started <= 1;
        dout <= 0;
        count <= 0;
    end 
    else if (started) begin
        if (error) begin
            $display("Error: %d", error);
        end
        else if (ren || wen) begin
            // error <= 0;
            if (ren) begin
                dout <= mem[raddr];
                raddr <= raddr + 1;
                count <= count - 1;
                $display("Read: %d", mem[raddr]);
            end
            else if (wen) begin
                count <= count + 1;
                mem[waddr] <= din;
                waddr <= waddr + 1;
                $display("Write: %d", din);
            end
        end

    end
end

endmodule
