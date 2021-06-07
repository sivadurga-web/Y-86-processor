`timescale 1ns/1ps
`include "alu/alu.v"
`include "fetch/fetch.v"
`include "decode_writeback/decode.v"
`include "memory/memory.v"
`include "pcupdate/pcupdate.v"

module seq_processor;
wire [10:0] pc ;
wire [3:0] icode;
wire [3:0] ifun;
wire [3:0] rA;
wire [3:0] rB;
wire [63:0] valC;
wire [10:0] valP;
wire f_com;
wire d_com;
wire e_com;
// control condtions
wire instr_valid;
wire imem_error;
wire cnd;
wire dmem_error;

wire [63:0] valA;
wire [63:0] valB;
wire [63:0] valE;
wire [63:0] valM;
reg clk ;
wire [1:0] stat;
fetch call1(pc,icode,ifun,rA,rB,valC,valP,instr_valid,imem_error,f_com);
decode call2(clk,icode,rA,rB,valA,valB,valE,valM,cnd,d_com,f_com);
alu call3(icode,ifun,valA,valB,valC,valE,cnd,d_com,e_com);
memory call4(icode,valA,valE,valP,valM,imem_error,instr_valid,dmem_error,stat,e_com); // i took valB instead valA for stack pointer case
pcupdate call5(clk,icode,cnd,valC,valM,valP,pc);

parameter stop_time = 2000000000;
initial #stop_time $finish;


initial begin
	//$monitor("main  %d ",pc);
	$dumpfile("seq.vcd");
	$dumpvars(0,seq_processor);
	clk = 0;
end
always begin
//		if(icode==0)
//		begin
		//	$display("icode %d",icode);
//			#1;
//		clk=~clk;
	//		#5;
//			$finish;
//		end
//		else
		#1 clk = ~clk;
	end
endmodule
