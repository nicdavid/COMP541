`timescale 1ns / 1ps
`default_nettype none


module sound_reg(
    input wire clock,
    input wire sound_wr,
    input wire sound_val,
    output logic audEn,
    output logic [15:0] period
    );
    
    //Sound
    always_ff @(posedge clock) begin
        if (sound_wr) begin
            audEn <= 1'b1;
            period <= sound_val;
        end
    end
    
endmodule
