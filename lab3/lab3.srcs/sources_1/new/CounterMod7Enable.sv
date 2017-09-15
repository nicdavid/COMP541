`timescale 1ns / 1ps
`default_nettype none


module CounterMod7Enable(
    input wire clock,
    input wire reset,
    input wire enable,
    output logic [2:0] value
    );
    
    
    always_ff @(posedge clock) begin
        value <= reset ? 2'b00 : enable ?
            (value == 3'b110 ? 0 : (value + 1)) : value;
    end
    
endmodule
