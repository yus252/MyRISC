module InstFetch_tb();

logic		Reset,			   // reset, init, etc. -- force PC to 0 
			Start,			   // begin next program in series
			Clk = 1'b0,			   // PC can change on pos. edges only
			BranchAbs,	       // jump unconditionally to Target value	   
			BranchLT, 		 
			BranchEQ,
			EQ,
			LT;
logic [9:0] Target,		   // jump ... "how high?"
wire  [9:0] ProgCtr;   

InstFetch InstFetch1(.*);
 
always begin
	#5ns Clk = 1'b1;
	#5ns Clk = 1'b0;
end

initial begin

// tests 

end 


endmodule 