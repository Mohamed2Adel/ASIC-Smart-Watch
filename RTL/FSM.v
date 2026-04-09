/////////////////////////////////////
///////////// Moore FSM ///////////// 
/////////////////////////////////////

module WATCH_FSM (
input  wire        B, C,
input  wire        reset,
input  wire        CLK,
input  wire        Timesetting_done,Alarm_done,Stopwatch_done,
output reg   Timesetting_enable,Alarm_enable,Stopwatch_enable,
output reg  [1:0]  mux_sel //used to select which mode output is displayed
);

localparam  [1:0]    Timekeeping = 2'b00,
                     Alarm = 2'b01,
                     Stopwatch = 2'b10,
                     Timesetting = 2'b11;

reg    [1:0]  			 count;	 
reg    [2:0]         current_state,
                     next_state ;
		
// state transition 		
always @(posedge CLK or posedge reset)
 begin
  if(reset)
   begin
     current_state <= Timekeeping ;
   end
  else
   begin
     current_state <= next_state ;
   end
 end
 
// next_state logic
always @(*)
 begin
  case(current_state)
  Timekeeping     : begin
              if(B)
			         next_state = Alarm ;
              else
               next_state = Timekeeping ;		  
             end
  Alarm    : begin
			         if(B && Alarm_done)
			         next_state = Stopwatch ;
              else
               next_state = Alarm ;
             end 
  Stopwatch  :  begin
               if(B && Stopwatch_done)
			         next_state = Timesetting ;
               else
               next_state = Stopwatch ;
             end	
  Timesetting  :  begin
               if(B && Timesetting_done)
			         next_state = Timekeeping ;
               else
               next_state = Timesetting ;
             end                                    	   
  endcase
end	

// next_state logic
always @(*)
 begin
  case(current_state)
  Timekeeping     : begin
              Timesetting_enable  =  1'b0 ;		
              Alarm_enable    =  1'b0 ;	
              Stopwatch_enable =  1'b0 ;
              mux_sel =  2'b00 ;
              end  
  Alarm    : begin
			        Timesetting_enable  =  1'b0 ;		
              Alarm_enable    =  1'b1 ;	
              Stopwatch_enable =  1'b0 ;
              mux_sel =  2'b01 ;
             end
  Stopwatch  :  begin
              Timesetting_enable  =  1'b0 ;		
              Alarm_enable    =  1'b0 ;	
              Stopwatch_enable =  1'b1 ;
              mux_sel =  2'b10 ;
             end
  Timesetting  :  begin
              Timesetting_enable  =  1'b1 ;		
              Alarm_enable    =  1'b0 ;	
              Stopwatch_enable =  1'b0 ;
              mux_sel =  2'b00 ;
             end
  endcase
 end
		
endmodule					 
