`timescale 1ns / 1ps
`default_nettype none


module top #(
    parameter sNloc = 1200,
    parameter sDbits = 2,
    parameter bNloc = 1024,
    parameter bDbits = 12
) (
    input wire clock,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );
    
    //Sets up wires
    wire [11:0] RGB;
    wire [$clog2(sNloc)-1:0] screenaddr;
    wire [sDbits-1:0] charcode;
    
    //Instantiates vgadisplaydriver
    vgadisplaydriver #(sNloc, sDbits, bNloc, bDbits) vgadriver(.clock(clock), .charcode(charcode),
                                                                .hsync(hsync), .vsync(vsync),
                                                                .RGB(RGB), .screenaddr(screenaddr));
                                                                
                                                                
    //Sets the color values
    assign red = RGB[11:8];
    assign green = RGB[7:4];
    assign blue = RGB[3:0];
    
    //Instantiates screen memory
    screenmem #(sNloc, sDbits) sm(.clock(clock), .wr(1'b0), .wd(2'b0), .addr(screenaddr), .charcode(charcode));
    
endmodule
