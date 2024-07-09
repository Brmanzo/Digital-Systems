// Bradley Manzo
// 916953788
// May 19th, 2022
// Prof Hussain Al-Asaad

`timescale 1ps/1ps
module Counter1_tb;
reg reset;
reg enable;
reg[5:0] divideby;
reg clk;
wire go;
wire [5:0] count;


Counter1 Counter1_DUT(.reset(reset), .enable(enable), .divideby(divideby[5:0]), .clk(clk), .go(go), .count(count));

initial begin
	clk = 0;
	// Tests normal counter operation up to 6
	reset = 1;
	enable = 1;
	divideby = 6'b00_0110;
	$display("Case: Normal Operation to 6");
	@(posedge clk)
	#10;
	$display("count: %d, go: %d", count, go);
	#10
	reset = 0;
	enable = 1;
	repeat(20) begin
		@(posedge clk)
		#10;
		$display("count: %d, go: %d", count, go);
	end


	// Tests normal counter operation up to 15
	$display("Case: Normal Operation to 15");
	reset = 1;
	enable = 1;
	@(posedge clk)
	#10;
	$display("(Reset to zero)");
	$display("count: %d, go: %d", count, go);
	#10;
	reset = 0;
	enable = 1;
	divideby = 6'b00_1111;
	repeat(20) begin
		@(posedge clk)
		#10;
		$display("count: %d, go: %d", count, go);
	end


	// Tests normal counter operation interupted by a reset
	$display("Case: Reset Mid-Operation");
	reset = 1;
	enable = 1;
	$display("(Reset to zero)");
	@(posedge clk)
	#10;
	$display("count: %d, go: %d", count, go);
	reset = 0;
	enable = 1;
	repeat(10) begin
		@(posedge clk)
		#10;
		$display("count: %d, go: %d", count, go);
	end
	reset = 1;
	enable = 1;
	$display("(Reset to zero)");
	@(posedge clk)
	#10;
	$display("count: %d, go: %d", count, go);
	reset = 0;
	enable = 1;
	repeat(10) begin
		@(posedge clk)
		#10;
		$display("count: %d, go: %d", count, go);
	end


	// Tests when normal operation is interupted by setting all switches to zero
	$display("Case: Divideby set to 0 Mid-Operation");
	reset = 1;
	enable = 1;
	$display("(Reset to zero)");
	@(posedge clk)
	#10;
	$display("count: %d, go: %d", count, go);
	reset = 0;
	enable = 1;
	repeat(10) begin
		@(posedge clk)
		#10;
		$display("count: %d, go: %d", count, go);
	end
	reset = 1;
	enable = 1;
	$display("(Reset to zero)");
	@(posedge clk)
	#10;
	$display("count: %d, go: %d", count, go);
	reset = 0;
	enable = 1;
	divideby =	6'b00_0000;
	$display("(Divideby set to 0)");
	@(posedge clk)
	#10;
	$display("count: %d, go: %d", count, go);
	reset = 0;
	enable = 1;
	repeat(10) begin
		@(posedge clk)
		#10;
		$display("count: %d, go: %d", count, go);
	end
end



// This always block creates an inverting clock pulse of #20 time delay
always 
begin
	clk = #20 ~clk;
end

endmodule 