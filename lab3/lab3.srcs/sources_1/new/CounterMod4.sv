`timescale 1ns / 1ps
`default_nettype none


module CounterMod4(
    input wire clock,
    input wire reset,
    output logic [1:0] value = 0
    );
    
    
    always_ff @(posedge clock) begin
        value <= reset ? 2'b00 : (value + 1);
    end
    
endmodule
