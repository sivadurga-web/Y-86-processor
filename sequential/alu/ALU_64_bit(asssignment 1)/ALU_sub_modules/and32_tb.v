// ---- testbench for and2 gate
`timescale 1s/1ps
`include "and32.v"

module and32_tb;
reg [63:0] a;
reg [63:0] b;
wire [63:0] c;
and32 iand32(a,b,c);
initial begin
	$monitor("a = %b, b = %b, y = %b", a,b,c);
	$dumpfile("and32.vcd");
	$dumpvars(1,and32_tb);
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
