`timescale 1ns / 1ps
`default_nettype none


module io_demo(
    input wire clock,
    
    //Display
    output wire [7:0] segments,
    output wire [7:0] digitselect,
    
    //Keyboard
    input wire ps2_data,
    input wire ps2_clk,
    
    //Sound
    output wire audPWM,
    output wire audEn,
    
    //Accel
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    //LEDs
    output wire [15:0] LED
    );
    
    // These are periods (in units of 10 ns) for the notes on the normal C4 scale,
    //   i.e.:  C4, D4, E4, F4, G4, A4, B4, C5
    wire [31:0] notes_periods[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
    
    
    //Gets the keycode
    wire [31:0] keyb_char;
    keyboard keyb(clock, ps2_clk, ps2_data, keyb_char);
    
    //Selects the correct sound
    wire unsigned [31:0] period;
    
    //Sets the sound to play
    assign audEn = 1;
    
    //Selects the correct period to play
    assign period = keyb_char == 8'b0001_0101 ? notes_periods[0] :
                    keyb_char == 8'b0001_1101 ? notes_periods[1] :
                    keyb_char == 8'b0010_0100 ? notes_periods[2] :
                    keyb_char == 8'b0010_1101 ? notes_periods[3] :
                    keyb_char == 8'b0010_1100 ? notes_periods[4] :
                    keyb_char == 8'b0011_0101 ? notes_periods[5] :
                    keyb_char == 8'b0011_1100 ? notes_periods[6] :
                    keyb_char == 8'b0100_0011 ? notes_periods[7] : 0;
    
    montek_sound_Nexys4 sound(clock, period, audPWM);
    
    //For debugging purposes
    //Displays the keycode on the display
    //display8digit disp(keyb_char, clock, segments, digitselect);
    
    
    
    //Accelerometer data
    wire [8:0] accelX, accelY;      // The accelX and accelY values are 9-bit values, ranging from 9'h 000 to 9'h 1FF
    wire [11:0] accelTmp;           // 12-bit value for temperature
    wire [31:0] display;
    
    
    //For debugging purposes
    //Outputs the Y value to the display
    //assign display[31:0] = {23'b0, accelY};
    //display8digit disp(display, clock, segments, digitselect);
    
    
    accelerometer accel(clock, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
    
    
    //Sets the LEDs that should be lit up
    //Intervals of 30 in decimal 
    assign LED[15:0] = (
        accelY < 9'b0_0011_1100 ? 16'b0000_0000_0000_0001 :     //60
        accelY < 9'b0_0101_1010 ? 16'b0000_0000_0000_0010 :     //90
        accelY < 9'b0_0111_1000 ? 16'b0000_0000_0000_0100 :     //120
        accelY < 9'b0_1001_0110 ? 16'b0000_0000_0000_1000 :     //150
        accelY < 9'b0_1011_0100 ? 16'b0000_0000_0001_0000 :     //180
        accelY < 9'b0_1101_0010 ? 16'b0000_0000_0010_0000 :     //210
        accelY < 9'b0_1111_0000 ? 16'b0000_0000_0100_0000 :     //240
        accelY < 9'b1_0000_1110 ? 16'b0000_0000_1000_0000 :     //270
        accelY < 9'b1_0010_1100 ? 16'b0000_0001_0000_0000 :     //300
        accelY < 9'b1_0100_1010 ? 16'b0000_0010_0000_0000 :     //330
        accelY < 9'b1_0110_1000 ? 16'b0000_0100_0000_0000 :     //360
        accelY < 9'b1_1000_0110 ? 16'b0000_1000_0000_0000 :     //390
        accelY < 9'b1_1010_0100 ? 16'b0001_0000_0000_0000 :     //420
        accelY < 9'b1_1100_0010 ? 16'b0010_0000_0000_0000 :     //450
        accelY < 9'b1_1110_0000 ? 16'b0100_0000_0000_0000 :     //480
        16'b1000_0000_0000_0000
    );
    
    
endmodule
