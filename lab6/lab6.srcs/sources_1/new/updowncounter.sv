`timescale 1ns / 1ps
`default_nettype none


module updowncounter(
    input wire countup, paused,
    input wire clock,
    output logic [63:0] value = 0
    );
    
    always_ff @(posedge clock) begin
        value <= countup ? (paused ? value : value + 1) : (paused ? value : value - 1);
    end

    
endmodule
