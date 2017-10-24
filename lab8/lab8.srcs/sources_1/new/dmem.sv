`timescale 1ns / 1ps
`default_nettype none


module dmem #(
    parameter Nloc,
    parameter Dbits,
    parameter initfile
) (
    input wire clock,
    input wire mem_wr,
    input wire [31:0] mem_addr,
    input wire [Dbits-1:0] mem_writedata,
    output logic [Dbits-1:0] mem_readdata
    );
    
    
    //Instantiate the memory
    logic [Dbits-1:0] mem [Nloc-1:0];
    initial $readmemh(initfile, mem, 0, Nloc-1);
    
    //Write Data
    always_ff @(posedge clock)
        if (mem_wr)
            mem[mem_addr[$clog2(Nloc)+1:2]] <= mem_writedata;
            
    //Read data
    assign mem_readdata = mem[mem_addr[$clog2(Nloc)-1:2]];
    
    
endmodule
