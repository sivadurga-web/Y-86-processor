`timescale 1ns/1ps

module pcupdate(clk,icode,cnd,valC,valM,valP,pc);
input [3:0] icode;
input cnd;
input clk;
input [63:0] valC;
input [63:0] valM;
input [10:0] valP;
output [10:0] pc;
reg [10:0] pc;
initial begin pc = 0;
end
always@(posedge clk)
begin
	
	if(icode == 1 || icode == 2 || icode == 3 || icode == 4 || icode == 5 || icode == 6 || icode == 10 ||icode == 11)
	     pc = valP;
	else if(icode == 7)
	begin
		if(cnd == 1)
		begin
			pc = valC;
		end
		else
			pc = valP;
	end
	else if(icode == 8)
		pc = valC;
	else if (icode == 9)
		pc = valM;
	$display("update -- icode - %h, cnd - %h, valP - %h, valC - %h,valM - %h ,  pc - %h",icode,cnd,valP,valC,valM,pc);
end
endmodule
