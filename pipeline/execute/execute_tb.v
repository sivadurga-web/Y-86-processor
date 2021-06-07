`timescale 1ns/1ps
`include "execute.v"
`include "../decode/decode.v"
`include "../fetch/fetch.v"

module execute_tb;
reg [3:0] M_icode;
reg [63:0] M_valA;
reg M_cnd;
reg [3:0] W_icode;
reg [63:0] W_valM;
wire [144:0] D;
reg clk;
wire [3:0] e_dstE;
wire [63:0] e_valE;
reg [3:0] M_dstE;
reg [63:0] M_valE;
reg [3:0] M_dstM;
reg [63:0] m_valM;
reg [3:0] W_dstE;
reg [63:0] W_valE;
reg [3:0] W_dstM;
wire [216:0] E;
reg [144:0] dec_rgstr;
reg [216:0] exec_rgstr;
reg W_stat;
reg m_stat;
wire [144:0] M;
reg [144:0] mem_rgstr;
fetch call1(clk,M_icode,M_cnd,M_valA,W_icode,W_valM,D);

decode decode_p(dec_rgstr,clk,e_dstE,e_valE,M_dstE,M_valE,M_dstM,m_valM,W_dstE,W_valE,W_dstM,W_valM,E);
execute execute_e(clk,exec_rgstr,W_stat,m_stat,e_valE,e_dstE,M);
parameter stop_time = 2000;
initial #stop_time $finish;
initial begin

        //$monitor("main  %d ",pc);
        $dumpfile("execute.vcd");
        $dumpvars(0,execute_tb);
        clk = 0;
        M_icode= 0;
        M_valA = 0;
        M_cnd = 0;
        W_icode =0;
        W_valM = 0;

end
always @(*)
begin

        dec_rgstr = D;
        exec_rgstr = E;
	mem_rgstr = M;
end
always begin
                $display("hello %h %h",D,E);
        if(D[143:140]==0)
        begin
                              #5;
                              clk=~clk;
                              #5;
			      clk=~clk;
			      #5;
                $finish;
        end
        else
        begin

                #5 clk = ~clk;
        end
end
endmodule
