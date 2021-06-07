`include "fetch.v"
`timescale 1ns/1ps

module fetch_tb;
wire [10:0] pc ;
wire [3:0] icode;
wire [3:0] ifun;
wire [3:0] rA;
wire [3:0] rB;
wire [63:0] valC;
wire [10:0] valP;
wire instr_valid;
wire imem_error;
assign pc =0;
fetch call1(pc,icode,ifun,rA,rB,valC,valP,instr_valid,imem_error);
initial
begin
	$monitor("%h %h %h %h %h %h %h %h %h ",pc,icode,ifun,rA,rB,valC,valP,instr_valid,imem_error);
	#15;
end
endmodule
