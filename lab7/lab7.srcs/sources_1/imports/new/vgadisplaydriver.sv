//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 9/12/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver #(
    parameter ScreenNloc,
    parameter ScreenDbits,
    parameter BitmapNloc,
    parameter BitmapDbits
)(
    input wire clock,
    input wire [ScreenDbits-1:0] charcode,
    output wire [$clog2(ScreenNloc)-1:0] screenaddr,
    output wire [11:0] RGB,
    output wire hsync, vsync
    );

    //VGA Timer
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire activevideo;
    vgatimer myvgatimer(.clock(clock), .hsync(hsync), .vsync(vsync), .activevideo(activevideo), .x(x), .y(y));
   
    //X/Y to Screen Address
    assign screenaddr = (y << 5) + (y << 3) + x;
    
    //X/Y and Character Code to Bitmap Address
    wire [$clog2(BitmapNloc)-1:0] bitmapaddr;
    assign bitmapaddr = {charcode,y[4:0],x[4:0]};
    

    //Bitmap Memory
    wire [BitmapDbits-1:0] colorvalue;
    bitmapmem #(BitmapNloc, BitmapDbits) bm(.bitmapaddr(bitmapaddr), .colorvalue(colorvalue));
    
    
    //RGB Output
    assign RGB = (activevideo) ? colorvalue : 11'b0;
    
endmodule