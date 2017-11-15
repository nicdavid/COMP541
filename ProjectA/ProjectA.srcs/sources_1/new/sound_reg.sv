`timescale 1ns / 1ps
`default_nettype none


module sound_reg(
    input wire clock,
    input wire sound_wr,
    input wire [31:0] sound_val,
    output logic audEn,
    output logic [31:0] period
    );
    
    // These are periods (in units of 10 ns) for the notes on the normal C4 scale,
    //   i.e.:  C4, D4, E4, F4, G4, A4, B4, C5
    wire [31:0] notes_periods[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
    
    //Sound
    always_ff @(posedge clock) begin
        if (sound_wr) begin
            audEn <= 1'b1;
            period <= sound_val < 32'b0000_0000_0000_0000_0000_0000_0100_0000 ? notes_periods[0] :
                      sound_val < 32'b0000_0000_0000_0000_0000_0000_1000_0000 ? notes_periods[1] :
                      sound_val < 32'b0000_0000_0000_0000_0000_0000_1100_0000 ? notes_periods[2] :
                      sound_val < 32'b0000_0000_0000_0000_0000_0001_0000_0000 ? notes_periods[3] :
                      sound_val < 32'b0000_0000_0000_0000_0000_0001_0100_0000 ? notes_periods[4] :
                      sound_val < 32'b0000_0000_0000_0000_0000_0001_1000_0000 ? notes_periods[5] :
                      sound_val < 32'b0000_0000_0000_0000_0000_0001_1100_0000 ? notes_periods[6] : notes_periods[7];
        end
    end
    
endmodule
