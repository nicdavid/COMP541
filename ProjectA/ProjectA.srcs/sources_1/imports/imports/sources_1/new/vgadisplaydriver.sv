`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"


module vgadisplaydriver #(
    parameter sNloc = 1200,
    parameter sDbits = 4,
    parameter bNloc = 1024,
    parameter bDbits = 12,
    parameter bmem_init
) (
    input wire clock,
    input wire [sDbits-1:0] charcode,
    output wire hsync, vsync,
    output wire [11:0] RGB,
    output wire [$clog2(sNloc)-1:0] screenaddr
    );
    
    //Gets the coordinates from the screen
    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire activevideo;
    vgatimer vga(.clock(clock), .hsync(hsync), .vsync(vsync), .activevideo(activevideo), .x(x), .y(y));
    
    //Sets the screen address
    assign screenaddr = (y[`ybits-1:4] << 5) + (y[`ybits-1:4] << 3) + x[`xbits-1:4];
    
    //Assigns the bitmap address
    wire [$clog2(bNloc)-1:0] bmem_addr;
    assign bmem_addr = {charcode,y[3:0],x[3:0]};
    
    //Gets the color value
    wire [bDbits-1:0] bmem_color;
    bitmapmem #(.Nloc(bNloc), .Dbits(bDbits), .initfile(bmem_init)) bm(.addr(bmem_addr), .colorval(bmem_color));
    
    assign RGB = (activevideo) ? bmem_color : 11'b0;
    
    
endmodule
