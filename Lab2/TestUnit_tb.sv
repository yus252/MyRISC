
module TestUnit_tb;	     // Lab 17

// To DUT Inputs
  bit  Init = 'b1,
       Req,
       Clk;

  logic [8:0] Instruction;
  
// From DUT Outputs
  wire Ack;		   // done flag

// Instantiate the Device Under Test (DUT)
  TopLevel DUT (
    .Reset  (Init)  ,
	.Start  (Req )  , 
	.Clk    (Clk )  , 
	.Instruction (Instruction) ,
	.Ack    (Ack )             
	);

initial begin
  #10ns Init = 'b0;
  #10ns Req  = 'b1;
// Initialize DUT's data memory
  #10ns for(int i=0; i<256; i++) begin
    DUT.DM1.Core[i] = 8'h0;	     // clear data_mem
    DUT.DM1.Core[1] = 8'h03;      // MSW of operand A
    DUT.DM1.Core[2] = 8'hff;
    DUT.DM1.Core[3] = 8'hff;      // MSW of operand B
    DUT.DM1.Core[4] = 8'hfb;
  end
// students may also pre_load desired constants into DM
// Initialize DUT's register file
  for(int j=0; j<16; j++)
    DUT.RF1.Registers[j] = 8'b0;    // default -- clear it
// students may pre-load desired constants into the reg_file
    
// launch prodvgram in DUT
  #10ns Req = 0;

