// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

`timescale 1ns/10ps

module MAC_tb;

	reg signed[7:0] inA;
	reg signed[7:0] inB;
	reg clk;
	reg macc_clear;
	
	wire signed[18:0] out;

//=======================================================

MAC MAC_DUT(.inA(inA), .inB(inB), .clk(clk), .macc_clear(macc_clear), .out(out));

//=======================================================

initial begin
	clk = 1'b0;

	// First Test
	inA = 8'b11110100;
	inB = 8'b10001110;
	macc_clear = 0;
	#10;
	macc_clear = 1;
	#10;
	macc_clear = 0;
	#10;
	$display("Case: Single Multiply (-12 x -114)");
	@(posedge clk)
	$display("out: %d", out);

	// Reset MAC
	inA = 8'd0;
	inB = 8'd0;
	macc_clear = 0;
	#10;
	macc_clear = 1;
	#10;
	@(posedge clk)
	#10;


	// Second Test
	inA = 8'd5;
	inB = 8'd6;
	macc_clear = 1;
	#10;
	macc_clear = 0;
	#10;
	$display("Case: Accumulate 30 and 6");
	$display("Multiply 6 x 5");
	@(posedge clk)
	#10;
	$display("out: %d", out);
	#10;
	inA = 8'd2;
	inB = 8'd3;
	macc_clear = 0;
	#10;
	$display("Multiply 2 x 3");
	@(posedge clk)
	#10;
	$display("out: %d", out);
	#10;

	inA = 8'd0;
	inB = 8'd0;
	macc_clear = 1;
	#10;
	@(posedge clk)
	#10;


	// Third Test
	inA = 8'd5;
	inB = 8'd6;
	macc_clear = 0;
	#10;
	$display("Case: Cleared Mid-Operation");
	$display("Multiply 6 x 5");
	@(posedge clk)
	#10;
	$display("out: %d", out);
	#10;

	inA = 8'd0;
	inB = 8'd0;
	macc_clear = 1;
	#10;
	@(posedge clk)
	#10;
	$display("Reset");
	$display("out: %d", out);

	inA = 8'd2;
	inB = 8'd3;
	macc_clear = 0;
	#10;
	$display("Multiply 2 x 3");
	@(posedge clk)
	#10;
	$display("out: %d", out);
	#10;
end

always 
begin
 #20	clk = ~clk;
end

endmodule
