`timescale 1ns / 1ps
`default_nettype none


module CounterMod7(
    input wire clock,
    input wire reset,
    output logic [2:0] value
    );
    
    
    always_ff @(posedge clock) begin
        value <= reset ? 2'b00 : value == 3'b110 ? 0 : (value + 1);
    end
    
endmodule
