`timescale 1ns/1ps

module fetch(input clk, input [3:0] M_icode,input M_cnd, input [63:0] M_valA, input [3:0] W_icode,input [63:0] W_valM,output [144:0] D);
reg [144:0] D;


// ---- INSTRUCTION MEMORY -----
reg [7:0] i_mem[0:12];
initial begin 
	$readmemh("instr_mem.txt",i_mem);
end

// Registers used for storing

reg stat; // for status checking 
reg instr_valid =1; // check whether given instruction is y 86 or not
reg imem_error = 0;
reg [3:0] icode;
reg  [3:0] ifun;
reg  needvalC;
reg  needregids;
reg [3:0] rA;
reg [3:0] rB;
reg [63:0] valC;
reg [63:0] predPC =0 ;
wire [63:0] f_pc;

selectPC pcselect(M_icode,M_cnd,M_valA,W_icode,W_valM,predPC,f_pc);

always @(posedge clk)
begin
	rA = 15;
	rB = 15;
	predPC =f_pc;
	if(f_pc>200)
		imem_error = 1;
	else
	begin
		if(i_mem[f_pc][7:4]>11)
			instr_valid= 0;
		ifun = i_mem[f_pc][3:0];
		icode = i_mem[f_pc][7:4];
		predPC = predPC+1;
		if(i_mem[f_pc][7:4] ==2 || i_mem[f_pc][7:4] ==3 || i_mem[f_pc][7:4] == 4 || i_mem[f_pc][7:4] == 5 || i_mem[f_pc][7:4] == 6 || i_mem[f_pc][7:4] == 10 || i_mem[f_pc] == 11)
		begin
			predPC =predPC +1;
			if(i_mem[f_pc][7:4] == 3)
			begin
				rA = 15;
				rB = i_mem[f_pc+1][3:0];
			end
			else if(i_mem[f_pc][7:4] == 10 || i_mem[f_pc][7:4]==11)
			begin
				rB = 15;
				rA  = i_mem[f_pc+1][7:4];
			end
			else
			begin
				rA = i_mem[f_pc+1][7:4];
				rB = i_mem[f_pc+1][3:0];
			end
		end	
		if(i_mem[f_pc][7:4] == 3 || i_mem[f_pc][7:4] == 4 ||i_mem[f_pc][7:4] == 5 || i_mem[f_pc][7:4] == 7 || i_mem[f_pc][7:4] == 8)
		begin
			if (i_mem[f_pc][7:4]==8 || i_mem[f_pc][7:4]==7)
			begin
				valC[7:0] = i_mem[f_pc+1];
				valC[15:8] = i_mem[f_pc+2];
				valC[23:16] = i_mem[f_pc+3];
				valC[31:24] = i_mem[f_pc+4];
				valC[39:32] = i_mem[f_pc+5];
				valC[47:40] = i_mem[f_pc+6];
				valC[55:48] = i_mem[f_pc+7];
				valC[63:56] = i_mem[f_pc+8];
				predPC = predPC+8;
			end
			else
			begin
				valC[7:0] = i_mem[f_pc+2];
				valC[15:8] = i_mem[f_pc+3];
				valC[23:16] = i_mem[f_pc+4];
				valC[31:24] = i_mem[f_pc+5];
				valC[39:32] = i_mem[f_pc+6];
				valC[47:40] = i_mem[f_pc+7];
				valC[55:48] = i_mem[f_pc+8];
				valC[63:56] = i_mem[f_pc+9];
				predPC = predPC+8;
			end
		end



	end
	if(imem_error == 0 && instr_valid == 1)
		stat = 1;
	else
		stat = 0;
	// store the values in the decode register
	D[144] = stat;
	D[143:140] = icode;
	D[139:136] = ifun;
	D[135:132] = rA;
	D[131:128] = rB;
	D[127:64] = valC;
	D[63:0] = predPC;
	
	// predict pc is valC if there jump and call instruction is there
	if(icode == 7 || icode == 8)
		predPC = valC;
end
endmodule

module selectPC(input [3:0] M_icode, input M_cnd,input [63:0] M_valA,input [3:0] W_icode,input [63:0] W_valM,input [63:0] predPC,output [63:0] f_pc);
reg [63:0] f_pc;

initial begin
	f_pc = 0;
end
always @ (*)
begin
	if(M_icode == 7 && !M_cnd)
		f_pc = M_valA;
	else if(W_icode == 9) 
		f_pc = W_valM;
	else 
		f_pc = predPC;
end
endmodule


