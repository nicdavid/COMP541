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
    input wire ps2_clk, ps2_data,
    
    //Sound
    output wire audPWM,
    output wire audEn,
    
    //Accel
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    //LED
    output wire [15:0] LED
    );
    
    
    //Data Memory
    wire [Dbits-1:0] dmem_readdata;
    dmem #(.Nloc(Nloc), .Dbits(Dbits), .initfile(dmem_init)) dmem(.clock(clock), .mem_wr(dmem_wr), .mem_addr(mem_addr),
                                                            .mem_writedata(mem_writedata), .mem_readdata(dmem_readdata));
    
    //Screen Memory
    screenmem #(.Nloc(1200), .Dbits(4), .initfile(smem_init)) smem(.clock(clock), .wr(smem_wr), .addr(smem_addr),
                                                                    .wd(mem_writedata), .charcode(charcode));
    
    
    //Accel
    wire [8:0] accelX, accelY;
    wire [11:0] accelTmp;
    
    accelerometer accel(clock, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
    
    wire [31:0] lights_val, sound_val;
    
    //Sound
    //These are periods (in units of 10 ns) for the notes on the normal C4 scale,
    //   i.e.:  C4, D4, E4, F4, G4, A4, B4, C5
    wire [31:0] notes_periods[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
    wire unsigned [31:0] period;
    sound_reg sound_reg(.clock(clock), .sound_wr(sound_wr), .sound_val(sound_val), .audEn(audEn), .period(period));
    montek_sound_Nexys4 sound(clock, period, audPWM);
    
    
    //Keyboard
    keyboard keyboard(.clock(clock), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .keyb_char(keyb_char));
    
    
    //LED
    LED_reg led(.clock(clock), .lights_wr(lights_wr), .lights_val(lights_val), .LED(LED));
    
    
    //Memory Mapper
    assign mem_readdata = (mem_addr[17:16] == 2'b01) ? dmem_readdata :
                            (mem_addr[17:16] == 2'b10) ? charcode :
                            (mem_addr[17:16] == 2'b11) ? ((mem_addr[3:2] == 2'b00) ? keyb_char : 32'b0) : 32'b0;
                                
    wire dmem_wr, smem_wr, sound_wr, lights_wr;
    assign dmem_wr = (mem_addr[17:16] == 2'b01 && mem_wr) ? 1'b1 : 1'b0;
    assign smem_wr = (mem_addr[17:16] == 2'b10 && mem_wr) ? 1'b1 : 1'b0;
    assign sound_wr = (mem_addr[17:16] == 2'b11 && mem_addr[3:2] == 2'b10 && mem_wr) ? 1'b1 : 1'b0;
    assign lights_wr = (mem_addr[17:16] == 2'b11 && mem_addr[3:2] == 2'b11 && mem_wr) ? 1'b1 : 1'b0;
    
endmodule
