`timescale 1ns/1ps

module fetch(input [10:0] pc,output [3:0] icode,output [3:0] ifun,output [3:0] rA,output [3:0] rB,output [63:0] valC,output [10:0] valP,output instr_valid,output imem_error,output reg f_com);


reg [3:0] icode;
reg [3:0] ifun;
reg [3:0] rA;
reg [3:0] rB;
reg [63:0] valC;
reg [10:0] valP = 0;
reg instr_valid = 1;
reg imem_error =0;
reg [7:0] temp;
reg [10:0] pc_inc = 0;


// defining the instruction memory here.
reg [7:0] i_mem [0:1000];
initial begin
	$readmemh("instr_mem.txt",i_mem);
end
// End of instruction memory defining 



always @(pc)
begin
	f_com = 0;
	rA = 15;
	rB = 15;
	valP = pc;
	if (pc>1000) // This condition changes according to the size of the instruction memory.
		imem_error = 1;
	else 
	begin
		if(i_mem[pc][7:4]>11)
			instr_valid = 0;
		else
		begin
			icode = i_mem[pc][7:4];
			ifun = i_mem[pc][3:0];
			valP = valP+1;
			if(i_mem[pc][7:4] == 2 || i_mem[pc][7:4] == 3 ||i_mem[pc][7:4] == 4 || i_mem[pc][7:4] == 5 || i_mem[pc][7:4] == 6 || i_mem[pc][7:4] == 10 || i_mem[pc][7:4] == 11)
			begin
				
			       	valP = valP+1;
				if(i_mem[pc][7:4] == 3)
				begin
				       rA = 15;
			        	rB = i_mem[pc+1][3:0];
			       	end
				else if(i_mem[pc][7:4] == 10 || i_mem[pc][7:4] == 11)
				begin
					rB = 15;
					rA = i_mem[pc+1][7:4];
				end	
				else
				begin
					rA = i_mem[pc+1][7:4];
					rB = i_mem[pc+1][3:0];
				end
			end
			if(i_mem[pc][7:4] == 3 || i_mem[pc][7:4] == 4 ||i_mem[pc][7:4] == 5 || i_mem[pc][7:4] == 7 || i_mem[pc][7:4] == 8)
			begin
				if (i_mem[pc][7:4]==8 || i_mem[pc][7:4]==7)
				begin
				valC[7:0] = i_mem[pc+1];
				valC[15:8] = i_mem[pc+2];
				valC[23:16] = i_mem[pc+3];
				valC[31:24] = i_mem[pc+4];
				valC[39:32] = i_mem[pc+5];
				valC[47:40] = i_mem[pc+6];
				valC[55:48] = i_mem[pc+7];
				valC[63:56] = i_mem[pc+8];
				valP = valP+8;
				end
				else
				begin
				valC[7:0] = i_mem[pc+2];
				valC[15:8] = i_mem[pc+3];
				valC[23:16] = i_mem[pc+4];
				valC[31:24] = i_mem[pc+5];
				valC[39:32] = i_mem[pc+6];
				valC[47:40] = i_mem[pc+7];
				valC[55:48] = i_mem[pc+8];
				valC[63:56] = i_mem[pc+9];
				valP = valP+8;
				end
			end
			
		end
	end	
	
	if(icode == 0)
	begin
		$display("Stat -SHLT");
		$display("halt encounterd");
		#1;
		$finish;
	end
	$display("\n\n\n Fetch -- icode - %h, ifun -  %h, rA -%h, rB - %h, valc - %h, valP - %h, pc - %h", icode, ifun, rA, rB, valC, valP, pc);	
	f_com = 1;
end
endmodule
