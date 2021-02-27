// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
	input [8:0]  Instruction, // TODO: used for unit testing
    output logic Ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
//wire [ 8:0] Instruction;   // our 9-bit opcode (TODO: commented out for unit testing)
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
wire        Stop,
	        Lookup,
			RegWrite,
			MemWrite,
            MemToReg,
            MUXWrite, // 0 means r0, 1 means rs
			MUXImm,
			MUXLookup;
wire[31:0]  LUTIndex;
wire        LUTOut;

logic[15:0] CycleCt;	   // standalone; NOT PC!

	// Fetch = Program Counter + Instruction ROM
	// Program Counter
	assign PCTarg = ReadB;
	InstFetch IF1 (
		.Reset       (Reset   ), 
		.Start       (Start   ),  // SystemVerilg shorthand for .halt(halt), 
		.Clk         (Clk     ),  // (Clk) is required in Verilog, optional in SystemVerilog
		.BranchAbs   (Instruction[8:4] == 5'b00101) , 
		.BranchLT	 (Instruction[8:4] == 5'b00110),
		.BranchEQ 	 (Instruction[8:4] == 5'b00111),  
		.LT	 		 (LT),
		.EQ	 	     (EQ),
		.Target      (PCTarg  ),
		.ProgCtr     (PgmCtr  )	   // program count = index to instruction memory
	);					  

	// Control decoder
	Ctrl Ctrl1 (
		.Instruction (Instruction), // from instr_ROM
		.Stop        (Stop),
		.Lookup      (Lookup),
		.RegWrite    (RegWrite),
		.MemWrite    (MemWrite),
		.MemToReg    (MemToReg),
		.MUXWrite    (MUXWrite), // 0 means r0, 1 means rs
		.MUXImm      (MUXImm)
	);
  
/*	// instruction ROM   (TODO: commented out for unit testing)
	InstROM #(.W(9)) IR1(
		.InstAddress   (PgmCtr), 
		.InstOut       (Instruction)
	);
*/
	assign Ack = &Instruction;
  
	// reg file
	assign WriteReg = MUXWrite == 0 ? 0 : Instruction[3:0]; // if MUXWrite = 0, write into r0. Else write into rs. 
	
	assign RegWriteValue = MemToReg == 1 ? MemReadValue : (Lookup == 1 ? LUTOut : ALU_out);

	RegFile #(.W(8),.D(3)) RF1 (
		.Clk    				  ,
		.WriteEn   (RegWrite)    ,
		.RaddrA    (0),         //r0
		.RaddrB    (Instruction[3:0]), // rs
		.Waddr     (WriteReg), 	       // mux above
		.DataIn    (RegWriteValue) , 
		.DataOutA  (ReadA        ) , 
		.DataOutB  (ReadB		 )
	);

	assign InA = ReadA;						          // connect RF out to ALU in
	assign InB = MUXImm == 0 ? ReadB : {3'b000, Instruction[4:0]};
    ALU ALU1(
	  .InputA  (InA),
	  .InputB  (InB), 
	  .OP      (Instruction[8:4]),
	  .Out     (ALU_out),//regWriteValue),
	  .EQ	  	  (EQ),
	  .LT		  (LT)
	  );
	
	
	assign LUTIndex = MUXLookup == 0 ? ReadB : Instruction[4:0]; // readb(rs) or imm
	LUT LUT1(
      .Addr (LUTIndex),
	  .Target(LUTOut)
	);

    assign MemWriteValue = ReadB;
	DataMem DM1(
		.DataAddress  (ALU_Out)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (MemWriteValue), 
		.DataOut      (MemReadValue)  , 
		.Clk 		  		     ,
		.Reset		  (Reset)
	);
	
// count number of instructions executed
always_ff @(posedge Clk)
  if (Start == 1)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule