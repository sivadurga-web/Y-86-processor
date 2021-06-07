// ---- testbench for and2 gate
`timescale 1s/1ps
`include "sub32.v"

module sub32_tb;
reg signed [63:0] a;
reg signed [63:0] b;
wire signed [63:0] c;
wire carry;
sub32 isub32(a,b,c,carry);
integer i;
initial begin
	$monitor("a = %d, b = %d, y = %d %b", a,b,c,carry);
	a = 64'b0001;
	b = (1<<64)-1;
	
	#10
	a = -64'b1;
	b = -64'b11;
	#10
	for (i=0;i<10;i= i+1) 
	begin
		a = $random;
		b = $random;
		#10;
	end
//	a = (1<<32)-1;
//	b = 0;
//	#10
//	a = 0;
//	b = (1<<32)-1;
	$finish;
end
endmodule
