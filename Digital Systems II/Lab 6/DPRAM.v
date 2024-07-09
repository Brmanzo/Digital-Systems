// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module DPRAM(
	
	input [5:0] in_addr1,
	input [5:0] in_addr2,
	input clk,

	output reg [7:0] out_data1,
	output reg [7:0] out_data2
);

reg signed [7:0] mem [63:0];


always @(posedge clk) begin
	out_data1 <= mem[in_addr1];
	out_data2 <= mem[in_addr2];
end


endmodule
