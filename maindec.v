`timescale 1ns / 1ps
//changs happens in inputs and CONTROLS(size extended 1 bit)
//add a wire 'eqneD' to distinguish ben and beq;

module maindec(
	input [5:0]OP,
	output M2REG,WMEM,BRANCH,EQNE,ALUIMM,REGRT,WREG,JMP,JAL,
	output [2:0]ALUOP
);

reg [11:0] CONTROLS;
assign {WREG,REGRT,ALUIMM,BRANCH,EQNE,JMP,JAL,WMEM,M2REG,ALUOP} = CONTROLS;
// [8:0]CONTROLS: (WREG,REGRT,ALUIMM)__(BRANCH,JUMP)__(WMEN,M2REG)__(ALUOP);
//new [9:0]CONTROLS:(WREG,REGRT,ALUIMM)__(BRANCH,EQNE,JUMP)__(WMEN,M2REG)__(ALUOP);
always @(*)
case(OP)
//special
	6'b000000: CONTROLS = 12'b110_0000_00_010;//op:010 :look at func
//addi
	6'b001000: CONTROLS = 12'b101_0000_00_000;//op:000 :add
//andi
	6'b001100: CONTROLS = 12'b101_0000_00_100;//op:100 :and
//ori
	6'b001101: CONTROLS = 12'b101_0000_00_011;//op:011 :or
//slti
	6'b001010: CONTROLS = 12'b101_0000_00_001;//op:001 :substract
//sw
	6'b101011: CONTROLS = 12'b001_0000_10_000;//op:000 :add
//lw
	6'b100011: CONTROLS = 12'b101_0000_01_000;//op:000 :add
//j
	6'b000010: CONTROLS = 12'b000_0010_00_xxx;//op:xxx :don't need alu
//jal
    6'b000011: CONTROLS = 12'b100_0011_00_xxx;//GPR[31] <- PC+4 ; PC <- instr
//beq
	6'b000100: CONTROLS = 12'b000_1000_00_001;//op:000 :sub rs rt
//bne
	6'b000101: CONTROLS = 12'b000_1100_00_001;//op:000 :sub rs rt //modify logic of JMP signal , consider the diffrent between beq and bne
//default
	default  : CONTROLS = 12'bxxx_xxxx_xx_xxx;//other operations
endcase

endmodule