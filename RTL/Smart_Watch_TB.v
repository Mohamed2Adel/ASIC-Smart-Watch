// Smart_Watch_TB.v
// reset is active high
// 2 inputs port "mode" and "set" and 4 output port "clock_display" Hour1 , Hour0 , Min1 , Min0
// mode = A,B  ---- set=C;
// mode used for changing between states and select the digit to be set 
// set used to increment the selected digit

`timescale 100ms / 1ns // period = 10 x 100 ms = 1s
module WATCH_TOP_TB (
);

// Signal declaration
reg clk_tb;
reg reset_tb;
reg mode_tb;
reg set_tb;
wire [3:0] Hour1_tb; 
wire [3:0] Hour0_tb;
wire [3:0] Min1_tb;
wire [3:0] Min0_tb;
wire Alarm_beep_tb;

// Clock generation 
always #5 clk_tb = ~clk_tb; 

// Test stimulus
initial begin
    // Initialize inputs
    clk_tb = 0;
    reset_tb = 0;
    mode_tb = 0;
    set_tb = 0;
    #10;
    //1st case: Reset the watch so we will be at state TIME KEEPING mode with 00:00
    reset_tb = 1;
    #10;
    
    //2nd case: change to SET ALARM mode (12:30)
    reset_tb = 0;
    mode_tb = 1; // B=high
    #10;  // now we are in SET ALARM mode
    mode_tb = 0; // B=low for setting first digit to 1
    set_tb = 1; // C = high to increment
    #10; // increment Hour1 to 1 
    mode_tb = 1; // B=high to move to next digit 
    set_tb = 0; // C=low
    #10; 
    mode_tb = 0; // B=low for setting Hour0
    set_tb = 1; // C = high to increment
    #20; // increment Hour0 to 2
    mode_tb = 1; // B=high to move to next digit
    set_tb = 0; // C=low
    #10;
    mode_tb = 0; // B=low for setting Min1
    set_tb = 1; // C = high to increment 
    #30; // increment Min1 to 3
    mode_tb = 1; // B=high to move to next digit
    set_tb = 0; // C=low
    #10;
    mode_tb = 0; // B=low for setting Min0
    set_tb = 0; // C = low since Min0 we want to set is = 0
    #10; // wait for a moment
    // now the alarm time is set to 12:30

    // make a delay to wait for the time to be 12:30 and check if alarm triggers
    #500000; // wait for a long time to simulate time passing



    //3rd case: change to STOP WATCH mode 
    $display("stop watch case starts here %0d%0d:%0d%0d  @simulation time %0d", Hour1_tb, Hour0_tb, Min1_tb, Min0_tb, $time);
    mode_tb = 1; // B=high to go from last digit in SET ALARM to STOP WATCH mode
    #10;
    mode_tb = 1; // mode=high to START counting
    #10;
    mode_tb = 0; // mode=low to continue in counting
    #100; // wait for some time to let stopwatch count
    mode_tb = 1; // mode=high to stop counting
    #10; 


    //4th case: Reset the watch again 
    reset_tb = 1;
    mode_tb = 0;
    #10;
    reset_tb = 0;
    #10;
    // now we need to test TIME SETTING mode to (14:22)
    mode_tb = 1; // B=high to go throug modes and digits untill TIME SETTING mode
    #10; #10; #10; #10; #10; #10; #10; #10;  // 8 times to reach TIME SETTING mode
    mode_tb = 0; // stay in TIME SETTING mode to set Hour1
    set_tb = 1; // C=high to increment Hour1
    #10; // increment Hour1 to 1
    mode_tb = 1; // high to move to next digit Hour0 
    set_tb = 0; // C=low 
    #10; 
    mode_tb = 0; // low to set Hour0
    set_tb = 1; // set digit Hour0
    #40; // increment Hour0 to 4
    mode_tb = 1; // high to move to next digit Min1
    set_tb = 0; // C=low
    #10;
    mode_tb = 0; // low to set Min1
    set_tb = 1; // C=high to increment Min1
    #20; // increment Min1 to 2
    mode_tb = 1; // high to move to next digit Min0
    set_tb = 0; // C=low
    #10;
    mode_tb = 0; // low to set Min0
    set_tb = 1; // C=high to increment Min0
    #20; // increment Min0 to 2
    $display("Time is set to %0d%0d:%0d%0d  @simulation time %0d", Hour1_tb, Hour0_tb, Min1_tb, Min0_tb, $time);
    // now time is set to 14:22; 


    //5th case: test split in STOP WATCH mode
    //first reset to TIME KEEPING mode
    reset_tb = 1;
    mode_tb = 0;
    set_tb = 0;
    #10;
    reset_tb = 0;
    #10;
    // go to STOP WATCH mode
    mode_tb = 1; // B=high to go from TIME KEEPING to STOP WATCH mode
    #10; #10; #10; #10; #10; // 5 times to reach STOP WATCH
    // now we need to start counting and then split and then split release and then stop counting 
    mode_tb = 1; // mode=high to START counting
    #10;
    mode_tb = 0; // mode=low to continue in counting
    #100; // wait for some time to let stopwatch count
    set_tb = 1; // A=high to SPLIT
    #10;
    set_tb = 0; // A=low to stay in SPLIT
    #100; // wait for some time in SPLIT mode
    set_tb = 1; // A=high to RELEASE SPLIT
    #10;
    set_tb = 0; // A=low to continue counting
    #50; // wait for some time to let stopwatch count
    mode_tb = 1; // mode"c"=high to stop counting
    #100;
    $stop;
end


// Design instantiation

SMART_WATCH_TOP DUT (
.CLK(clk_tb),            
.reset(reset_tb), 
.mode_button(mode_tb),   
.set_button(set_tb),
.H1_out(Hour1_tb),
.H0_out(Hour0_tb),
.M1_out(Min1_tb),
.M0_out(Min0_tb),
.Alarm_beep(Alarm_beep_tb)
);

endmodule
