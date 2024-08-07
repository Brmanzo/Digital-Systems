
//======================================================= 
//  This code is generated by Terasic System Builder 
//======================================================= 
`timescale 1ps/1ps

module Lab3Part4Final_tb;

reg [2:0] in1;
reg [2:0] in2;
reg        ci;

wire [3:0] sum;
wire [3:0] sum_ref;
wire 	   co;

integer i;
integer j;
integer k;

//add3 add3_DUT(.in1(in1[2:0]), .in2(in2[2:0]), .ci(ci), .sum(sum[3:0]));
add3_error add3_error_DUT(.in1(in1[2:0]), .in2(in2[2:0]), .ci(ci), .sum(sum[3:0]));
add3_ref add3_ref_DUT(.in1(in1[2:0]), .in2(in2[2:0]), .ci(ci), .sum(sum_ref[3:0]));

initial begin
for(i = 0; i < 2; i = i + 1)
begin
	#10;
	ci = i;
	#10;
	for(j = 0; j < 8; j = j + 1)
	begin
		#10;
		in1 = j;
		#10;
		for(k = 0; k < 8; k = k + 1)
		begin
			
				#10;
				in2 = k;
				#10;
				if(sum == sum_ref)
				begin
					$display("carry in = %d, in1 = %d, in2 = %d, sum = %d, sum_ref = %d, pass", ci, in1, in2, sum, sum_ref);
				end
				else
				begin
					$display("carry in = %d, in1 = %d, in2 = %d, sum = %d, sum_ref = %d, fail", ci, in1, in2, sum, sum_ref);
				end
			end
		end
	end
end
endmodule 



