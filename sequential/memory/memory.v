`timescale 1ns/1ps

module memory(icode,valA,valE,valP,valM,imem_error,instr_valid,dmem_error,stat,e_com);
input [3:0] icode;
input [63:0] valA;
input [10:0] valP;
input [63:0] valE;
output [63:0] valM;
output dmem_error;
input imem_error;
input instr_valid;
output [1:0] stat;
reg [1:0] stat;
// defining memory block
reg [63:0] mem[0:200];
input e_com;
/*
initial begin
	mem[0] =0;
	mem[1] = 1;
	mem[2] = 10;
	mem[3] = 3;
	mem[4] = 4;
	mem[5] = 5;
	mem[6] =6;
	mem[7] = 7;
end
*/
reg read ;
reg dmem_error;
reg [63:0] valM;
reg write ;
reg [63:0] address;
reg [63:0] data;
/*
mem_read call1(icode,read);
mem_write call2(icode,write);
mem_address call3(icode,valE,valA,address);
mem_data call4(icode,data,valA,valP);
*/
always @(posedge e_com)
begin
	dmem_error = 0;
	// read logic
	read =0;
	if(icode == 11 || icode == 5 || icode== 9)
		read = 1;
	// write logic
	write = 0;
	if (icode == 4 || icode == 8 || icode == 10)
	begin
		write = 1;
	end
	
	// address logic
	address = 0;
	if(icode  == 9 || icode == 11 )
		address = valA;
	else if(icode == 5 || icode == 4 || icode == 10 || icode == 8)
		address = valE;	

	// data logic
	data = 0;
	if(icode == 4 || icode == 10)
	begin
		data = valA;
	end
	else if(icode == 8)
	begin
		data = valP;
	end

	// memory read or write
	if(address>200)
	begin
		dmem_error = 1;
	end
	else if(write === 1)
	begin
		mem[address] = data;	
		$display("write - %d %d %d %d", address,data,valE,valA);
	end
	else if(read === 1)
	begin
		valM = mem[address];
		$display("read -%d %d %d %d" ,valM,address,valE,valA);
	end
	
	// stat code updating
	if(imem_error || dmem_error) stat = 1;
	else if(!instr_valid) stat = 2;
	else if(icode ==0) stat =3;
	else stat = 0;

	if(stat == 0) $display("stat - SAOK , icode - %h\n",icode);
	else if(stat == 1) begin $display("stat - SADR , icode - %h\n",address); $finish; end
	else if(stat == 2) begin $display("stat - SINS , icode - %h\n",icode); $finish; end
	else if(stat == 3) begin $display("stat -SHLT , icode - %h\n",icode); $finish; end
	$display("Memory -- icode - %h, address - %h, data - %h, read - %h , write - %h",icode, address, data, read, write);
end
endmodule

module mem_read(icode,read);
input [3:0] icode;
output read;
reg read;
always @(*)
begin
	read =0;
	if(icode == 11 || icode == 5 || icode== 9)
		read = 1;
end
endmodule

module mem_write(icode,write);
input [3:0] icode;
output write;
reg write;

always@ (*)
begin
	write = 0;
	if (icode == 4 || icode == 8 || icode == 10)
	begin
		write = 1;
	end
end
endmodule


module mem_address(icode,valE,valA,address);
input [3:0] icode;
input [63:0] valE;
input [63:0] valA;
output [63:0] address;

reg [63:0] address;

always@(*)
begin
	address = 0;
	if(icode  == 9 || icode == 11 )
		address = valA;
	else if(icode == 5 || icode == 4 || icode == 10 || icode == 8)
		address = valE;	
end
endmodule

module mem_data(icode,data,valA,valP);
input [3:0] icode;
input [63:0] valA;
input [10:0] valP;
output [63:0] data;

reg [63:0] data;

always @(*)
begin
	data = 0;
	if(icode == 4 || icode == 10)
	begin
		data = valA;
	end
	else if(icode == 8)
	begin
		data = valP;
	end

end
endmodule
