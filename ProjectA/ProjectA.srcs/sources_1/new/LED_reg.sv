`timescale 1ns / 1ps
`default_nettype none


module LED_reg(
    input wire clock,
    input wire lights_wr,
    input wire [15:0] lights_val,
    output logic [15:0] LED
    );
    
    //LED
    always_ff @(posedge clock) begin
        if (lights_wr)
            LED <= lights_val;
    end
    
endmodule
