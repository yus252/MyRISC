// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
// Lookup table acts like a function: here Target = f(Addr);
//  in general, Output = f(Input); 
module LUT(
  input       [ 4:0] Addr,
  output logic[ 9:0] Target
  );

always_comb 
  case(Addr)		   //-16'd30;
	5'b00000: Target = 10'b0001100000; // [6,5] => 1100000
	5'b00001: Target = 10'b0001001000; // [6,3] => 1001000
	5'b00010: Target = 10'b0001111000; // [6,5,4,3] => 1111000
	5'b00011: Target = 10'b0001110010; // [6,5,4,1] => 1110010
	5'b00100: Target = 10'b0001101010; // [6,5,3,1] => 1101010
	5'b00101: Target = 10'b0001101001; // [6,5,3,0] => 1101001
	5'b00110: Target = 10'b0001011100; // [6,4,3,2] => 1011100
	5'b00111: Target = 10'b0001111110; // [6,5,4,3,2,1] => 1111110
	5'b01000: Target = 10'b0001111011; // [6,5,4,3,1,0] => 1111011
	5'b01001: Target = 10'b0000100000; // 0x20 (space char)
	5'b01010: Target = 10'b0000111101; // 61
	5'b01011: Target = 10'b0001111111; // 127
	5'b01100: Target = 10'b0001000000; // 64
	
	// Need to add branch address
	default: Target = 10'h001; 
  endcase

endmodule
