`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"


module vgatimer(
    input wire clock,
    output wire hsync, vsync, activevideo,
    output wire [`xbits-1:0] x,
    output wire [`ybits-1:0] y
    );
    
    
    //Counts every second and fourth clock ticks
    //Depending on the display, 50/25 MHz may be needed
    logic [1:0] clk_count = 0;
    always_ff @(posedge clock)
        clk_count <= clk_count + 2'b 01;
        
    wire Every2ndTick = (clk_count[0] == 1'b 1);
    wire Every4thTick = (clk_count[1:0] == 2'b 11);
    
    
    //Instantiates an xy-counter using clock tick counter
//    xycounter #(`WholeLine, `WholeFrame) xy(clock, Every2ndTick, x, y); //50 MHz
    
    xycounter #(`WholeLine, `WholeFrame) xy(clock, Every4thTick, x, y); //25 MHz
    
    
    //Generate monitor sync signals
    assign hsync = ((x >= `hSyncStart) & (x <= `hSyncEnd)) ? ~`hSyncPolarity : `hSyncPolarity;
    assign vsync = ((y >= `vSyncStart) & (y <= `vSyncEnd)) ? ~`vSyncPolarity : `vSyncPolarity;
    assign activevideo = ((x < `hVisible) & (y < `vVisible)) ? 1 : 0;
        
    
    
    
endmodule
