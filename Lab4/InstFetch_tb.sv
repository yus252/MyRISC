module InstFetch_tb();

logic		Reset = 1'b1,		   // reset, init, etc. -- force PC to 0 
			Start = 1'b0,		   // begin next program in series
			Clk = 1'b0,			   // PC can change on pos. edges only
			BranchAbs = 1'b0,	   // jump unconditionally to Target value	   
			BranchLT = 1'b0, 		 
			BranchEQ = 1'b0,
			EQ = 1'b0,
			LT = 1'b0;
logic [9:0] Target = 10'b0;		   // jump ... "how high?"

wire  [9:0] ProgCtr;   

InstFetch InstFetch1(.*);
 
always begin
	#5ns Clk = 1'b1;
	#5ns Clk = 1'b0;
end

initial begin

  // Reset 
  $display("Reset");
  #20ns $display("PC: %b", ProgCtr);
	    $display("Expected %b", 10'b0);
  $display();	
	
  // Start 
  $display("Start");
  #20ns Reset = 1'b0;
		Start = 1'b1;
  #20ns $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b0);
  $display();	
	
  // PC clock inc 
  $display("PC inc");
  #20ns Start = 1'b0;
  #6ns  $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1);
  #100ns $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1011);
  $display();
  
  // BranchAbs
  $display("BranchAbs");
  #19ns BranchAbs = 1'b1;
		Target = 10'b1111_1110;
  #10ns  $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1111_1110);
  $display();
  
  // BranchLT
  $display("BranchLT");
  #20ns BranchAbs = 1'b0;
		BranchLT = 1'b1;
		Target = 10'b1110;
  #10ns $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1111_1111);
  #5ns  LT = 1'b1;
  #10ns  $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1110);
  $display();
  
  // BranchLT
  $display("BranchLT");
  #20ns BranchLT = 1'b0;
		BranchEQ = 1'b1;
		Target = 10'b1111_0000;
  #10ns  $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1111);
  #5ns  EQ = 1'b1;
  #10ns  $display("PC: %b", ProgCtr);
		$display("Expected %b", 10'b1111_0000);
  $display();
  
  #60ns $stop;
  

end 


endmodule 