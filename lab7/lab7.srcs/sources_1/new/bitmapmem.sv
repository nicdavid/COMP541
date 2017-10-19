`timescale 1ns / 1ps
`default_nettype none


module bitmapmem #(
    parameter Nloc,
    parameter Dbits
) (
    input wire [$clog2(Nloc)-1:0] addr,
    output logic [Dbits-1:0] colorval
    );
    
    
    logic [Dbits-1:0] mem [Nloc-1:0];
    initial $readmemh("bitmapmem.mem", mem, 0, Nloc-1);
    
    assign colorval = mem[addr];
    
endmodule
