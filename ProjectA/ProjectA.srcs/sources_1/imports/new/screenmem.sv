`timescale 1ns / 1ps
`default_nettype none


module screenmem #(
    parameter Nloc,
    parameter Dbits,
    parameter initfile
) (
    input wire clock,
    input wire wr,
    input wire [Dbits-1:0] wd,
    input wire [$clog2(Nloc)-1:0] smem_addr,
    input wire [31:0] mem_addr,
    output logic [Dbits-1:0] charcode,
    output logic [31:0] mem_readdata
    );
    
    //Initializes the memory
    logic [Dbits-1:0] mem [Nloc-1:0];
    initial $readmemh(initfile, mem, 0, Nloc-1);
    
    always_ff @(posedge clock)
        if (wr)
            mem[mem_addr[12:2]] <= wd;
    
    //Sets the character code
    assign charcode = mem[smem_addr];
    assign mem_readdata = mem[{19'b0,mem_addr[12:2]}];
    
    
endmodule
