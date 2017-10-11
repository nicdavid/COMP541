`timescale 1ns / 1ps
`default_nettype none


module datapath#(
   parameter Nloc = 32,                         // Number of memory locations
   parameter Dbits = 32                        // Number of bits in data
)(
    input wire clock,
    input wire RegWrite,
    input wire [$clog2(Nloc)-1 : 0] ReadAddr1, ReadAddr2, WriteAddr,
    input wire [4:0] ALUFN,
    input wire [Dbits-1 : 0] WriteData = 1'b1,
    output wire [Dbits-1 : 0] ReadData1, ReadData2,
    output wire [Dbits-1:0] ALUResult,
    output wire FlagZ
    );
    
    //Register File
    register_file #(Nloc, Dbits) rf(.clock(clock), .wr(RegWrite), .ReadAddr1(ReadAddr1), .ReadAddr2(ReadAddr2),
                        .WriteAddr(WriteAddr), .WriteData(WriteData), .ReadData1(ReadData1), .ReadData2(ReadData2));
                        
    //ALU
    ALU #(Dbits) alu(.A(ReadData1), .B(ReadData2), .R(ALUResult), .ALUfn(ALUFN), .FlagZ(FlagZ));
    
    
endmodule
