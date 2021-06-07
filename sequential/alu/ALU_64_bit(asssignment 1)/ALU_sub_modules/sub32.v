//`include "./add32.v"
`timescale 1ns/1ps

module sub32(a,b,out,carry);
input [63:0] a;
input [63:0] b;
output [63:0] out;
output carry;

genvar i;
wire carry;
wire carr;
reg [63:0] temp;
wire [63:0] temp2;
reg [63:0] twos= 1;
for (i=0;i<64;i = i+1)
begin
	always @(*)
	begin
		temp[i] = !b[i];
	end
end
add32 iadd(temp,twos,temp2,carr);
assign carr =0;
add32 iaddd(a,temp2,out,carry);
initial $monitor("%b ",out);

endmodule
