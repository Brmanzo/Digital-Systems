// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad


module OPRAM(
	
	input [5:0] in_addr1,
	input [5:0] in_addr2,
	input [5:0] in_addr3,
	input [5:0] in_addr4,
	input [5:0] in_addr5,
	input [5:0] in_addr6,
	input [5:0] in_addr7,
	input [5:0] in_addr8,
	input clk,

	output reg signed [7:0] out_data1,
	output reg signed [7:0] out_data2,
	output reg signed [7:0] out_data3,
	output reg signed [7:0] out_data4,
	output reg signed [7:0] out_data5,
	output reg signed [7:0] out_data6,
	output reg signed [7:0] out_data7,
	output reg signed [7:0] out_data8
);

reg signed [7:0] mem [63:0];


always @(posedge clk) begin
	out_data1 <= mem[in_addr1];
	out_data2 <= mem[in_addr2];
	out_data3 <= mem[in_addr3];
	out_data4 <= mem[in_addr4];
	out_data5 <= mem[in_addr5];
	out_data6 <= mem[in_addr6];
	out_data7 <= mem[in_addr7];
	out_data8 <= mem[in_addr8];
end


endmodule
