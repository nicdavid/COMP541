`timescale 1ns / 1ps
`default_nettype none


module top #(
    parameter ScreenNloc = 1200,
    parameter ScreenDbits = 2,
    parameter BitmapNloc = 1024,
    parameter BitmapDbits = 12
)(
    input wire clock,
    output wire [3:0] red, green, blue,
    output wire vsync, hsync
    );
  
    //VGA Display Driver
    wire [$clog2(ScreenNloc)-1:0] screenaddr;
    wire [ScreenDbits-1:0] charcode;
    wire [11:0] RGB;
    vgadisplaydriver #(ScreenNloc, ScreenDbits, BitmapNloc, BitmapDbits) vga(.clock(clock), .screenaddr(screenaddr), .charcode(charcode), .RGB(RGB), .hsync(hsync), .vsync(vsync));

    assign red = RGB[11:8];
    assign green = RGB[7:4];
    assign blue = RGB[3:0];
    

    //Screen Memory
    screenmem #(ScreenNloc, ScreenDbits) sm(.screenaddr(screenaddr), .charcode(charcode));
    
    
endmodule
