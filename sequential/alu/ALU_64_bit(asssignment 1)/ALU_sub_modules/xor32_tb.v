// ---- testbench for and2 gate
`timescale 1s/1ps
`include "xor32.v"

module xor32_tb;
reg [63:0] a;
reg [63:0] b;
wire [63:0] c;
xor32 ixor32(a,b,c);
initial begin
	$monitor("a = %b, b = %b, y = %b", a,b,c);
	$dumpfile("xor32.vcd");
	$dumpvars(1,xor32_tb);
	a = 0;
	b = 0;
	#10;
	a = (1<<64)-1;
	b = (1<<64)-1;
	#10
	a = (1<<64)-1;
	b = 0;
	#10
	a = 0;
	b = (1<<64)-1;
	$finish;
end
endmodule
