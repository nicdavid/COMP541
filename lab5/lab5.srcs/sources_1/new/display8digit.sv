//////////////////////////////////////////////////////////////////////////////////
// Nick Barnette
// 9/25/2017 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module display8digit(
    input wire [31:0] val,
    input wire clock,
    output logic [7:0] segments,
    output logic [7:0] digitselect
    );

	logic [31:0] c = 0;					// Used for round-robin digit selection on display
	logic [2:0] topfour;
	logic [3:0] value4bit;
	
	always_ff @(posedge clock)
		c <= c + 1'b 1;
	
	assign topfour[2:0] = c[20:17];		// Used for round-robin digit selection on display
//	assign topfour[2:0] = c[25:22];     // Try this instead to slow things down!

	
	assign digitselect[7:0] = ~ (  			// Note inversion
                           topfour == 3'b000 ? 8'b 0000_0001  
                         : topfour == 3'b001 ? 8'b 0000_0010
                         : topfour == 3'b010 ? 8'b 0000_0100
                         : topfour == 3'b011 ? 8'b 0000_1000
                         : topfour == 3'b100 ? 8'b 0001_0000
                         : topfour == 3'b101 ? 8'b 0010_0000
                         : topfour == 3'b110 ? 8'b 0100_0000
                         : 8'b 1000_0000 );
		
	assign value4bit   =   (
				  topfour == 3'b000 ? val[3:0]
				: topfour == 3'b001 ? val[7:4]
				: topfour == 3'b010 ? val[11:8]
				: topfour == 3'b011 ? val[15:12]
				: topfour == 3'b100 ? val[19:16]
				: topfour == 3'b101 ? val[23:20]
				: topfour == 3'b110 ? val[27:24] 
				: val[31:28] );
	
	hexto7seg myhexencoder(value4bit, segments);

endmodule