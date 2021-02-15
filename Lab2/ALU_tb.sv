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
	
	/** Add **/
	
	// zeroes
	#20ns InputA = 8'b0;
	      InputB = 8'b0;
		  OP = 5'b10;
	
	// identity
	#20ns InputA = 8'b1;
		
	// simple add
	#20ns InputA = 8'd69;	
		  InputB = 8'd42; 
	
	// negative 
	#20ns InputA = 8'b1111_1111;	
		  InputB = 8'd5; 
	
	/** Mv **/

	// out should be 1 (A)
	#20ns InputA = 8'd1;
	      InputB = 8'd2;
		  OP = 5'b0;
		  
	/** As **/

	// out should be 2
	#20ns InputA = 8'd1;
	      InputB = 8'd2;
		  OP = 5'b1;
		  
	/** XOR **/ 
	
	// output should be 10101010
	#20ns InputA = 8'b0101_0101;
	      InputB = 8'b1111_1111;
		  OP = 5'b01001;
		  
	/** AND **/ 
	
	// output should be 0000 0101
	#20ns InputA = 8'b0101_0101;
	      InputB = 8'b0000_1111;
		  OP = 5'b01010;
		  
	/** XALL **/ 
	
	// output should be 0
	#20ns InputB = 8'b0000_1111;
		  OP = 5'b01011;
	
	// output should be 1
	#20ns InputB = 8'b0111_1111;
	
	
	/** sll **/ 
	
	// output should be 1010 1011
	#20ns InputA = 8'b0101_0101;
	      InputB = 8'b1;
		  OP = 5'b01101;
		  
	// output should be 1010 1010
    #20ns InputA = 8'b0101_0101;
		  InputB = 8'b0;
		  
	
	#60ns $stop;
	
	
	
end



endmodule