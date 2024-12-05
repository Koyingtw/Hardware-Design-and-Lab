module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    input enable_stop,
    output trig,
    output left_motor,
    output reg [1:0]left,
    output right_motor,
    output reg [1:0]right,
    output left_signal_light,
    output right_signal_light,
    output mid_signal_light
);

    wire Rst_n, rst_pb, stop;
    wire [2:0] state;

    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);

    motor A(
        .clk(clk),
        .rst(Rst_n),
        .mode(state),
        .pwm({left_motor, right_motor})
    );

    sonic_top B(
        .clk(clk), 
        .rst(Rst_n), 
        .enable_stop(enable_stop),
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst_n), 
        .left_signal(left_signal), 
        .right_signal(right_signal),
        .mid_signal(mid_signal), 
        .state(state)
       );

    reg [2:0] last_state;
    always @(posedge clk) begin
        if (state == 3'b001 || (last_state == 3'b001 && state == 3'b011))
            last_state <= 3'b001;
        else if (state == 3'b100 || (last_state == 3'b100 && state == 3'b110))
            last_state <= 3'b100;
        else
            last_state <= state;
    end

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        if (stop) {left, right} = {2'b00, 2'b00};
        else if (Rst_n) begin
            left = 2'b00;
            right = 2'b00;
        end
        else if (last_state == 3'b001 && state == 3'b011) begin
            left = left;
            right = right;
        end
        else if (last_state == 3'b100 && state == 3'b110) begin
            left = left;
            right = right;
        end
        else if (state != 0 && state != 3'b010) begin
            if (state[0])
                left = 2'b10;
            else if (!state[1])
                left = 2'b01;
            else
                left = left;
            
            if (state[2])
                right = 2'b10;
            else if (!state[1])
                right = 2'b01;
            else
                right = right;
        end
        else begin
            left = left;
            right = right;
        end
    end

    assign left_signal_light = state[2];
    assign mid_signal_light = state[1];
    assign right_signal_light = state[0];
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

