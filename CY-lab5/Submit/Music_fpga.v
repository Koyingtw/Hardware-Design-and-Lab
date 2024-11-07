// *******************************
// PmodAMP2_Demo_1: Piano
// TOP module
// ********************************

module TOP (
    input clk,
    input reset,
	output pmod_1,	//AIN
	output pmod_2,	//GAIN
	output pmod_4,	//SHUTDOWN_N
	inout wire PS2_DATA,
    inout wire PS2_CLK
);
	
wire [31:0] freq;
assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on
	
reg [31:0] counter;
reg [2:0] tone;
reg [3:0] height;
reg fast;
reg direction;

wire [511:0] key_down;
wire [8:0] last_change;
wire been_ready;

parameter [8:0] KEY_CODES_W = 9'b0_0001_1101; // W => 1D
parameter [8:0] KEY_CODES_S = 9'b0_0001_1011; // S => 1B
parameter [8:0] KEY_CODES_R = 9'b0_0010_1101; // R => 2D
parameter [8:0] KEY_CODES_ENTER = 9'b0_0101_1010;


KeyboardDecoder key_de (
	.key_down(key_down),
	.last_change(last_change),
	.key_valid(been_ready),
	.PS2_DATA(PS2_DATA),
	.PS2_CLK(PS2_CLK),
	.rst(rst),
	.clk(clk)
);

always @(posedge clk) begin
	if (key_down[KEY_CODES_ENTER]) begin
		counter <= 0;
		tone <= 0;
		height <= 4;
		direction <= 1;
		fast = 0;
	end
	else if (been_ready && key_down[KEY_CODES_W]) begin
		direction <= 1;
	end
	else if (been_ready && key_down[KEY_CODES_S]) begin
		direction <= 0;
	end
	else if (been_ready && key_down[KEY_CODES_R]) begin
		fast = ~fast;
	end
	if (!key_down[KEY_CODES_ENTER]) begin
		if (counter == 32'd100_000_000 || (counter == 32'd50_000_000 && fast)) begin
			counter <= 0;
			if (direction) begin
				if (tone == 3'd6) begin
					if (height == 4'd8) begin
						height <= height;
						tone <= tone;
					end
					else begin
						tone <= 0;
						height <= height + 1;
					end
				end
				else begin
					if (height != 4'd8)
						tone <= tone + 1;
					else
						tone <= tone;
					height <= height;
				end
			end
			else begin
				if (tone == 3'd0) begin
					if (height == 4'd4) begin
						height <= height;
						tone <= tone;
					end
					else begin
						tone <= 3'd6;
						height <= height - 1;
					end
				end
				else begin
					tone <= tone - 1;
					height <= height;
				end
			end
		end
		else begin
			counter <= counter + 1;
		end
	end
end

Decoder decoder00 (
	.tone(tone),
	.height(height),
	.freq(freq)
);

PWM_gen pwm_0 ( 
	.clk(clk), 
	.reset(reset), 
	.freq(freq),
	.duty(10'd512), 
	.PWM(pmod_1)
);


endmodule

module Decoder (
	input [2:0] tone,
	input [3:0] height,
	output reg [31:0] freq 
);

always @(*) begin
	case (tone)
		3'b000: begin // Do
			freq = 32'd262 << (height - 4'd4);
		end
		3'b001: begin // Re
			freq = 32'd294 << (height - 4'd4);
		end
		3'b010: begin // Mi
			freq = 32'd330 << (height - 4'd4);
		end
		3'b011: begin // Fa
			freq = 32'd349 << (height - 4'd4);
		end
		3'b100: begin // Sol
			freq = 32'd392 << (height - 4'd4);
		end
		3'b101: begin // La
			freq = 32'd440 << (height - 4'd4);
		end
		3'b110: begin // Si
			freq = 32'd494 << (height - 4'd4);
		end
		default : freq = 32'd20000;	//Do-dummy
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

module OnePulse (
    output reg signal_single_pulse,
    input wire signal,
    input wire clock
    );
    
    reg signal_delay;

    always @(posedge clock) begin
        if (signal == 1'b1 & signal_delay == 1'b0)
            signal_single_pulse <= 1'b1;
        else
            signal_single_pulse <= 1'b0;
        signal_delay <= signal;
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Module Name: PWM_gen
// Description: This IP expects 100 MHz input clock and generates the desired output
// 				at PWM output with the configurable frequency (in Hz) and duty cycle.
// 				
//				The configurable frequency should be less or equal to 100 MHz and 
//				the duty cycle can vary in step of 1/1024, i.e. 0.0009765625 or 
//				approximately 0.1% 
//////////////////////////////////////////////////////////////////////////////////
module PWM_gen (
    input wire clk,
    input wire reset,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge reset) begin
    if (reset) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule

