`timescale 1ns / 1ps
`default_nettype none


module top #(
    parameter ScreenNloc = 11,
    parameter ScreenDbits = 4,
    parameter BitmapNloc = 12,
    parameter BitmapDbits = 12
)(
    input wire clock,
    output wire [11:0] RGB,
    output wire vsync, hsync
    );
  
    //VGA Display Driver
    wire [ScreenNloc-1:0] screenaddr;
    wire [ScreenDbits-1:0] charcode;
    vgadisplaydriver #(BitmapNloc, BitmapDbits) vga(.clock(clock), .screenaddr(screenaddr), .charcode(charcode), .RGB(RGB), .hsync(hsync), .vsync(vsync));


    //Screen Memory
    screenmem #(ScreenNloc, ScreenDbits) sm(.screenaddr(screenaddr), .charcode(charcode));
    
    
endmodule
