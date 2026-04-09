module stopwatch (
	input	wire		enable, start_C, split_A,
	input	wire		CLK, RST,
	output	wire [3:0]	m1_out, m0_out, s1_out, s0_out,
	output	reg		done
);

reg count;
reg [3:0]	m1_0, m0_0, s1_0, s0_0; //mem 0
reg [3:0]	m1, m0, s1, s0; //original timer

reg	mem;	//select of output mux

assign {m1_out, m0_out, s1_out, s0_out} = (!mem) ? {m1, m0, s1, s0} : {m1_0, m0_0, s1_0, s0_0};

always@(posedge CLK or posedge RST)
	begin
		if (RST)
			begin
				done <= 0;
				count <= 0;
				mem <= 0;
				{m1, m0, s1, s0} <= 0;
				{m1_0, m0_0, s1_0, s0_0} <= 0;
			end
		else
			begin
				if (enable)
					begin
						if (start_C && !count)		count <= 1; //start and stop stopwatch
						else if (start_C && count)	begin
							count <= 0;
							done <= 1;
						end
						
						if (split_A && !count)		
							begin
								//clear
								
								mem <= 0;
								{m1, m0, s1, s0} <= 0;
								{m1_0, m0_0, s1_0, s0_0} <= 0;
							end
						else if (split_A && count)	//split
							begin
								//store then {display/return to timer}
								{m1_0, m0_0, s1_0, s0_0} <= {m1, m0, s1, s0};
								mem <= !mem;
							end
						
						if (count) //stopwatch counter
							begin
								if (s0 == 6'd9)	
									begin
										s0 <= 0;
										if (s1 == 6'd5)
											begin
												s1 <= 0;
												if (m0 == 6'd9)
													begin
														m0 <= 0;
														if (m1 == 6'd5)
															begin
																m1 <= 0;
															end
														else	m1 <= m1 + 1;
													end
												else	m0 <= m0 + 1;
											end
										else	s1 <= s1 + 1;
									end
								else	s0 <= s0 + 1;
							end
						
						
					end
				else	
					begin
						done <= 0;
						count <= 0;
						mem <= 0;
						{m1, m0, s1, s0} <= 0;
						{m1_0, m0_0, s1_0, s0_0} <= 0;
					end
			end
	end


endmodule