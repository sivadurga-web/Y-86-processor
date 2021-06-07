`timescale 1ns/1ps 

module execute(input clk, input [216:0] E, input W_stat, input m_stat, output [63:0] e_valE, output [3:0] e_dstE, output [144:0] M);


reg cnd;
reg [2:0] cc;
initial begin cc = 0;
cnd = 0;
end

reg [63:0] e_valE;
reg [3:0] e_dstE;
reg [144:0] M;
wire [63:0] aluA;
wire [63:0] aluB;
wire [1:0] aluFun;
reg [63:0] valE;
reg [3:0] ifun;
// These modules finds the inputs for alu and the function or ifun
alu_A call1(E,aluA);
alu_B call2(E,aluB);
aluFUN call3(E,aluFun);
// set cc depends on the W_stat and m_stat
always @ (posedge clk)
begin
	if (E[215:212] != 6 && aluFun == 0)
		valE = aluA + aluB;
	else if (E[215:212] == 6)
	begin
		cc = 0;
		if(aluFun == 0)
		begin
			valE = aluA + aluB;
                //setting the condtion code register cc;
                if(valE == 0)
                        cc[0] = 1;
                if (valE[63]==1)
                        cc[1] =1;
                if( (valE[63]==1 && aluA[63]==0 && aluB[63]==0) || (valE[63]==0 && aluA[63]==1 && aluB[63]==1))
                        cc[2] =1;
                end
		else if (aluFun == 1)
		begin
			valE = aluB+(-aluA);
                //setting the condtion code register cc;
                if(valE == 0)
                        cc[0] = 1;
                if (valE[63]==1)
                        cc[1] =1;
                if( (valE[63]==1 && aluA[63]==0 && aluB[63]==0) || (valE[63]==0 && aluA[63]==1 && aluB[63]==1))
                        cc[2] =1;
                end
		else if (aluFun == 2)
		begin
			valE = aluB & aluA;
		if (valE ==  0) cc[0] = 1;
		end
		else if (aluFun == 3) 
		begin
			valE = aluB^aluA;
			if(valE == 0) cc[0] =1;
		end
	end
        // alu condition logic  
	if(E[215:212] == 7 || E[215:212] == 2)
	begin
        cnd = 0;  
	ifun = E[211:208];
        if(ifun == 1 && (cc[0] == 1 || (cc[1]==1 && cc[2] == 0)))
                cnd = 1;

        else if(ifun == 2 &&  (cc[1]==1 && cc[2] == 0))
                cnd = 1;
        else if(ifun == 3 && (cc[0] == 1 ))
                cnd = 1;
        else if(ifun == 4 && (cc[0] == 0))
                cnd = 1;
        else if(ifun == 5 && (cc[0] == 1 ||(cc[1] == 0 && cc[2] == 0)))
                cnd = 1;
        else if(ifun == 6 && (cc[1] == 0 && cc[2] == 0))
                cnd = 1;
	
	end
	M[144] = E[216];
	M[143:140] =E[215:212];
	M[139:136] = cnd;
	M[135:72] = valE;
	e_valE  = valE;
	M[71:8] = E[143:80];
	if((E[215:212] == 2 && cnd == 1) || (E[215:212] != 2))
	begin
		e_dstE = E[15:12];
		M[7:4] = E[15:12];
	end
	else
	begin
		e_dstE = 15;
		M[7:4] = 15;
	end
	M[3:0] = E[11:8];

	//$display("\n\n %h %h \n\n",M,E);
end
endmodule


module alu_A(input [216:0] E, output reg [63:0] aluA);
reg [3:0] icode;
always@(*)
begin
	icode = E[215:212];
	if(icode == 2 || icode == 6) aluA = E[143:80];
	if(icode == 3 || icode  == 4 || icode == 5) aluA = E[207:144];
	if(icode == 8 || icode == 10) aluA = 8;
	if(icode == 9 || icode == 11) aluA = -8;
end
endmodule

module alu_B(input [216:0] E,output reg[63:0] aluB);
reg [3:0]  icode;
always@ (*)
begin
	icode = E[215:212];
	if(icode == 4 || icode == 5 || icode == 6 || icode  == 8 || icode == 10 || icode == 11 || icode == 9) aluB = E[79:16];
	if(icode == 2 || icode == 3) aluB = 0;
end
endmodule

module aluFUN(input [216:0] E, output reg [1:0] alufun);
always @(*)
begin
	if(E[215:212] == 6) alufun = E[211:208];
	else alufun = 0;
end
endmodule
