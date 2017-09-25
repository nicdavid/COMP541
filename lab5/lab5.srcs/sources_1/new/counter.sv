`timescale 1ns / 1ps
`default_nettype none


module counter(
    input wire clock,
    output logic [63:0] value = 0
    );
    
    always_ff @(posedge clock) begin
        value <= value + 1;
    end

endmodule
