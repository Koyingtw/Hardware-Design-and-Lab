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

    VendingMachine vending(clk, rst_n, Left, Center, Right, Top, Bottom, buy, nums, enable);

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


module VendingMachine(clk, rst_n, Left, Center, Right, Top, Bottom, buy, digit, enable);
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

module SevenSegment(
    output reg [6:0] display,
    output reg [3:0] digit,
    input wire [15:0] nums,
    input wire rst,
    input wire clk
    );
    
    reg [15:0] clk_divider;
    reg [3:0] display_num;
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            clk_divider <= 16'b0;
        end else begin
            clk_divider <= clk_divider + 16'b1;
        end
    end
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            display_num <= 4'b0000;
            digit <= 4'b1111;
        end else if (clk_divider == {16{1'b1}}) begin
            case (digit)
                4'b1110 : begin
                    display_num <= nums[7:4];
                    digit <= 4'b1101;
                end
                4'b1101 : begin
                    display_num <= nums[11:8];
                    digit <= 4'b1011;
                end
                4'b1011 : begin
                    display_num <= nums[15:12];
                    digit <= 4'b0111;
                end
                4'b0111 : begin
                    display_num <= nums[3:0];
                    digit <= 4'b1110;
                end
                default : begin
                    display_num <= nums[3:0];
                    digit <= 4'b1110;
                end				
            endcase
        end else begin
            display_num <= display_num;
            digit <= digit;
        end
    end
    
    always @ (*) begin
        case (display_num)
            0 : display = 7'b1000000;	//0000
            1 : display = 7'b1111001;   //0001                                                
            2 : display = 7'b0100100;   //0010                                                
            3 : display = 7'b0110000;   //0011                                             
            4 : display = 7'b0011001;   //0100                                               
            5 : display = 7'b0010010;   //0101                                               
            6 : display = 7'b0000010;   //0110
            7 : display = 7'b1111000;   //0111
            8 : display = 7'b0000000;   //1000
            9 : display = 7'b0010000;	//1001
            default : display = 7'b1111111;
        endcase
    end
    
endmodule

module KeyboardDecoder(
    output reg [511:0] key_down,
    output wire [8:0] last_change,
    output reg key_valid,
    inout wire PS2_DATA,
    inout wire PS2_CLK,
    input wire rst,
    input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
    parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key, next_key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state, next_state;
    reg been_ready, been_extend, been_break;
    reg next_been_ready, next_been_extend, next_been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
        .key_in(key_in),
        .is_extend(is_extend),
        .is_break(is_break),
        .valid(valid),
        .err(err),
        .PS2_DATA(PS2_DATA),
        .PS2_CLK(PS2_CLK),
        .rst(rst),
        .clk(clk)
    );
    
    OnePulse op (
        .signal_single_pulse(pulse_been_ready),
        .signal(been_ready),
        .clock(clk)
    );
    
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            state <= INIT;
            been_ready  <= 1'b0;
            been_extend <= 1'b0;
            been_break  <= 1'b0;
            key <= 10'b0_0_0000_0000;
        end else begin
            state <= next_state;
            been_ready  <= next_been_ready;
            been_extend <= next_been_extend;
            been_break  <= next_been_break;
            key <= next_key;
        end
    end
    
    always @ (*) begin
        case (state)
            INIT:            next_state = (key_in == IS_INIT) ? WAIT_FOR_SIGNAL : INIT;
            WAIT_FOR_SIGNAL: next_state = (valid == 1'b0) ? WAIT_FOR_SIGNAL : GET_SIGNAL_DOWN;
            GET_SIGNAL_DOWN: next_state = WAIT_RELEASE;
            WAIT_RELEASE:    next_state = (valid == 1'b1) ? WAIT_RELEASE : WAIT_FOR_SIGNAL;
            default:         next_state = INIT;
        endcase
    end
    always @ (*) begin
        next_been_ready = been_ready;
        case (state)
            INIT:            next_been_ready = (key_in == IS_INIT) ? 1'b0 : next_been_ready;
            WAIT_FOR_SIGNAL: next_been_ready = (valid == 1'b0) ? 1'b0 : next_been_ready;
            GET_SIGNAL_DOWN: next_been_ready = 1'b1;
            WAIT_RELEASE:    next_been_ready = next_been_ready;
            default:         next_been_ready = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_extend = (is_extend) ? 1'b1 : been_extend;
        case (state)
            INIT:            next_been_extend = (key_in == IS_INIT) ? 1'b0 : next_been_extend;
            WAIT_FOR_SIGNAL: next_been_extend = next_been_extend;
            GET_SIGNAL_DOWN: next_been_extend = next_been_extend;
            WAIT_RELEASE:    next_been_extend = (valid == 1'b1) ? next_been_extend : 1'b0;
            default:         next_been_extend = 1'b0;
        endcase
    end
    always @ (*) begin
        next_been_break = (is_break) ? 1'b1 : been_break;
        case (state)
            INIT:            next_been_break = (key_in == IS_INIT) ? 1'b0 : next_been_break;
            WAIT_FOR_SIGNAL: next_been_break = next_been_break;
            GET_SIGNAL_DOWN: next_been_break = next_been_break;
            WAIT_RELEASE:    next_been_break = (valid == 1'b1) ? next_been_break : 1'b0;
            default:         next_been_break = 1'b0;
        endcase
    end
    always @ (*) begin
        next_key = key;
        case (state)
            INIT:            next_key = (key_in == IS_INIT) ? 10'b0_0_0000_0000 : next_key;
            WAIT_FOR_SIGNAL: next_key = next_key;
            GET_SIGNAL_DOWN: next_key = {been_extend, been_break, key_in};
            WAIT_RELEASE:    next_key = next_key;
            default:         next_key = 10'b0_0_0000_0000;
        endcase
    end

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            key_valid <= 1'b0;
            key_down <= 511'b0;
        end else if (key_decode[last_change] && pulse_been_ready) begin
            key_valid <= 1'b1;
            if (key[8] == 0) begin
                key_down <= key_down | key_decode;
            end else begin
                key_down <= key_down & (~key_decode);
            end
        end else begin
            key_valid <= 1'b0;
            key_down <= key_down;
        end
    end

endmodule
