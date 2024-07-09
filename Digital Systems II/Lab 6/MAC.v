// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module MAC(

	input signed [7:0] inA,
	input signed [7:0] inB,
	input clk,
	input macc_clear,
	
	output reg signed [18:0] out
	
);

//=======================================================
//  Structural coding
//=======================================================
reg signed [18:0] out_c;

always @(posedge clk) begin
		out <= out_c;
end

always @(*) begin
	if(macc_clear == 0) begin
		out_c <= (inA * inB) + out;
	end
	else
		out_c <= inA * inB;
end
endmodule
