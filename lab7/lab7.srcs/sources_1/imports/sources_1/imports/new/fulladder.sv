`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2017 11:18:41 AM
// Design Name: 
// Module Name: fulladder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fulladder(
    input wire A,
    input wire B,
    input wire Cin,
    output wire Sum,
    output wire Cout
    );
    
    wire t1, t2, t3;
    
    xor x1(t1, A, B);
    xor x2(Sum, t1, Cin);
    and a1(t2, A, B);
    and a2(t3, Cin, t1);
    or o1(Cout, t2, t3);
    
endmodule
