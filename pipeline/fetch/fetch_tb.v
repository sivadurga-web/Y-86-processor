`timescale 1ns/1ps
`include "fetch.v"

module fetch_tb;
reg clk;
reg [3:0] M_icode;
reg [63:0] M_valA;
reg M_cnd;
reg [3:0] W_icode;
reg [63:0] W_valM;
wire [144:0] D;


parameter stop_time = 2000;
initial #stop_time $finish;

fetch call1(clk,M_icode,M_cnd,M_valA,W_icode,W_valM,D);

initial begin
	//$monitor("main  %d ",pc);
	$dumpfile("fetch.vcd");
	$dumpvars(0,fetch_tb);
	clk = 0;
	M_icode= 0;
	M_valA = 0;
	M_cnd = 0;
	W_icode =0;
	W_valM = 0;
end
always begin
	if(D[143:140]==0)
	begin
		$display("hello");
		//              #5;
		//              clk=~clk;
		//              #5;
		$finish;
	end
	else
		#5 clk = ~clk;
end
endmodule

