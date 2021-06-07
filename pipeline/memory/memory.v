`timescale 1ns/1ps

module memory( input M[144:0], input clk, output reg [3:0] M_icode, output reg M_Cnd,output [63:0] M_valE, output reg [63:0] M_valA, output reg [3:0] M_dstE, output reg [3:0] M_dstM, output reg[63:0]  m_valM, output [1:0] stat, output [144:0] W);


reg read ;
reg [3:0] icode;
reg [63:0] valA;
reg [63:0] valE;
reg cnd;
reg dmem_error;
reg [63:0] valM;
reg write ;
reg [63:0] address;
reg [63:0] data;
reg [63:0] mem[0:200];

always@ (posedge clk)
begin
	dmem_error = 0;
	read = 0;
	icode =M[143:140];
	cnd = M[139:136];
	M_cnd = cnd;
	valA = M[71:8];
	valE = M[135:72];
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
	if(icode == 4 || icode == 10 || icode == 8)
        begin
                data = valA;
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

	// need to write status codes
	

	// writing into the register W
	W[144] = M[144];
	W[143:140] = icode;
	
	W[3:0] = M[3:0];
	W[7:4] = M[7:4];
	W[71:8] = valM;
	W[135:72] = valE;
	
	M_valA = valA;
	M_icode = icode;
	M_cnd = cnd;
	M_valE = valE;
	M_dstE = M[7:4];
	M_dstM = M[3:0];
	m_valM = valM;

end
endmodule
