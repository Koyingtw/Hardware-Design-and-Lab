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
reg [2:0] tone = 0;
reg [3:0] height = 4;
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
	counter <= counter + 1;
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
			if (height >= 4'd4) begin
				freq = 32'd262 << (height - 4'd4);
			end
			else begin
				freq = 32'd262 >> (4'd4 - height);
			end
		end 
		3'b001: begin // Re
			if (height >= 4'd4) begin
				freq = 32'd294 << (height - 4'd4);
			end
			else begin
				freq = 32'd294 >> (4'd4 - height);
			end
		end
		3'b010: begin // Mi
			if (height >= 4'd4) begin
				freq = 32'd330 << (height - 4'd4);
			end
			else begin
				freq = 32'd330 >> (4'd4 - height);
			end
		end
		3'b011: begin // Fa
			if (height >= 4'd4) begin
				freq = 32'd349 << (height - 4'd4);
			end
			else begin
				freq = 32'd349 >> (4'd4 - height);
			end
		end
		3'b100: begin // Sol
			if (height >= 4'd4) begin
				freq = 32'd392 << (height - 4'd4);
			end
			else begin
				freq = 32'd392 >> (4'd4 - height);
			end
		end
		3'b101: begin // La
			if (height >= 4'd4) begin
				freq = 32'd440 << (height - 4'd4);
			end
			else begin
				freq = 32'd440 >> (4'd4 - height);
			end
		end
		3'b110: begin // Si
			if (height >= 4'd4) begin
				freq = 32'd494 << (height - 4'd4);
			end
			else begin
				freq = 32'd494 >> (4'd4 - height);
			end
		end
		default : freq = 32'd20000;	//Do-dummy
		// 16'b0000_0000_0000_0001: freq = 32'd262;	//Do-m
		// 16'b0000_0000_0000_0010: freq = 32'd294;	//Re-m
		// 16'b0000_0000_0000_0100: freq = 32'd330;	//Mi-m
		// 16'b0000_0000_0000_1000: freq = 32'd349;	//Fa-m
		// 16'b0000_0000_0001_0000: freq = 32'd392;	//Sol-m
		// 16'b0000_0000_0010_0000: freq = 32'd440;	//La-m
		// 16'b0000_0000_0100_0000: freq = 32'd494;	//Si-m
		// 16'b0000_0000_1000_0000: freq = 32'd262 << 1;	//Do-h
		// 16'b0000_0001_0000_0000: freq = 32'd294 << 1;
		// 16'b0000_0010_0000_0000: freq = 32'd330 << 1;
		// 16'b0000_0100_0000_0000: freq = 32'd349 << 1;
		// 16'b0000_1000_0000_0000: freq = 32'd392 << 1;
		// 16'b0001_0000_0000_0000: freq = 32'd440 << 1;
		// 16'b0010_0000_0000_0000: freq = 32'd494 << 1;
		// 16'b0100_0000_0000_0000: freq = 32'd262 << 2;
		// 16'b1000_0000_0000_0000: freq = 32'd294 << 2;
		// default : freq = 32'd20000;	//Do-dummy
	endcase
end

endmodule