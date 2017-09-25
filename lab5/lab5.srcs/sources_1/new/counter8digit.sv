`timescale 1ns / 1ps
`default_nettype none


module counter8digit(
    input wire clock,
    output logic [7:0] segments,
    output logic [7:0] digitselect
    );
    
    
    logic [63:0] value;
    counter c(.clock(clock),.value(value));
        
    display8digit d(.val(value[50:19]),.clock(clock),.segments(segments),.digitselect(digitselect));
    

endmodule
