`timescale 1ns/1ps

module Display_Control_t;
reg [4-1:0] rs, rt;
reg [3-1:0] sel;

wire [7-1:0] seg;
wire [4-1:0] an;

Display_Control DC(
    .rs(rs), 
    .rt(rt), 
    .sel(sel), 
    .seg(seg),
    .an(an)
);

initial begin
    $dumpfile("Display_Control.vcd");
    $dumpvars(0, Display_Control_t);
    rs = 4'b0000;
    rt = 4'b0000;
    sel = 3'b000;
    repeat (2 ** 4) begin
        #1
        rs = rs + 1;
        repeat (2 ** 4) begin
            #1
            rt = rt + 1;
            repeat (2 ** 3) begin
                #1
                sel = sel + 1;
                #1;
                $display("rs = %d, rt = %d, sel = %d, seg = %b, an = %b", rs, rt, sel, seg, an);
            end
        end
    end
        #1      
        $display("rs = %d, rt = %d, sel = %d, seg = %b, an = %b", rs, rt, sel, seg, an);
    #1 $finish;
end
endmodule