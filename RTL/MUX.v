module MUX(
input wire [1:0] mux_sel,
input wire [3:0] H1_in1,H0_in1,M1_in1,M0_in1,H1_in2,H0_in2,M1_in2,M0_in2,H1_in3,H0_in3,M1_in3,M0_in3,H1_in4,H0_in4,M1_in4,M0_in4,
output reg  [3:0] H1_out,H0_out,M1_out,M0_out
);

always@(*)
 begin
    case(mux_sel)
    2'b00 : begin H1_out = H1_in1; 
                  H0_out = H0_in1;
                  M1_out = M1_in1;
                  M0_out = M0_in1;
            end
    2'b01 : begin H1_out = H1_in2; 
                  H0_out = H0_in2;
                  M1_out = M1_in2;
                  M0_out = M0_in2;
            end
    2'b10 : begin H1_out = H1_in3; 
                  H0_out = H0_in3;
                  M1_out = M1_in3;
                  M0_out = M0_in3;
            end
    2'b11 : begin H1_out = H1_in4; 
                  H0_out = H0_in4;
                  M1_out = M1_in4;
                  M0_out = M0_in4;
            end
    endcase
 end
endmodule