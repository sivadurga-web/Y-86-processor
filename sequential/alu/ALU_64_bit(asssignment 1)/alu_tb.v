`include "alu.v"
`timescale 1ns/1ps

module alu_tb1;
reg signed [63:0] a;
reg signed[63:0] b;
wire signed[63:0] result;
reg [1:0] cond;
wire carry;
alu alu_1(a,b,result,carry,cond);

initial begin
	$monitor("a = %d, b =%d, output = %d, condition = %b, carry = %d",a,b,result,cond,carry);
	 a = 63'b00000000000000000000000000000010;
	 b = 63'b11111111111111111111111111111111;
	 cond = 2'b11;
	 #100;
	 a = 63'b10101011111101001010101010101111;
	 b = 63'b10000000001111111111110000000000;
	 cond = 2'b01;
	 #100;
	 a = 63'b00101111000001001001000110000001;
	 b = 63'b01000000011100001100010001110001;
	 cond = 2'b10;
	 #100;
	 a = 63'b10000000000000000000000001100010;
	 b = 63'b00110011111111100011011110000011;
	 cond = 2'b11;
	 #100;
	 $finish;
 end
 endmodule
