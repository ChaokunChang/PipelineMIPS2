`timescale 1ns / 1ps
//changs happens in inputs and CONTROLS(size extended 1 bit)
//add a wire 'eqneD' to distinguish ben and beq;

module maindec(
	input [5:0]OP,
	output M2REG,WMEM,BRANCH,EQNE,ALUIMM,REGRT,WREG,JMP,
	output [1:0]ALUOP
);

reg [9:0] CONTROLS;
assign {WREG,REGRT,ALUIMM,BRANCH,EQNE,JMP,WMEM,M2REG,ALUOP} = CONTROLS;
// [8:0]CONTROLS: (WREG,REGRT,ALUIMM)__(BRANCH,JUMP)__(WMEN,M2REG)__(ALUOP);
//new [9:0]CONTROLS:(WREG,REGRT,ALUIMM)__(BRANCH,EQNE,JUMP)__(WMEN,M2REG)__(ALUOP);
always @(*)
case(OP)
//special
	6'b000000: CONTROLS = 10'b110_000_00_10;//op:10 :look at func
//addi
	6'b001000: CONTROLS = 10'b101_000_00_00;//op:00 :add
//andi
	6'b001100: CONTROLS = 10'b101_000_00_00;//op:00 :and(!error)
//ori
	6'b001101: CONTROLS = 10'b101_000_00_11;//op:11 :or
//slti
	6'b001010: CONTROLS = 10'b101_000_00_01;//op:01 :substract
//sw
	6'b101011: CONTROLS = 10'b001_000_10_00;//op:00 :add
//lw
	6'b100011: CONTROLS = 10'b101_000_01_00;//op:00 :add
//j
	6'b000010: CONTROLS = 10'b000_001_00_xx;//op:xx :don't need alu,so what about give 11 ?
//beq
	6'b000100: CONTROLS = 10'b000_100_00_01;//op:00 :sub rs rt
//bne
	6'b000101: CONTROLS = 10'b000_110_00_01;//op:00 :sub rs rt //modify logic of JMP signal , consider the diffrent between beq and bne
//default
	default  : CONTROLS = 10'bxxx_xxx_xx_xx;//other operations
endcase

endmodule