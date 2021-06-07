`timescale 1ns/ 1ps

module and32( a, b, out);
input [63:0]  a;
input [63:0] b;
output [63:0] out;
genvar i;
for ( i=0;i<64;i = i+1)
begin
	and(out[i],a[i],b[i]);
end
endmodule
