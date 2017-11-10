`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/full_imem.mem",
    //parameter imem_init="E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/imem_screentest_nopause.mem",
    parameter dmem_init="E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/full_dmem.mem",
    parameter smem_init="E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/smem_screentest.mem",
    parameter bmem_init="E:/Vivado/Projects/ProjectA/ProjectA.srcs/sources_1/new/bmem_screentest.mem"
)(
    input wire clock, reset,

    //Keyboard
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
    output wire [15:0] LED,
    
    //VGA
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
);
    wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
    wire mem_wr;
    wire clock100, clock50, clock25, clock12;

    wire [10:0] smem_addr;
    wire [3:0] charcode;
    wire [31:0] keyb_char;
    wire enable = 1'b1;			// we will use this later for debugging

    // Uncomment *only* one of the following two lines:
    //    when synthesizing, use the first line
    //    when simulating, get rid of the clock divider, and use the second line
    //
    clockdivider_Nexys4 clockdv(clock, clock100, clock50, clock25, clock12);   // use this line for synthesis/board deployment
    //assign clock100=clock; assign clock50=clock; assign clock25=clock; assign clock12=clock;  // use this line for simulation/testing

    // For synthesis:  use an appropriate clock frequency(ies) below
    //   clock100 will work for hardly anyone
    //   clock50 or clock 25 should work for the vast majority
    //   clock12 should work for everyone!  I'd say use this!
    //
    // Use the same clock frequency for the MIPS and data memory/memIO modules
    // The VGA display and 8-digit display should keep the 100 MHz clock.
    // For example:

    mips mips(.clock(clock12), .reset(reset), .enable(enable), .pc(pc), .instr(instr), .mem_wr(mem_wr), .mem_addr(mem_addr), 
                                            .mem_writedata(mem_writedata), .mem_readdata(mem_readdata));
                                            
    //Need to change the Nloc variable for the imem depending on the amount of instructions
    imem #(.Nloc(256), .Dbits(32), .initfile(imem_init)) imem(.pc(pc[31:0]), .instr(instr));
   
    memIO #(.Nloc(16), .Dbits(32), .dmem_init(dmem_init), .smem_init(smem_init)) memIO(.clock(clock12), .mem_addr(mem_addr), .mem_wr(mem_wr),
                                                    .mem_readdata(mem_readdata), .mem_writedata(mem_writedata), .smem_addr(smem_addr), 
                                                    .charcode(charcode), .keyb_char(keyb_char), .accelX(accelX), .accelY(accelY),
                                                    .LED(LED), .audEn(audEn), .period(period));

    //VGA
    wire [11:0] RGB;
    assign red = RGB[11:8];
    assign green = RGB[7:4];
    assign blue = RGB[3:0];
    vgadisplaydriver #(.bmem_init(bmem_init)) display(.clock(clock100), .RGB(RGB), .hsync(hsync), .vsync(vsync), .charcode(charcode), .screenaddr(smem_addr));
    

    //Accel
    wire [8:0] accelX, accelY;
    wire [11:0] accelTmp;
    accelerometer accel(clock12, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);

        
    //Sound
    //These are periods (in units of 10 ns) for the notes on the normal C4 scale,
    //   i.e.:  C4, D4, E4, F4, G4, A4, B4, C5
    wire [31:0] notes_periods[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
    wire unsigned [31:0] period;
    montek_sound_Nexys4 sound(clock100, period, audPWM);
        
        
    //Keyboard
    keyboard keyboard(.clock(clock12), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .keyb_char(keyb_char));
    

endmodule