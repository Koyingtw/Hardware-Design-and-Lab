`timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;
    output [2:0] state;

    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    assign state = {left_signal, mid_signal, right_signal};
endmodule
