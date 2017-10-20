`timescale 1ns / 1ps
`default_nettype none


module programcounter(
    input wire clock, reset, enable,
    input wire [1:0] pcsel,
    input wire [31:0] JT,
    input wire [31:0] BT,
    input wire [25:0] J,
    output wire [31:0] pc,
    output wire [31:0] pcPlus4
    );
    
    //Program Counter (pc)
    wire [31:0] newPC;
    assign newPC = (pcsel == 2'b11) ? JT
                        : (pcsel == 2'b10) ? {pc[31:28],J,2'b00}
                        : (pcsel == 2'b01) ? BT
                        : pcPlus4;
        
        
        logic [31:0] PC;
        always_ff @(posedge clock) begin
            PC <= reset ? {32{0}} :
                    enable ? newPC : pc;
        end
        
        assign pc = PC;
        assign pcPlus4 = PC + 4;
        
    
endmodule
