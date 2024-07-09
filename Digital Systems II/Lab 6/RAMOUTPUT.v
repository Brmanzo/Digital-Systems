// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module RAMOUTPUT(

	// 19 bit C Matrix Output
	input	signed [18:0] data,
	
	// 64 addresses needs a 6 bit index
	input [5:0] addr,
	
	input write_en,
	input clk
);

// Each address has a width of 19 bits
// 64 Matrix elements of 19 bits each
reg signed [18:0] mem [63:0];

always @(posedge clk)
begin
	if (write_en == 1'd1) begin
		mem[addr] <= data;
	end
end

		
endmodule
