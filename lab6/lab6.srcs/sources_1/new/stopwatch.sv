`timescale 1ns / 1ps
`default_nettype none


module stopwatch(
    input wire clock,
    input wire BTNC, BTNU, BTND,
    output wire [7:0] segments, digitselect
    );
    
    
    //Debounces all three of the signals
    wire cleanC, cleanU, cleanD;
    debouncer #(20) d1(.raw(BTNC), .clock(clock), .clean(cleanC));
    debouncer #(20) d2(.raw(BTNU), .clock(clock), .clean(cleanU));
    debouncer #(20) d3(.raw(BTND), .clock(clock), .clean(cleanD));
    
    //Instantiates the fsm
    logic countup;
    logic paused;
    fsm f1(.clock(clock), .up(cleanU), .down(cleanD), .center(cleanC), .countup(countup), .paused(paused));
    
    
    //Instantiates Up-Down Counter
    logic [63:0] val;
    updowncounter count(.countup(countup), .paused(paused), .clock(clock), .value(val));
    
    //Displays the value
    display8digit dis(.val(val[51:18]), .clock(clock), .segments(segments), .digitselect(digitselect));
    //display8digit dis(.val(cleanC), .clock(clock), .segments(segments), .digitselect(digitselect));
    
    
endmodule
