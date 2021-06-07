`timescale 1ns/1ps

module decode(clk,icode,rA,rB,valA,valB,valE,valM,cnd,d_com,f_com);
input clk;
input [3:0] icode;
input [3:0] rA;
input [3:0] rB;
output [63:0] valA;
output [63:0] valB;
//input [3:0] dstE;
//input [3:0] dstM;
input [63:0] valE;
input [63:0] valM;
output reg complete;
input cnd;
input f_com;
output reg d_com;
reg [63:0] r1Val, r2Val,r0Val;
// reg file defining 
reg signed [63:0] reg_file [0:15];

initial begin
	reg_file[0] = 0;
	reg_file[1] = 0;
	reg_file[2] = 0;
	reg_file[3] = 0;
	reg_file[4] = 128;
	reg_file[5] = 0;
	reg_file[6] = 0;
	reg_file[7] = 0;
	reg_file[8] = 0;
	reg_file[9] = 0;
	reg_file[10] =00;
	reg_file[11] = 0;
	reg_file[12] = 0;
	reg_file[13] = 0;
	reg_file[14] = 0;
	reg_file[15] =0;
end

reg [63:0] valA;
reg [63:0] valB;
reg [3:0] dstE;
reg [3:0] dstM;
// ------ Decode stage  ------  //

always @ (posedge f_com)
begin
	d_com = 0;
	valA=0;
	valB=0;
	if(icode == 2 || icode ==4 || icode == 6 || icode == 10)
	begin
		valA = reg_file[rA];
	end
	if( icode == 6 )
	begin
		valB = reg_file[rB];
	end
	if( icode == 4 || icode == 5)
	begin
		valB = reg_file[rB];
	end

	// stack pointer 
	if(icode == 10 || icode == 8)
	begin
		valB = reg_file[4];
	end
	if(icode == 11 || icode==9)
	begin
		valA = reg_file[4];
	end
	d_com = 1;
	$display("Decode -- icode - %h, valA - %h, valB- %h",icode,valA,valB);
end

// ------- Write Back Stage -------- //
integer i=0;
always @(posedge clk)
begin
	if(icode == 5  || icode == 11)
	begin
		reg_file[rA] = valM;
		
	end
	if( (icode == 2 && cnd == 1) ||  icode == 3 || icode == 6)
	begin
		reg_file[rB] = valE;
	end
	if(icode == 8 || icode == 9 ||  icode== 11 || icode == 10)
	begin
		reg_file[4] = valE;
	end
	r1Val = reg_file[1];
	r2Val = reg_file[2];
	r0Val = reg_file[0];
	$display("write back -- Time -- %0t ps,icode - %h,cnd - %h, valE - %h, valM - %h",$time,icode,cnd, valE,valM);
	$display("REGISTER FILE");
	for(i=0;i<16;i = i+2)
	begin
		$display("R%0d - %d     ----     R%0d - %d",i,reg_file[i],i+1,reg_file[i+1]);
		
	end
	$display("\n\n");
end

endmodule
