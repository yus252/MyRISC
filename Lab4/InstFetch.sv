// Design Name:    basic_proc
// Module Name:    InstFetch 
// Project Name:   CSE141L
// Description:    instruction fetch (pgm ctr) for processor
//
// Revision:  2019.01.27
//
module InstFetch(
  input              Reset,			   // reset, init, etc. -- force PC to 0 
                     Start,			   // begin next program in series
                     Clk,			   // PC can change on pos. edges only
                     BranchAbs,	       // jump unconditionally to Target value	   
							BranchLT, 		 
							BranchEQ,
                     EQ,
							LT,
  input       [9:0] Target,		   // jump ... "how high?"
  output logic[9:0] ProgCtr           // the program counter register itself
  );
	 
// program counter can clear to 0, increment, or jump
  always_ff @(posedge Clk)	            // or just always; always_ff is a linting construct
	if(Reset)
	  ProgCtr <= 0;				        // for first program; want different value for 2nd or 3rd
	else if(Start)						// hold while start asserted; commence when released
	  ProgCtr <= ProgCtr;
	else if(BranchAbs || (BranchLT && LT) || (BranchEQ & EQ))	                // unconditional absolute jump
	  ProgCtr <= Target;	 
	else
	  ProgCtr <= ProgCtr+10'b1; 	        // default increment (no need for ARM/MIPS +4 -- why?)

endmodule

/* Note about Start: if your programs are spread out, with a gap in your machine code listing, you will want 
to make Start cause an appropriate jump. If your programs are packed sequentially, such that program 2 begins 
right after Program 1 ends, then you won't need to do anything special here. 
*/