`timescale 1ns / 1ps

module adder(
	input [31:0]a,b,
	output [31:0]re
);

assign re = a + b;

endmodule
