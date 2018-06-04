`timescale 1ns / 1ps
//changs happens in inputs and CONTROLS(size extended 1 bit)
//add a wire 'eqneD' to distinguish ben and beq;

module maindec(
	input [5:0]OP,
	output M2REG,WMEM,BRANCH,EQNE,ALUIMM,REGRT,WREG,JMP,
	output [2:0]ALUOP
);

reg [10:0] CONTROLS;
assign {WREG,REGRT,ALUIMM,BRANCH,EQNE,JMP,WMEM,M2REG,ALUOP} = CONTROLS;
// [8:0]CONTROLS: (WREG,REGRT,ALUIMM)__(BRANCH,JUMP)__(WMEN,M2REG)__(ALUOP);
//new [9:0]CONTROLS:(WREG,REGRT,ALUIMM)__(BRANCH,EQNE,JUMP)__(WMEN,M2REG)__(ALUOP);
always @(*)
case(OP)
//special
	6'b000000: CONTROLS = 11'b110_000_00_010;//op:010 :look at func
//addi
	6'b001000: CONTROLS = 11'b101_000_00_000;//op:000 :add
//andi
	6'b001100: CONTROLS = 11'b101_000_00_100;//op:100 :and
//ori
	6'b001101: CONTROLS = 11'b101_000_00_011;//op:011 :or
//slti
	6'b001010: CONTROLS = 11'b101_000_00_001;//op:001 :substract
//sw
	6'b101011: CONTROLS = 11'b001_000_10_000;//op:000 :add
//lw
	6'b100011: CONTROLS = 11'b101_000_01_000;//op:000 :add
//j
	6'b000010: CONTROLS = 11'b000_001_00_0xx;//op:xxx :don't need alu,so what about give 11 ?
//beq
	6'b000100: CONTROLS = 11'b000_100_00_001;//op:000 :sub rs rt
//bne
	6'b000101: CONTROLS = 11'b000_110_00_001;//op:000 :sub rs rt //modify logic of JMP signal , consider the diffrent between beq and bne
//default
	default  : CONTROLS = 11'bxxx_xxx_xx_xxx;//other operations
endcase

endmodule