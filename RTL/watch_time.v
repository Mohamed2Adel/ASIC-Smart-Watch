module Watch_time (
input wire switch_digit_A,
input wire increment_C,
input wire enable,
input wire CLK,
input wire reset,
output reg done,
output reg [3:0] H1,H0,M1,M0
);

reg [1:0] selected_digit;
reg [5:0] seconds;
always@(posedge CLK or posedge reset)
 begin
    if(reset) begin
    H1 <= 0;
    H0 <= 0;
    M1 <= 0;
    M0 <= 0;
    seconds <= 0;
    selected_digit <= 0;
    end
    else begin
    if(!enable) begin
      selected_digit = 0;  
      if(H1 == 2 && H0 == 3 && M1 == 5 && M0 == 9 && seconds == 59) begin //midnight
      H1 <= 0;
      H0 <= 0;
      M1 <= 0;
      M0 <= 0;
      seconds <= 0;
    end
    else if(H0 == 9 && M1 == 5 && M0 == 9 && seconds == 59) begin //1st hour digit should increment
      H1 <= H1 + 1;
      H0 <= 0;
      M1 <= 0;
      M0 <= 0;
      seconds <= 0;
    end
    else if(M1 == 5 && M0 == 9 && seconds == 59) begin //2nd hour digit should increment
      H0 <= H0 + 1;
      M1 <= 0;
      M0 <= 0;
      seconds <= 0;
    end
    else if(M0 == 9 && seconds == 59) begin //1st Minute digit should increment
      M1 <= M1 + 1;
      M0 <= 0;
      seconds <= 0;
    end
    else if(seconds == 59) begin //2nd Minute digit should increment
      M0 <= M0 + 1;
      seconds <= 0;
    end
    else begin 
      seconds <= seconds + 1; //seconds incrementing    
    end
    end
    else begin
      if(switch_digit_A == 1)
      selected_digit <= selected_digit + 1; 
      if(increment_C == 1) begin
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
    end   
 end

always@(*) begin
if (selected_digit == 3) //when at the final digit, done flag is high to go to the next mode
 done = 1;
else
 done = 0; 
end
endmodule  