`timescale 1ns / 1ps
`default_nettype none


module programcounter(
    input wire clock, reset, enable,
    input wire [31:0] D,
    output wire [31:0] pc
    );
    
    //Program Counter (pc)
    logic [31:0] Q = 32'h0040_0000;
    always_ff @(posedge clock or posedge reset) begin
        if (reset)
            Q <= 32'h0040_0000;
        else if (enable)
            Q <= D;
    end
    
    assign pc = Q;
        
    
endmodule
