//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/9/2017
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module screenmem #(
   parameter Nloc,
   parameter Dbits
)(
   input wire clock,
   input wire wr = 0,
   input wire [$clog2(Nloc)-1:0] screenaddr,
   input wire [Dbits-1:0] writedata,
   output logic [Dbits-1:0] charcode
   );

   logic [Dbits-1:0] mem [Nloc-1:0];
   initial $readmemh("smem_screentest.mem", mem, 0, Nloc-1);

   always_ff @(posedge clock) begin
      if(wr) begin
         mem[screenaddr] <= writedata;
      end
   end

   assign charcode = mem[screenaddr];

endmodule