/*
  // display all registers 
  for(int j=0; j<16; j++)
    $display("%d: %h", j, DUT.RF1.Registers[j]);
*/
  
  /****** I-type instructions ******/
  
  // instr: li 1 
  //   out: r0 = 1
  Instruction = 9'b1_000_00001;
  #10ns if(DUT.RF1.Registers[0] != 8'b1) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end

  // instr: addi 1 
  //   out: r0 = 2
  Instruction = 9'b1_100_00001;
  #10ns if(DUT.RF1.Registers[0] != 8'b10) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
  
  // instr: subi 1 
  //   out: r0 = 1
  Instruction = 9'b1_101_00001;
  #10ns if(DUT.RF1.Registers[0] != 8'b1) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: luti 11  
  //   out: r0 = 64
  Instruction = 9'b1_110_01011;
  #10ns if(DUT.RF1.Registers[0] != 8'b1000000) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
  
  // instr: sb1 0  
  //   out: r0 = 65
  Instruction = 9'b1_011_00000;
  #10ns if(DUT.RF1.Registers[0] != 8'b1000001) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
  
  // instr: sb0 0  
  //   out: r0 = 64
  Instruction = 9'b1_010_00000;
  #10ns if(DUT.RF1.Registers[0] != 8'b1000000) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: gbi 6  
  //   out: r0 = 1
  Instruction = 9'b1_001_00110;
  #10ns if(DUT.RF1.Registers[0] != 8'b1) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  /****** R-type instructions ******/
  
  // instr: mv r2  
  //   out: r2 = r0 = 1
  Instruction = 9'b0_0000_0010;
  #10ns if(DUT.RF1.Registers[2] != 8'b1 || DUT.RF1.Registers[0] != 8'b1) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: add r2  
  //   out: r0 = 1
  //        r2 = 2
  Instruction = 9'b0_0010_0010;
  #10ns if(DUT.RF1.Registers[2] != 8'b10) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: as r2  
  //   out: r0 = r2 = 2
  Instruction = 9'b0_0001_0010;
  #10ns if(DUT.RF1.Registers[0] != 8'b10 || DUT.RF1.Registers[2] != 8'b10) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: sub r2  
  //   out: r0 = 2
  //        r2 = 0
  Instruction = 9'b0_0011_0010;
  #10ns if(DUT.RF1.Registers[2] != 8'b0) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
	
  // instr: blt r2
  //   out: PC = PC+1 (branch not taken)
  Instruction = 9'b0_0101_0010;
  #10ns if(DUT.PgmCtr == 8'b0) begin
			$display("(ERROR) Instruction %b", Instruction);
			$display("PC = %d", DUT.PgmCtr);
			$stop;
		end
		
  // instr: beq r2
  //   out: PC = PC+1 (branch not taken)
  Instruction = 9'b0_0110_0010;
  #10ns if(DUT.PgmCtr == 8'b0) begin
			$display("(ERROR) Instruction %b", Instruction);
			$display("PC = %d", DUT.PgmCtr);
			$stop;
		end
		
  // instr: b r2
  //   out: PC = 0 (branch taken)
  Instruction = 9'b0_0100_0010;
  #10ns if(DUT.PgmCtr != 8'b0) begin
			$display("(ERROR) Instruction %b", Instruction);
			$display("PC = %d", DUT.PgmCtr);
			$stop;
		end
		
  // instr: sll r1  
  //   out: r0 = 2
  //        r1 = 4
  Instruction = 9'b0_1101_0001;
  #10ns if(DUT.RF1.Registers[1] != 8'b100) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: xor r3
  //   out: r0 = 2 
  //        r1 = 4 
  // 		r3 = 6 
  Instruction = 9'b0_1001_0011;
  #10ns if(DUT.RF1.Registers[3] != 8'b110) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: blt r3
  //   out: PC = 6 (branch taken) 
  Instruction = 9'b0_0101_0011;
  #10ns if(DUT.PgmCtr != 8'b110) begin
			$display("(ERROR) Instruction %b", Instruction);
			$display("PC = %d", DUT.PgmCtr);
			$stop;
		end
  
  // instr: lut r3
  //   out: r0 = 8'b1111110
  Instruction = 9'b0_1100_0011;
  #10ns if(DUT.RF1.Registers[0] != 8'b1111110) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: xall r0
  //   out: r0 = 0
  Instruction = 9'b0_1011_0000;
  #10ns if(DUT.RF1.Registers[0] != 8'b0) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  // instr: xall r1
  //   out: r1 = 1
  Instruction = 9'b0_1011_0001;
  #10ns if(DUT.RF1.Registers[1] != 8'b1) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end

  // instr: and r3
  //   out: r3 = 0
  Instruction = 9'b0_1010_0011;
  #10ns if(DUT.RF1.Registers[3] != 8'b0) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
		
  /** Data Memory tests **/
  
  // instr: sw r2
  //   out: mem[61] = 15
  Instruction = 9'b1_110_01001; 		// lut 9 (r0 = 61)
  #10ns Instruction = 9'b0_000_00010;	// mv r2 (r2 = 61) 
  #10ns Instruction = 9'b1_000_01111;	// li 15 (r0 = 15)
  #10ns Instruction = 9'b0_1000_0010;   // sw r2 (mem[61] = 15) 
  #10ns if(DUT.DM1.Core[61] != 8'b1111) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end
 
  // instr: lw r3  
  //   out: r3 = 15
  Instruction = 9'b0_0001_0010;			// as r2 (r0 = 61)
  #10ns Instruction = 9'b0_0111_0011;   // lw r3 (r3 = mem[61] = 15)
  #10ns if(DUT.RF1.Registers[3] != 8'b1111) begin
			$display("(ERROR) Instruction %b", Instruction);
			$stop;
		end

		
  #10ns $stop;
  
/*  
// Wait for done flag, then display results
  wait (Ack);
  #10ns $displayh(DUT.DM1.Core[5],
                  DUT.DM1.Core[6],"_",
                  DUT.DM1.Core[7],
                  DUT.DM1.Core[8]);
//        $display("instruction = %d %t",DUT.PC,$time);
  #10ns $stop;			  
*/
end

always begin   // clock period = 10 Verilog time units
  #5ns  Clk = 'b1;
  #5ns  Clk = 'b0;
end
      
endmodule

