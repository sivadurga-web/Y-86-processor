
`include "ALU_sub_modules/add32.v"
`include "ALU_sub_modules/sub32.v"
`include "ALU_sub_modules/and32.v"
`include "ALU_sub_modules/xor32.v"
`timescale 1ns/1ps

module alu(a,b,out,carry,ctrl);
input [63:0] a;
input [63:0] b;
input [1:0] ctrl;
output [63:0] out;
output carry;
wire carry_add;
wire carry_sub;
reg [63:0] out;
reg carry;
wire [63:0] out_and;
wire [63:0] out_xor;
wire [63:0] out_add;
wire [63:0] out_sub;


and32 and1(a,b,out_and);
xor32 xor1(a,b,out_xor);
add32 add1(a,b,out_add,carry_add);
sub32 sub1(a,b,out_sub,carry_sub);

always  @(*)
begin
	case (ctrl)
		2'b00: out = out_and;
		2'b01: out = out_xor;
		2'b10: begin out = out_add; carry = carry_add; end
		2'b11: begin out = out_sub; carry =  carry_sub; end
	endcase
end
endmodule
