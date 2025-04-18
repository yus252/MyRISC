// Create Date:    2018.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;                 // includes package "definitions"
module ALU(
   input        [7:0] InputA,           // r0
                      InputB,           //rs/imm/r1
   input        [4:0] OP,		         // ALU opcode, part of microcode
   output logic [7:0] Out,		         // or:  output reg [7:0] OUT,
   output logic 		EQ,
   output logic 		LT
);								    
  logic[3:0] ROP;
  logic[3:0] IOP;
	
	
  always@* begin
    ROP = OP[3:0] ;
    IOP[2:0] = OP[3:1];
    IOP[3] = 0;
  
    Out = 0;                           // No Op = default
    if(OP[4] == 0) begin
		case(ROP)
		  kMV: Out = InputA; 
		  kAS: Out = InputB; 
        kADD: Out = InputA + InputB; 
		  kSUB: Out = InputA - InputB; 
		  kB: Out = 0; // Don't care
		  kBLT: LT = InputA < InputB ? 1'b1: 1'b0; // set flag
		  kBEQ: EQ = InputA == InputB ? 1'b1 : 1'b0; // set flag
		  kLW: Out = InputA;
		  kSW: Out = InputA;
		  kXOR: Out = InputA ^ InputB;
		  kAND: Out = InputA & InputB;
		  kXALL: Out = ^InputB;
		  kLUT: Out = InputB;
        kSLL: Out = (InputA << 1) | InputB; // InputB always 1'b 
		  kSTOP: Out = 8'b0; // Don't care 
      endcase
	 end
	 else begin
		case(IOP)
		  kLI: Out = InputB;
		  kGBI: Out = {7'b0000000, InputA[InputB]};
		  kSB0: begin
			 Out = InputA;
			 Out[InputB] = 1'b0;
		  end
		  kSB1: begin
			 Out = InputA;
			 Out[InputB] = 1'b1;
		  end
		  kSUBI: Out = InputA - InputB;
		  kLUTI: Out = InputB;
		  kADDI: Out = InputA + InputB;
		endcase  
    end
  end
 

endmodule
