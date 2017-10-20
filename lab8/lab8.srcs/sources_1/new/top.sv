//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/19/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="sqr_dmem.mem",		// correct filename inherited from parent/tester
    parameter dmem_init="sqr_imem.mem"		// correct filename inherited from parent/tester
)(
    input wire clock, reset, enable
);
   
    wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
    wire mem_wr;

    //Mips processor
    mips mips(.clock(clock), .reset(reset), .enable(enable), .pc(pc), .instr(instr), .mem_wr(mem_wr),
                .mem_addr(mem_addr), .mem_writedata(mem_writedata), .mem_readdata(mem_readdata));
   
    //Instruction Memory
    imem #(.Nloc(64), .Dbits(32), .initfile(imem_init)) imem(.pc(pc[31:0]), .instr(instr));
   
    //Data Memory
    dmem #(.Nloc(64), .Dbits(32), .initfile(dmem_init)) dmem(.clock(clock), .mem_wr(mem_wr),
                                                                .mem_addr(mem_addr), .mem_writedata(mem_writedata),
                                                                .mem_readdata(mem_readdata));

endmodule