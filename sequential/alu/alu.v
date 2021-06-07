`timescale 1ns/1ps

module alu(icode,ifun,valA,valB,valC,valE,cnd,d_com,e_com);
input [63:0] valA;
input [63:0] valB;
input [63:0] valC;
output [63:0] valE;
output cnd;
input [3:0] icode;
input [3:0] ifun;
reg cnd;
reg [63:0] valE;
reg [2:0] cc;
input d_com;
output reg e_com;
initial begin
	cc[0] = 0;
	cc[1] = 0;
	cc[2] = 0;
end
reg [63:0] a;
reg [63:0] b;
reg [2:0] fun;
//aluA call1(icode,valC,valA,a);
//aluB call2(icode,valB,b);
//aluFun call3(icode,ifun,fun);
//cond call4(ifun,cc,cnd);

always @(posedge d_com)
begin
	// aluA logic 
	e_com = 0;
	if(icode == 2 || icode ==6)
		a = valA;
	else if(icode == 3 || icode== 4 || icode == 5) 
		a = valC;
	else if(icode == 8 || icode == 10) 
		a = -1;
	else if(icode == 9 || icode == 11)
		a = 1;

	// aluB logic
	if(icode == 3 || icode == 2) b = 0;
	else if (icode == 4 || icode == 5 || icode ==6 || icode == 8 ||  icode ==10 )
	       b = valB;
       else if(icode ==9||icode==11)
	       b =valA;
       //alu fun logic
	if(icode == 6)
		fun = ifun;
	else if(icode == 2 || icode ==3 || icode ==4 || icode == 5 || icode == 8 || icode == 9|| icode == 10 || icode == 11)
		fun = 0;

	// --- ALU---
	if(icode == 2 || icode == 3 || icode ==4 || icode == 5 || icode == 8 || icode == 9|| icode == 10 || icode == 11)
	begin 
		valE = a+b;
	end
	else if(icode == 6)
	begin
		cc = 0;
		if(fun ==0)
		begin
		valE = a+b;
		//setting the condtion code register cc;
		if(valE == 0)
			cc[0] = 1;
		if (valE[63]==1)
			cc[1] =1;
		if( (valE[63]==1 && a[63]==0 && b[63]==0) || (valE[63]==0 && a[63]==1 && a[63]==1))
			cc[2] =1;
		end
		if(fun ==1)
		begin
		valE = b+(-a);
		//setting the condtion code register cc;
		if(valE == 0)
			cc[0] = 1;
		if (valE[63]==1)
			cc[1] =1;
		if( (valE[63]==0 && a[63]==0 && b[63]==1) || (valE[63]==1 && a[63]==1 && b[63]==0))
			cc[2] =1;
		end
		if(fun ==2)
		begin
		valE = b&a;
		//setting the condtion code register cc;
		if(valE == 0)
			cc[0] = 1;
		end
		if(fun ==3)
		begin
		valE = b^a;
		//setting the condtion code register cc;
		if(valE == 0)
			cc[0] = 1;
		end	
	end
	// alu condition logic	
	if (icode == 7 || icode == 2)
	begin
	cnd = 0;
	if (ifun == 0)
		cnd = 1;
	else if(ifun == 1 && (cc[0] |(cc[1]^cc[2]))==1)
		cnd = 1;
	else if(ifun == 2 &&  (cc[1]^cc[2] == 1))
		cnd = 1;
	else if(ifun == 3 && (cc[0] == 1 ))
		cnd = 1;
	else if(ifun == 4 && (cc[0] == 0))
		cnd = 1;
	else if(ifun == 5 && (cc[0] == 1 || (cc[1]^cc[2] == 0)))
		cnd = 1;
	else if(ifun == 6 && (cc[1]^ cc[2] == 0) && cc[0]==0)
		cnd = 1;
	//$display("execute condition register , icode - %d, over,neg,zero -%b",icode,cc);
	end
	$display("Execute -- icode - %h ,ifun - %h, valA - %d, valB -%d, valC - %d, valE - %d, over,neg,zero - %b", icode,ifun,valA,valB,valC,valE,cc);
	
	e_com = 1;	
end
endmodule
/*
module aluA(icode,valC,valA,a);
input [3:0]  icode;
input [63:0] valC;
input [63:0] valA;
output [63:0] a;
reg [63:0] a;

always@(*)
begin
	if(icode == 2 || icode ==6)
		a = valA;
	else if(icode == 3 || icode== 4 || icode == 5) 
		a = valC;
	else if(icode == 8 || icode == 10) 
		a = -1;
	else if(icode == 9 || icode == 11)
		a = 1;
end
endmodule

module aluB(icode,valB,b);
input [3:0] icode;
input [63:0] valB;
output [63:0] b;
reg [63:0] b;

always @ (*)
begin
	if(icode == 3 || icode == 2) b = 0;
	else if (icode == 4 || icode == 5 || icode ==6 || icode == 8 || icode == 9 || icode ==10 ||icode==11)
	       b = valB;	
end

endmodule

module aluFun(icode,ifun,fun);
input [3:0] icode;
input [3:0] ifun;
output [2:0] fun;
reg [2:0] fun;

always @(*)
begin
	if(icode == 6)
		fun = ifun;
	else if(icode == 2 || icode ==3 || icode ==4 || icode == 5 || icode == 8 || icode == 9|| icode == 10 || icode == 11)
		fun = 0;
end
endmodule

module cond(ifun,cc,cnd);
input [3:0] ifun;
input [2:0] cc;
output cnd;
reg cnd;

always@(*)
begin
	cnd = 0;
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
endmodule*/ 
