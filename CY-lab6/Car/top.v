module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    output trig,
    output left_motor,
    output reg [1:0]left,
    output right_motor,
    output reg [1:0]right,
    output left_signal_light,
    output right_signal_light,
    output mid_signal_light,
    output [1:0] left_light,
    output [1:0] right_light
);

    wire Rst_n, rst_pb, stop;
    wire [2:0] state;
    wire _left_signal, _right_signal, _mid_signal;
    assign _left_signal = ~left_signal;
    assign _right_signal = ~right_signal;
    assign _mid_signal = ~mid_signal;

    reg [3:0] mode;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst_n);

    motor A(
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .pwm({left_motor, right_motor})
    );

    sonic_top B(
        .clk(clk), 
        .rst(rst), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(rst), 
        .left_signal(left_signal), 
        .right_signal(right_signal),
        .mid_signal(mid_signal), 
        .state(state)
       );

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        if (stop) {left, right} = {0, 0};
        else if (rst) begin
            left = 2'b00;
            right = 2'b00;
        end
        else if (state != 0) begin
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
        mode = state;
        //else  {left, right} = ???;
        // if (stop) begin
        //     left = 2'b00;
        //     right = 2'b00;
        // end
        // else begin
        //     left = mode[1];
        //     right = mode[0];
        // end
    end
    // assign left_signal_light = left_signal;
    // assign right_signal_light = right_signal;
    // assign mid_signal_light = mid_signal;
    assign left_signal_light = state[2];
    assign mid_signal_light = state[1];
    assign right_signal_light = state[0];
    assign left_light = left;
    assign right_light = right;

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

