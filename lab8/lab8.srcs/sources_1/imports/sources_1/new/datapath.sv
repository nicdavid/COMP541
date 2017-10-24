`timescale 1ns / 1ps
`default_nettype none


module datapath#(
   parameter Nloc = 32,                         // Number of memory locations
   parameter Dbits = 32                         // Number of bits in data
)(
    input wire clock, reset, enable,
    output wire [31:0] pc,
    input wire [31:0] instr,
    input wire [1:0] pcsel, wasel, wdsel, asel,
    input wire sext, bsel, werf,
    input wire [4:0] alufn,
    input wire [Dbits-1:0] mem_readdata,
    output wire Z,
    output wire [Nloc-1:0] mem_addr,
    output wire [Dbits-1:0] mem_writedata
    );
    
    
    //Program Counter (pc)
    wire [Dbits-1:0] newPC, pcPlus4;
    assign newPC = (pcsel == 2'b11) ? JT
                        : (pcsel == 2'b10) ? {pc[31:28],J,2'b00}
                        : (pcsel == 2'b01) ? BT
                        : pcPlus4;
    programcounter pcm(.clock(clock), .reset(reset), .enable(enable), .D(newPC), .pc(pc));
    assign pcPlus4 = pc + 4;
    
    
    //Jump
    wire [Dbits-1:0] JT;
    assign JT = ReadData1;
    
    // Jump -- sent to program counter
    wire [25:0] J;
    assign J = instr[25:0];
    
    // Branch
    wire [Dbits-1:0] BT;
    assign BT = (signImm << 2) + pcPlus4;
    
    
    // Register Write Address Select (wasel)
    // wasel 00 => instr[15:11]
    // wasel 01 => instr[20:16]
    // wasel 10 => 31
    wire [$clog2(Nloc)-1:0] reg_writeaddr;
    assign reg_writeaddr = (wasel == 2'b00) ? instr[15:11] : (wasel == 2'b01) ? instr[20:16] : 5'b1_1111;
    
    
    // Register Write Data (wdsel)
    // wdsel 00 => PC + 4
    // wdsel 01 => alu_result
    // wdsel 10 => mem_readdata
    wire [Dbits-1:0] reg_writedata;
    assign reg_writedata = (wdsel == 2'b00) ? pc + 4 : (wdsel == 2'b01) ? alu_result : mem_readdata;
    
    // Register File
    wire [Dbits-1:0] ReadData1, ReadData2;
    register_file #(Nloc, Dbits) rf(.clock(clock), .wr(werf), .ReadAddr1(instr[25:21]), .ReadAddr2(instr[20:16]),
                        .WriteAddr(reg_writeaddr), .WriteData(reg_writedata), .ReadData1(ReadData1), .ReadData2(ReadData2));
                        


    // Sign Extension (sext)
    wire [Dbits-1:0] signImm;
    assign signImm = (sext == 1'b1) ? {{16{instr[15]}},instr[15:0]} : {16'b0,instr[15:0]};
    
    
    // A Select (asel)
    // asel 00 => ReadData1
    // asel 01 => instr[10:6]
    // asel 10 => 16
    wire [Dbits-1:0] aluA;
    assign aluA = (asel == 2'b00) ? ReadData1 : (asel == 2'b01) ? instr[10:6] : 5'b1_0000;
    
    // B Select (bsel)
    // bsel 0 => ReadData2
    // bsel 1 => signImm
    wire [Dbits-1:0] aluB;
    assign aluB = (bsel == 1'b1) ? signImm : ReadData2;
    
    
                        
    // ALU
    wire [Dbits-1:0] alu_result;
    ALU #(Dbits) alu(.A(aluA), .B(aluB), .R(alu_result), .ALUfn(alufn), .FlagZ(Z));
    
    // Memory Address
    assign mem_addr = alu_result;
    
    // Memory Write Data
    assign mem_writedata = ReadData2;
    
    
endmodule
