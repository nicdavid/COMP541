//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 9/12/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgadisplaydriver#(
    parameter Nloc = 12,
    parameter Dbits = 12
)(
    input wire clock,
    input wire [Dbits-1:0] charcode,
    output wire [Nloc-1:0] screenaddr,
    output wire [11:0] RGB,
    output wire hsync, vsync
    );

    //VGA Timer
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire activevideo;
    vgatimer vgatimer(.clock(clock), .hsync(hsync), .vsync(vsync), .x(x), .y(y));
   
    //X/Y to Screen Address
    assign screenaddr = (y << 5) + (y << 3) + x;
    
    //X/Y and Character Code to Bitmap Address
    wire [Nloc-1:0] bitmapaddr;
    assign bitmapaddr = {charcode, y[4:0],x[4:0]};
    

    //Bitmap Memory
    wire [Dbits-1:0] colorvalue;
    bitmapmem #(Nloc, Dbits) bm(.bitmapaddr(bitmapaddr), .colorvalue(colorvalue));
    
    
    //RGB Output
    assign RGB = (activevideo) ? colorvalue : 1'b0;
    
    
endmodule