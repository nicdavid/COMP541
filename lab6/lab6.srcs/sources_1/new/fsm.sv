//////////////////////////////////////////////////////////////////////////////////
// Montek Singh
// 9/28/2017 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module fsm (
    input wire clock,
    input wire up, down, center,                // List of inputs to FSM
    output logic countup = 1,                   // List of outputs of FSM
    output logic paused = 0
    );


    // The next line is our state encoding
    // You enumerate states, and the compiler decides state encoding
    enum {COUNT_UP, PAUSING_UP, PAUSED_UP, RESUMING_UP, COUNT_DOWN, PAUSING_DOWN, PAUSED_DOWN, RESUMING_DOWN } state, next_state;

    
    // Instantiate the state storage elements (flip-flops)
    always_ff @(posedge clock)
        state <= next_state;
        


    // Define next_state logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"
    always_comb     
        case (state)
            //Counting Up
            COUNT_UP: next_state <= center ? PAUSING_UP : (down ? COUNT_DOWN : COUNT_UP);
            PAUSING_UP: next_state <= center ? PAUSING_UP : PAUSED_UP;
            PAUSED_UP: next_state <= center ? RESUMING_UP : (down ? PAUSED_DOWN : PAUSED_UP);
            RESUMING_UP: next_state <= center ? RESUMING_UP : COUNT_UP;
            
            //Counting Down
            COUNT_DOWN: next_state <= center ? PAUSING_DOWN : (up ? COUNT_UP : COUNT_DOWN);
            PAUSING_DOWN: next_state <= center ? PAUSING_DOWN : PAUSED_DOWN;
            PAUSED_DOWN: next_state <= center ? RESUMING_DOWN : (up ? PAUSED_UP : PAUSED_DOWN);
            RESUMING_DOWN: next_state <= center ? RESUMING_DOWN : COUNT_DOWN;
            
            default: next_state <= state;
    endcase
    


    // Define output logic => combinational
    // Every case must either be a conditional expression
    //   or an "if" with a matching "else"
    always_comb  
        case (state)
            //Counting Up
            COUNT_UP: begin
                countup <= 1'b1; 
                //paused <= 1'b0;
            end
            PAUSING_UP: begin
                //countup <= 1'b1;
                paused <= 1'b1;
            end
            PAUSED_UP: begin
                countup <= 1'b1;
                //paused <= 1'b1;
            end
            RESUMING_UP: begin
                //countup <= 1'b1;
                paused <= 1'b0;
            end
            
            //Counting Down
            COUNT_DOWN: begin
                countup <= 1'b0;
                //paused <= 1'b0;
            end
            PAUSING_DOWN: begin
                //countup <= 1'b0;
                paused <= 1'b1;
            end
            PAUSED_DOWN: begin
                countup <= 1'b0;
                //paused <= 1'b1;
            end
            RESUMING_DOWN: begin
                //countup <= 1'b0;
                paused <= 1'b0;
            end
            
            default: begin
                countup <= 1'b1;
                paused <= 1'b0;
            end
        endcase
        
        

endmodule