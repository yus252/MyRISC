//This file defines the parameters used in the alu
// CSE141L
package definitions;	 
	 
// Instruction map
    const logic [3:0]kMV = 4'b0000;
    const logic [3:0]kAS = 4'b0001;
    const logic [3:0]kADD = 4'b0010;
    const logic [3:0]kSUB = 4'b0011;
    const logic [3:0]kB = 4'b0100;
	 const logic [3:0]kBLT = 4'b0101;
	 const logic [3:0]kBEQ = 4'b0110;
	 const logic [3:0]kLW = 4'b0111;
    const logic [3:0]kSW = 4'b1000;
    const logic [3:0]kXOR = 4'b1001;
	 const logic [3:0]kAND = 4'b1010;
	 const logic [3:0]kXALL = 4'b1011;
	 const logic [3:0]kLUT = 4'b1100;
	 const logic [3:0]kSLL = 4'b1101;
	 const logic [3:0]kSTOP = 4'b1111;
	 
	 const logic [3:0]kLI = 4'b0000;
	 const logic [3:0]kGBI = 4'b0001;
	 const logic [3:0]kSB0 = 4'b0010;
	 const logic [3:0]kSB1 = 4'b0011;
	 const logic [3:0]kADDI = 4'b0100;
	 const logic [3:0]kSUBI = 4'b0101;
	 const logic [3:0]kLUTI = 4'b0110;

endpackage // definitions
