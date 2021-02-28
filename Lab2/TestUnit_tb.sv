
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

