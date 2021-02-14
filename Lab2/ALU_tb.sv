module ALU_tb();

   logic        [7:0] InputA,        // r0
                      InputB;        // rs/imm/r1
   logic        [4:0] OP;		     // ALU opcode, part of microcode
   wire [7:0]   Out;		         // or:  output reg [7:0] OUT,
   wire 		EQ,
   	 		LT;

 ALU ALU1(.*);
 
 logic Clk = 1'b0;
 
always begin
	#5ns Clk = 1'b1;
	#5ns Clk = 1'b0;
end

initial begin
	
	/** Addition **/
	
	// zeroes
	#20ns InputA = 8'b0;
	      InputB = 8'b0;
		  OP = 5'b10;
	
	// identity
	#20ns InputA = 8'b1;
	
	// small add
	#20ns InputA = 8'd2;	
		  InputB = 8'd3;  
	
	// large add
	#20ns InputA = 8'd69;	
		  InputB = 8'd42; 
	
	// negative + positive 
	#20ns InputA = 8'b1111_1111;	
		  InputB = 8'd3; 
	
	// negative + negative 
	#20ns InputA = 8'b1111_1011;	
		  InputB = 8'b1111_1101; 		  
	
	#240ns $stop;
	
end



endmodule