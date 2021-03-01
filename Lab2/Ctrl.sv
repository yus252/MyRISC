// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[8:0] Instruction,  // machine code
  output logic Stop,
	            Lookup,
					RegWrite,
					MemWrite,
               MemToReg,
               MUXWrite, // 0 means r0, 1 means rs  // mv r3  r3 = r0  // as r3 r0 = r3 r0
					MUXImm, // 0 means not i type, 1 mean use imm
					MUXLookup,
					MUXParamR1
  );
  logic[3:0] ROP;
  logic[3:0] IOP;
  
  always@* begin
    ROP = Instruction[7:4];
	 IOP[2:0] = Instruction[7:5];
    IOP[3] = 0;
  
    if(Instruction[8] == 0) begin
		// these cases use r1 as an extra parameter
		if(ROP == kXOR || ROP == kAND || ROP == kBLT || ROP == kBEQ)
			MUXParamR1 = 1;
		else
			MUXParamR1 = 0;
			
		if(ROP == kMV || ROP == kADD || ROP == kSUB || ROP == kXOR ||
	    	ROP == kAND || ROP == kXALL || ROP == kSLL) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 1;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
		else if(ROP == kAS) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
		else if(ROP == kB || ROP == kBLT || ROP == kBEQ) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 0;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
		else if(ROP == kLW) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 1;
        MUXWrite = 1;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
		else if(ROP == kSW) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 1;
		  MemWrite = 1;
        MemToReg = 0;
        MUXWrite = 1;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
		else if(ROP == kLUT) begin
		  Stop = 0;
	     Lookup = 1;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
		else if(ROP == kSTOP) begin
		  Stop = 1;
	     Lookup = 0;
		  RegWrite = 0;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 0;
		  MUXLookup = 0;
		end
    end
	 else begin
	   if(IOP == kLI) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 1;
		  MUXLookup = 0;
		end
		else if(IOP == kGBI || IOP == kSB0 ||
		  IOP == kSB1 || IOP == kADDI || IOP == kSUBI) begin
		  Stop = 0;
	     Lookup = 0;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 1;
		  MUXLookup = 0;
		end
		else if(IOP == kLUTI) begin
		  Stop = 0;
	     Lookup = 1;
		  RegWrite = 1;
		  MemWrite = 0;
        MemToReg = 0;
        MUXWrite = 0;
		  MUXImm = 1;
		  MUXLookup = 1;
		end
	 end
  end

endmodule

