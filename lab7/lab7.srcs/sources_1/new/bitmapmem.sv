`timescale 1ns / 1ps
`default_nettype none


module bitmapmem #(
    parameter Nloc,
    parameter Dbits
)(
    input wire [$clog2(Nloc)-1:0] bitmapaddr,
    output logic [Dbits-1:0] colorvalue
    );
    
    //Instantiates and initializes memory
    logic [Dbits-1:0] bm [Nloc-1:0];
    initial $readmemh("bmem_screentest.mem", bm, 0, Nloc-1);
        
    //Returns the color value at the address
    assign colorvalue = bm[bitmapaddr];
        
endmodule
