`timescale 1ns / 1ps
`default_nettype none


module memIO # (
    parameter Nloc = 16,
    parameter Dbits = 32,
    parameter dmem_init,
    parameter smem_init
) (
    input wire clock,
    input wire [31:0] mem_addr,
    input wire [Dbits-1:0] mem_writedata,
    input wire mem_wr,
    output wire [Dbits-1:0] mem_readdata,
    input wire [10:0] smem_addr,
    output wire [3:0] charcode,
    
    //Keyboard
    input wire [31:0] keyb_char,
    
    //Accel
    input wire [8:0] accelX,
    input wire [8:0] accelY,
    
    //Sound
    output wire audEn,
    output wire [31:0] period,
    
    //LED
    output wire [15:0] LED
    );
    
    
    //Data Memory
    wire [Dbits-1:0] dmem_readdata;
    dmem #(.Nloc(Nloc), .Dbits(Dbits), .initfile(dmem_init)) dmem(.clock(clock), .mem_wr(dmem_wr), .mem_addr(mem_addr),
                                                            .mem_writedata(mem_writedata), .mem_readdata(dmem_readdata));
    
    //Screen Memory
    wire [31:0] smem_readdata;
    screenmem #(.Nloc(1200), .Dbits(4), .initfile(smem_init)) smem(.clock(clock), .wr(smem_wr), .smem_addr(smem_addr),
                                                                    .mem_addr(mem_addr), .wd(mem_writedata), 
                                                                    .charcode(charcode), .mem_readdata(smem_readdata));
    
    
    
    //LED Register
    LED_reg led(.clock(clock), .lights_wr(lights_wr), .lights_val(mem_readdata), .LED(LED));
    
    //Sound Register
    sound_reg sound_reg(.clock(clock), .sound_wr(sound_wr), .sound_val(mem_readdata), .audEn(audEn), .period(period));

    
    
    //Memory Mapper
    assign mem_readdata = (mem_addr[17:16] == 2'b01) ? dmem_readdata :
                            (mem_addr[17:16] == 2'b10) ? smem_readdata :
                            (mem_addr[17:16] == 2'b11) ? ((mem_addr[3:2] == 2'b00) ? keyb_char : {23'b0,accelX}) : 32'b0;
                            
//                             {7'b0,accelX,7'b0,accelY}
    
                                
    wire dmem_wr, smem_wr, sound_wr, lights_wr;
    assign dmem_wr = (mem_addr[17:16] == 2'b01 && mem_wr) ? 1'b1 : 1'b0;
    assign smem_wr = (mem_addr[17:16] == 2'b10 && mem_wr) ? 1'b1 : 1'b0;
    assign sound_wr = (mem_addr[17:16] == 2'b11 && mem_addr[3:2] == 2'b10 && mem_wr) ? 1'b1 : 1'b0;
    assign lights_wr = (mem_addr[17:16] == 2'b11 && mem_addr[3:2] == 2'b11 && mem_wr) ? 1'b1 : 1'b0;
    
endmodule
