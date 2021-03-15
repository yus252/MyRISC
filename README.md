## Introduction
Our architecture is called MyRISC. It has 9 bit instructions and 2 types of 
instructions, R type and I type. There is 1 bit for the flag: 0 represents R 
type and 1 represents I type. It takes 4 bit for R-type opcode and 3 bit for 
I-type opcode. Therefore, R-type instructions support at most 16 instructions
and I type instructions support at most 31 for immediate. 

To save the number of bits used for MyRISC, all the instructions are loading 
values and assigning values into r0 and r1 by default. Therefore, r0 and r1 
should be used for temporary values.

Finally,  MyRISC has a lookup table to load large numbers (>= 32) easily. These
numbers are tap patterns for LFSR state calculation and address for
instruction memory used for branching instructions. 

## R-type Instructions
| 1 | 4 |      4     |
| :--- | :---   |       :---       |
| 0 | opcode |     rs     |

Format: instr rs


| Name | Opcode |      Meaning     |                Explanation                |
| :--- | :---   |       :---       |                                      :--- |
| mv   | 0000   | rs = r0          | Move the value of the r0 to the rs        |
| as   | 0001   | r0 = rs          | Assign the value of rs to the r0          |
| add  | 0010   | rs = rs + r0     | Add the operand register to the rs        |
| sub  | 0011   | rs = rs - r0     | Subtract the operand register from the rs |
| b    | 0100   | branch to rs     |  Branch to the line number stored in rs   |
| blt  | 0101   | If r0 < r1,branch to rs    |   Branch to the line number stored in rs if the value of rs is less than r1 |
| beq  | 0110   | If r0 == r1, branch to rs  |   Branch to the line number stored in rs if the value of rs is equal to r1  |
| lw   | 0111   | rs = mem[0]      | Load the memory at address r0 into rs     |
| sw   | 1000   | mem[rs] = r0     | Store the value of r0 at the address of rs in the memory |
| xor  | 1001   | rs = r0 ^ r1     | Assign the result of r0 xor r1 into rs    |
| and  | 1010   | rs = r0 & r1     | Assign the value of r0 and r1 into rs     |
| xall | 1011   | rs = ^r0         | Reduction xor on every bit of rs          |
| lut  | 1100   | r0 = table[rs]   | Get the value at the index sotred in rs in the lookup table |
| sll  | 1101   | rs = (r0<<1)|rs  | Shift r0 left by 1 bit, set the last bit of r0 to be rs, and store the result into rs |

## I-type Instructions
| 1 | 3 |      5     |
| :--- | :---   |       :---       |
| 1 | opcode |     imm     |


| Name | Opcode |      Meaning     |                Explanation                |
| :--- | :---   |       :---       |                                      :--- |
| li   | 000    | r0 = imm         | Assign imm to r0                          |
| gbi  | 001    | r0 = r0[imm]     | Get the bit of r0 at index imm and assign the bit back to r0 |
| sb0  | 010    | r0[imm] = 0      | Set the bit of r0 at index imm to be 0    |
| sb1  | 011    | r0[imm] = 1      | Set the bit of r0 at index imm to be 1    |
| addi | 100    | r0 = r0 + imm    | Add imm to r0                             |
| subi | 101    | r0 = r0 - imm    | Subtract imm from r0                      |
| luti | 110    | r0 = table[imm]  | Get the imm(th) number on the lookup table |


## Stop
111111111 is always appended to the end of the machine code to indicate "stop runnning
the program."
