// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad


module DUALRAMOUTPUT(

	// 19 bit C Matrix Output
	input	signed [18:0] data1,
	input	signed [18:0] data2,
	
	// 64 addresses needs a 6 bit index
	input [5:0] addr1,
	input [5:0] addr2,
	
	input write_en,
	input clk
);

// Each address has a width of 19 bits
// 64 Matrix elements of 19 bits each
reg signed [18:0] mem [63:0];

always @(posedge clk)
begin
	if (write_en == 1'd1) begin
		mem[addr1] <= data1;
		mem[addr2] <= data2;
	end
end

		
endmodule
