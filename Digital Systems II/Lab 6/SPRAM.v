// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module SPRAM(
	
	input [5:0] in_addr,
	input clk,

	output reg [7:0] out_data
);

reg signed [7:0] mem [63:0];


always @(posedge clk) begin
	out_data <= mem[in_addr];
end

endmodule
