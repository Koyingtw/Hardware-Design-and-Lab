`timescale 1ns/1ps

module Multi_Bank_Memory_st;

reg clk;
reg ren, wen;
reg [11-1:0] waddr;
reg [11-1:0] raddr;
reg [8-1:0] din;
wire [8-1:0] dout;

parameter t = 10;

Multi_Bank_Memory uut (
    .clk(clk),
    .ren(ren),
    .wen(wen),
    .waddr(waddr),
    .raddr(raddr),
    .din(din),
    .dout(dout)
);


always begin
    #t clk = ~clk;
end

reg [8-1:0] mem[2048-1:0];

always @(posedge clk) begin
    #(t / 4);
    if (wen && (!ren || (waddr[10:7] != raddr[10:7]))) begin
        mem[waddr] <= din;
        $display("time = %t, write: ren = %d, wen = %d, raddr = %d, waddr = %d, din = %d, dout = %d, mem[raddr] = %d, mem[waddr] = %d", $time, ren, wen, raddr, waddr, din, dout, mem[raddr], mem[waddr]);
    end
    if (ren) begin
        $display("time = %t, ren = %d, wen = %d, raddr = %d = %b, waddr = %d = %b, din = %d, dout = %d, mem[raddr] = %d, mem[waddr] = %d", $time, ren, wen, raddr, raddr, waddr, waddr, din, dout, mem[raddr], mem[waddr]);
        $display("read bank = %b, write bank = %b", raddr[10:7], waddr[10:7]);
        if (mem[raddr] != dout) begin
            $display("Error: dout != mem[raddr]");
            #(100 * t);
            $finish;
        end
        #(t / 4);
    end
end

reg[11:0] i;

initial begin
    
    clk = 0;
    ren = 0;
    wen = 0;
    waddr = 0;
    raddr = 0;
    din = 0;
    // #t
    for (i = 0; i < 2048; i = i + 1) begin
        #(4*t)
        mem[i] <= i[7:0];
        waddr <= i;
        raddr <= i;
        din <= i[7:0];
        wen <= 1;
        ren <= 0;
        #(4*t)
        wen <= 0;
        ren <= 1;
        #(4*t)
        wen <= 1;
        ren <= 1;
        #(4*t)
        wen <= 0;
        ren <= 0;
    end

    ren <= 1;
    wen <= 1;
    din <= 0;
    repeat(2**7) begin
        repeat(2**7) begin
            repeat(2**7) begin
                #(4 * t);
                raddr <= raddr + 3;
            end
            waddr <= waddr + 7;
        end
        din <= din + 5;
    end
    $display("Well done");
    $finish;
end


endmodule