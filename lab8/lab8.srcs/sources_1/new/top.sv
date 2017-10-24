//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/19/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="E:/Vivado/Projects/lab8/lab8.srcs/sources_1/new/full_imem.mem",	   // correct filename inherited from parent/tester
    parameter dmem_init="E:/Vivado/Projects/lab8/lab8.srcs/sources_1/new/full_dmem.mem"		   // correct filename inherited from parent/tester
)(
    input wire clock, reset, enable
);
   
   wire [31:0] pc ,instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;

   mips mips(clock, reset, enable, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);
   imem #(.Nloc(64), .Dbits(32), .initfile(imem_init)) imem(pc[31:0], instr);
   dmem #(.Nloc(64), .Dbits(32), .initfile(dmem_init)) dmem(clock, mem_wr, mem_addr, mem_writedata, mem_readdata);

endmodule