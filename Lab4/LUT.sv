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
	// tap patterns 
	5'b00000: Target = 10'b0001100000; // [6,5] => 1100000
	5'b00001: Target = 10'b0001001000; // [6,3] => 1001000
	5'b00010: Target = 10'b0001111000; // [6,5,4,3] => 1111000
	5'b00011: Target = 10'b0001110010; // [6,5,4,1] => 1110010
	5'b00100: Target = 10'b0001101010; // [6,5,3,1] => 1101010
	5'b00101: Target = 10'b0001101001; // [6,5,3,0] => 1101001
	5'b00110: Target = 10'b0001011100; // [6,4,3,2] => 1011100
	5'b00111: Target = 10'b0001111110; // [6,5,4,3,2,1] => 1111110
	5'b01000: Target = 10'b0001111011; // [6,5,4,3,1,0] => 1111011
	// constants 
	5'b01001: Target = 10'b0000100000; // 0x20 (space char)
	5'b01010: Target = 10'b0000111101; // 61
	5'b01011: Target = 10'b0010000000; // 128
	5'b01100: Target = 10'b0001000000; // 64
   	// branch targets (program1) 
	//5'b01101: Target = 10'b0000101010; // [13]: 42
   	5'b01110: Target = 10'b0001101001; // [14]: 105
	5'b01111: Target = 10'b0001001100; // [15]: 76
   	5'b10000: Target = 10'b0010011100; // [16]: 156
   	5'b10001: Target = 10'b0001110010; // [17]: 114
	5'b10010: Target = 10'b0010010100; // [18]: 148
	// branch targets (program2) 
	5'b10011: Target = 10'b0000000111; // 7
	5'b10100: Target = 10'b0000110001; // 49
	5'b10101: Target = 10'b0000110100; // 52
	5'b10110: Target = 10'b0000111001; // 57
	5'b10111: Target = 10'b0000111110; // 62
	5'b11000: Target = 10'b0001001010; // 74
	// TODO: branch targets (program3)
	5’b11001: Target = 10'b0000100111; // [25] : 39, WHILE_LOOP
	5’b11010: Target = 10'b0000110110; // [26] : 53, LOOP_CHECKING1
	5’b11011: Target = 10'b0010000000; // [27] : 0x80
	5’b11100: Target = 10'b0000111011; // [28] : 115, AFTER_IF
	5’b11101: Target = 10'b0001001000; // [29] : 72, FOR_LOOP2
	
	default: Target = 10'h001; 
  endcase

endmodule
