`timescale 1ns / 1ps
`default_nettype none


module imem #(
    parameter Nloc,
    parameter Dbits,
    parameter initfile
) (
    input wire [Nloc-1:0] pc,
    output logic [Dbits-1:0] instr
    );
    
    //Instantiate the memory
    logic [Dbits-1:0] mem [Nloc-1:0];
    initial $readmemh(initfile, mem, 0, Nloc-1);
    
    //Read data
    assign instr = mem[pc[$clog2(Nloc)+1:2]];
    
    
endmodule
