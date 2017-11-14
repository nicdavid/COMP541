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
            LED <= (
                    lights_val < 9'b0_0011_1100 ? 16'b0000_0000_0000_0001 :     //60
                    lights_val < 9'b0_0101_1010 ? 16'b0000_0000_0000_0010 :     //90
                    lights_val < 9'b0_0111_1000 ? 16'b0000_0000_0000_0100 :     //120
                    lights_val < 9'b0_1001_0110 ? 16'b0000_0000_0000_1000 :     //150
                    lights_val < 9'b0_1011_0100 ? 16'b0000_0000_0001_0000 :     //180
                    lights_val < 9'b0_1101_0010 ? 16'b0000_0000_0010_0000 :     //210
                    lights_val < 9'b0_1111_0000 ? 16'b0000_0000_0100_0000 :     //240
                    lights_val < 9'b1_0000_1110 ? 16'b0000_0000_1000_0000 :     //270
                    lights_val < 9'b1_0010_1100 ? 16'b0000_0001_0000_0000 :     //300
                    lights_val < 9'b1_0100_1010 ? 16'b0000_0010_0000_0000 :     //330
                    lights_val < 9'b1_0110_1000 ? 16'b0000_0100_0000_0000 :     //360
                    lights_val < 9'b1_1000_0110 ? 16'b0000_1000_0000_0000 :     //390
                    lights_val < 9'b1_1010_0100 ? 16'b0001_0000_0000_0000 :     //420
                    lights_val < 9'b1_1100_0010 ? 16'b0010_0000_0000_0000 :     //450
                    lights_val < 9'b1_1110_0000 ? 16'b0100_0000_0000_0000 :     //480
                    16'b1000_0000_0000_0000
                );
    end
    
endmodule
