`timescale 1ns/1ps
`include "memory.v"

module memory_tb;

reg [3:0] icode;
reg [63:0] valA;
reg [10:0] valP;
reg [63:0] valE;
wire [63:0] valM;
wire dmem_error;
reg instr_valid;
reg imem_error;
wire [1:0] stat;
reg e_com;
memory call1(icode,valA,valE,valP,valM,imem_error,instr_valid,dmem_error,stat,e_com);

initial begin
	e_com = 0;
	icode = 11; 
	valA = 5;
	e_com = 1;
	#10;
	e_com = 0;
	icode = 5;
	valE = 5;
	e_com = 1;
	#10;
	e_com = 0;
	icode = 4;
	valE = 5;
	valA = 20;
	e_com = 1;
	#10;
	e_com = 0;
	icode = 11;
	valA = 5;
	e_com =1;
	#10;
	e_com = 0;
	icode = 8;
	valP = 30;
	valE = 5;
	e_com =1;
	#10;
	e_com = 0;
	icode =11;
	valA = 5;
	e_com = 1;
	#10;
end
endmodule
