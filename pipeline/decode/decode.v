`timescale 1ns/1ps

module decode(input [144:0] D,input clk, input [3:0] e_dstE, input [63:0] e_valE, input [3:0] M_dstE, input [63:0] M_valE,input [3:0] M_dstM, input [63:0] m_valM,input [3:0] W_dstE, input [63:0] W_valE,input [3:0] W_dstM, input [63:0] W_valM, output [216:0] E);


reg [63:0] reg_file[0:15]; // Declaring the register file
initial begin 
	reg_file[4] = 0;
	reg_file[2] = 0;
end

reg [216:0] E;
wire [3:0] dstE;
wire [3:0] dstM;
wire [3:0] srcA;
wire [3:0] srcB;


// Finding the destinationa and source register using the below modules
dstElogic dst_E(D,dstE);
dstMlogic dst_M(D,dstM);
srcAlogic src_A(D,srcA);
srcBlogic src_B(D,srcB);

reg [63:0] valA;
reg [63:0] valB;
// ------ DECODE stage ------

always @(posedge clk)
begin
	valA = 0;
	valB = 0;
	if(srcA != 15)
		valA =reg_file[srcA];
	if(srcB != 15)
		valB =reg_file[srcB];
	if(srcA !=15)
	begin
		if(D[143:140] == 7 || D[143:140] == 8) valA = D[63:0];
		else if(srcA ==  e_dstE) valA = e_valE;
		else if(srcA == M_dstM) valA = m_valM;
		else if(srcA == M_dstE) valA = M_valE;
		else if(srcA == W_dstM) valA = W_valM;
		else if(srcA == W_dstE) valA =W_valE;
	end
	if(srcB!=15)
	begin
		if(srcB ==  e_dstE) valB = e_valE;
		else if(srcB == M_dstM) valB = m_valM;
		else if(srcB == M_dstE) valB = M_valE;
		else if(srcB == W_dstM) valB = W_valM;
		else if(srcB == W_dstE) valB =W_valE;
	end
	
	E[216] = D[144];
	E[215:212] = D[143:140];
	E[211:208] = D[139:136];
	E[207:144] = D[127:64];
	E[143:80] = valA;
	E[79:16] = valB;
	E[15:12] = dstE;
	E[11:8] = dstM;
	E[7:4] = srcA;
	E[3:0] = srcB;
end

//-----  write back stage -------
always @(posedge clk)
begin
	if(W_dstE!=15)
		reg_file[W_dstE] = W_valE; 
	if(W_dstM!=15)
		reg_file[W_dstM] = W_dstM;
end
endmodule

module dstElogic(input [144:0] D,output reg [3:0] dstE);
always @(*)
begin
	if(D[143:140]== 2) dstE = D[131:128];
	else if(D[143:140] == 3 || D[143:140] == 6) dstE = D[131:128];
	else if(D[143:140] == 8 || D[143:140] == 9 || D[143:140] == 10 ||D[143:140] == 11) dstE = 4;
	else dstE = 15;
end
endmodule

module dstMlogic(input [144:0] D,output reg [3:0] dstM);
always @(*)
begin
	if(D[143:140] == 5 || D[143:140] == 11)
		dstM = D[135:132];
	else dstM = 15;
end
endmodule

module srcAlogic(input [144:0] D,output reg [3:0] srcA);
always@(*)
begin
	if(D[143:140] == 2 || D[143:140] == 4 || D[143:140] == 6 || D[143:140] == 10) srcA = D[135:132];
	else if(D[143:140] == 11 || D[143:140] == 9) srcA = 4;
	else
		srcA = 15;
end
endmodule

module srcBlogic(input [144:0] D,output reg [3:0] srcB);
always @(*)
begin
	if(D[143:140] == 4 || D[143:140] == 5 || D[143:140] == 6) srcB = D[131:128];
	else
		srcB = 15;
end
endmodule 

