`timescale 1ns/1ps
`include "alu.v"

module alu_tb;
reg  [3:0] icode;
reg  [3:0] ifun;
reg signed [63:0] valA;
reg  signed [63:0] valB;
reg  signed [63:0] valC;
wire signed [63:0] valE;
wire cnd;
reg d_com;
wire e_com;
alu call1(icode,ifun,valA,valB,valC,valE,cnd,d_com,e_com);

initial begin
	$monitor("icode - %d, ifun - %d, valA  = %b, valB = %b valC = %d, valE = %b,cnd = %d",icode,ifun,valA,valB,valC,valE,cnd);
	
	d_com = 0;
	icode = 6;
	ifun = 0;
	valA = 1;
	valB = 7;
	valC = 0;
	d_com = 1;
	#10;
	d_com = 0;
	icode = 6;
	ifun = 0;
	valA = -9223372036854775807;
	valB = -2;
	valC = 0;
	d_com = 1;
	#10;

end
endmodule
