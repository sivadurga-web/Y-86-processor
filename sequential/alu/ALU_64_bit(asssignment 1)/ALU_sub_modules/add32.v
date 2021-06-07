module add32( a, b, sum, carry);
input [63:0] a;
input [63:0] b;
output [63:0] sum;
output carry;

genvar i;
reg carry = 0;
reg [64:0] c=0;
reg [63:0] sum;
for(i=0; i<64; i=i+1)
begin
	always @(a[i] or b[i]  or c[i])
	begin
		if(i==63)
		begin
			sum[i] = a[i]^b[i]^c[i];
			carry = a[i]&b[i] | b[i]&c[i] |c[i]&a[i];
			if(a[63]==1  && b[63] == 1  && sum[63] == 0)
			begin
				carry = 1;
			end
			else if (a[63]==0  && b[63] == 0  && sum[63] == 1)
			begin
				carry = 1;
			end
			else
			begin
				carry = 0;
			end
		end
		else
		begin
			sum[i] = a[i]^b[i]^c[i];
			c[i+1] = a[i]&b[i] | b[i]&c[i] |c[i]&a[i]; 
		end

	end
end

endmodule
