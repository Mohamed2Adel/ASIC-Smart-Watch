module Alarm (
input wire switch_digit_A,
input wire increment_stop_C,
input wire CLK,//clk in seconds if there is no clk divider
input wire reset,
input wire enable,
input wire [3:0] H1_in,H0_in,M1_in,M0_in,
output reg done,
output reg [3:0] H1,H0,M1,M0,
output reg Alarm_beep
);

reg Alarm_Mode;//Alarm active or not
reg [1:0] selected_digit;
reg [4:0] alarm_count;
always@(posedge CLK or posedge reset)
 begin
    if(reset) begin
    H1 <= 0;
    H0 <= 0;
    M1 <= 0;
    M0 <= 0;
    selected_digit <= 0;
    Alarm_Mode <= 0;
    alarm_count <= 0;
    Alarm_beep <= 0;
    end
    else if (enable) begin    
    if(switch_digit_A == 1)
    selected_digit <= selected_digit + 1;


    if(increment_stop_C) begin
    Alarm_Mode <= 1;//if alarm time is modified then it's active
    case (selected_digit)
    2'b00 : if (H1 == 2 || (H1 == 1 && H0 > 3)) //incrementing 1st hour digit
            H1 <= 0;  
            else 
            H1 = H1 + 1;                 
    2'b01 : if (H0 == 9 || (H1 == 2 && H0 == 3)) //incrementing 2nd hour digit
            H0 <= 0;  
            else 
            H0 <= H0 + 1;                   
    2'b10 : if (M1 == 5) //incrementing 1st minute digit
            M1 <= 0;  
            else 
            M1 <= M1 + 1;                   
    2'b11 : if (M0 == 9) //incrementing 2nd minute digit
            M0 <= 0;  
            else 
            M0 <= M0 + 1;                    
endcase          
    end
    end 
    else 
    selected_digit <= 0;
    if (Alarm_beep) begin
    if(alarm_count == 19) begin //after 20 seconds Alarm beep turns off
    Alarm_beep <= 0;
    Alarm_Mode <= 0;
    end
    else
    alarm_count <= alarm_count + 1; //counting how long alarm beep is on
    end 
    end  

always@(*) begin
    if(H1 == H1_in && H0 == H0_in && M1 == M1_in && M0 == M0_in && Alarm_Mode) //when the current time matches with the alarm time, alarm_beep is active
    Alarm_beep = 1;

    if (selected_digit == 3) //when at the final digit, done flag is high to go to the next mode
    done = 1;
    else
    done = 0; 
end

endmodule  