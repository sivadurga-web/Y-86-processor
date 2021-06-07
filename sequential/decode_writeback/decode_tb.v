`timescale 1ns/1ps
`include "decode.v"

module decode_tb;
reg [3:0] icode;
reg [3:0] rA;
reg [3:0] rB;
wire [63:0] valA;
wire [63:0] valB;
reg [3:0] dstE;
reg [3:0] dstM;
reg [63:0] valE;
reg [63:0] valM;
reg cnd;
reg clk;
reg f_com;
wire d_com;
decode call1(clk,icode,rA,rB,valA,valB,valE,valM,cnd,d_com,f_com);
initial begin
	$monitor("icode - %h, rA - %h, rB - %h, valA - %h , valB - %h",icode,rA,rB,valA,valB);
	f_com = 0;
	icode = 0;
	rA = 2;
	rB = 15;
	f_com = 1;
	#10;
	f_com = 0;
	icode  = 2;
	rA = 3;
	rB = 11;
	f_com = 1;
	#10;
	f_com = 0;
	icode = 3;
	rA = 3;
	rB = 8;
	f_com = 1;
	#10;
	f_com = 0;
	icode = 6;
	rA = 4;
	rB = 8;
	valE = 32;
	f_com = 1;
	#10;
	f_com = 0;
	icode = 10;
	rA = 5;
	rB = 15;
	f_com = 1;
	#10;
end
endmodule

