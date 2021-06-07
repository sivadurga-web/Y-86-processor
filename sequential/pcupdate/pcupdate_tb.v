`timescale 1ns/1ps
`include "pcupdate.v"

module pcupdate_tb;
reg [3:0] icode;
reg cnd;
reg [63:0] valC;
reg [63:0] valM;
reg [10:0] valP;
wire [10:0] pc;

pcupdate call1(icode,cnd,valC,valM,valP,pc);
initial begin
	$monitor("icode = %h, cnd =%h, valC = %h valM = %h valP = %h ,pc = %h",icode,cnd,valC,valM,valP,pc);
	icode = 2;
	valP = 2;
	#10;
	icode = 3;
	valP = 10;
	#10;
	icode = 7;
	valC = 13;
	cnd = 1;
	#10;
	icode = 7;
	valC = 16;
	cnd = 0;
	#10;
	icode = 9;
	valM = 24;
end
endmodule
