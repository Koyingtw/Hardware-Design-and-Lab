module Display_Control(
    output wire [6:0] display,
    output wire [3:0] digit,
    output wire [3:0] enable,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire clk,
    input wire Left_in,
    input wire Center_in,
    input wire Right_in, 
    input wire Top_in, 
    input wire Bottom_in
    );

    wire Left_de, Center_de, Right_de, Top_de, Bottom_de;
    wire Left, Center, Right, Top, Bottom;
    wire rst_n;
    debounce Left_debounced (Left_de, Left_in, clk);
    debounce Center_debounced (Center_de, Center_in, clk);
    debounce Right_debounced (Right_de, Right_in, clk);
    debounce Top_debounced (Top_de, Top_in, clk);
    debounce Bottom_debounced (Bottom_de, Bottom_in, clk);

    onepulse Left_onepulse (Left_de, clk, Left);
    onepulse Center_onepulse (Center_de, clk, Center);
    onepulse Right_onepulse (Right_de, clk, Right);
    onepulse Top_onepulse (Top_de, clk, Top);
    onepulse Bottom_onepulse (Bottom_de, clk, Bottom);

    assign rst_n = !Top;
    

    
    parameter [8:0] KEY_CODES_A = 9'b0_0001_1100; // right_A => 1C
    parameter [8:0] KEY_CODES_S = 9'b0_0001_1011; // right_S => 1B
    parameter [8:0] KEY_CODES_D = 9'b0_0010_0011; // right_D => 23
    parameter [8:0] KEY_CODES_F = 9'b0_0010_1011; // right_F => 2B
    
    wire [15:0] nums;
    reg [3:0] buy;
    reg [9:0] last_key;
    
    wire shift_down;
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire been_ready;
        
    SevenSegment seven_seg (
        .display(display),
        .digit(digit),
        .nums(nums),
        .rst(rst),
        .clk(clk)
    );
        
    KeyboardDecoder key_de (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(been_ready),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );

    VendingMechine vending(clk, rst_n, Left, Center, Right, Top, Bottom, buy, nums, enable);

    always @ (posedge clk) begin
        if (key_down[last_change]) begin
            case (last_change)
                KEY_CODES_A : buy = 4'b1000;
                KEY_CODES_S : buy = 4'b0100;
                KEY_CODES_D : buy = 4'b0010;
                KEY_CODES_F : buy = 4'b0001;
                default : buy = 4'b0000;
            endcase
        end
        else begin
            buy = 4'b0000;
        end
    end
    
endmodule


module VendingMechine(clk, rst_n, Left, Center, Right, Top, Bottom, buy, digit, enable);
input clk, rst_n, Left, Center, Right, Top, Bottom;
input [3:0] buy;
output [3:0] enable;
output [15:0] digit;

reg [6:0] money;
reg canceling;
reg [31:0] counter;
wire buying;

assign enable[0] = (money >= 20 && !canceling);
assign enable[1] = (money >= 25 && !canceling);
assign enable[2] = (money >= 30 && !canceling);
assign enable[3] = (money >= 80 && !canceling);
assign buying = (buy[0] || buy[1] || buy[2] || buy[3]);

NumberDivide num_divide (
    .num(money),
    .digit(digit)
);

always @(posedge clk) begin
    if (!rst_n) begin
        money <= 0;
        canceling <= 0;
        counter <= 0;
    end
    else if (buying) begin
        if (buy[0] && enable[0]) begin
            money <= money - 20;
        end
        else if (buy[1] && enable[1]) begin
            money <= money - 25;
        end
        else if (buy[2] && enable[2]) begin
            money <= money - 30;
        end
        else if (buy[3] && enable[3]) begin
            money <= money - 80;
        end
        canceling <= 1;
    end
    else if (!canceling) begin
        if (Left) begin
            if (money + 5 < 100) begin
                money <= money + 5;
            end
            else begin
                money <= 100;
            end
        end 
        else if (Center) begin
            if (money + 10 < 100) begin
                money <= money + 10;
            end
            else begin
                money <= 100;
            end
        end
        else if (Right) begin
            if (money + 50 < 100) begin
                money <= money + 50;
            end
            else begin
                money <= 100;
            end
        end
        else begin
            money <= money;
            if (Bottom) begin
                canceling <= 1;
                counter <= 0;
            end
        end
    end
    else if (canceling) begin
        if (counter + 1 == 100000000) begin
            counter <= 0;
            money <= money - 5;
            if (money - 5 == 0) begin
                canceling <= 0;
            end
            else begin
                canceling <= 1;
            end
        end
        else begin
            counter <= counter + 1;
        end
    end
end

endmodule

module NumberDivide(num, digit);
input [6:0] num;
output [15:0] digit;

assign digit[3:0] = num[0] ? 4'd5 : 4'd0;
assign digit[7:4] = num < 10 ? 4'd10: (num == 100 ? 4'd0 : ((num >= 10) + (num >= 20) + 
(num >= 30) + (num >= 40) + (num >= 50) + (num >= 60) + (num >= 70) + 
(num >= 80) + (num >= 90)));
assign digit[11:8] = num == 100 ? 4'd1 : 4'd10;
assign digit[15:12] = 4'd10;

endmodule

module debounce (pb_debounced, pb, clk);
output pb_debounced; // signal of a pushbutton after being debounced
input pb; // signal from a pushbutton
input clk;
reg [3:0] DFF; // use shift_reg to filter pushbutton bounce
always @(posedge clk)
begin
DFF[3:1] <= DFF[2:0];
DFF[0] <= pb;
end
assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);
endmodule

module onepulse (PB_debounced, CLK, PB_one_pulse);
input PB_debounced;
input CLK;
output PB_one_pulse;
reg PB_one_pulse;
reg PB_debounced_delay;
always @(posedge CLK) begin
PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
PB_debounced_delay <= PB_debounced;
end
endmodule