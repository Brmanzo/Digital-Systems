// Bradley Manzo
// 916953788
// May 19th, 2022
// Prof Hussain Al-Asaad

`timescale 1ps/1ps

module Counter2_tb;

reg reset;
reg enable1;
reg enable2;
reg updown;
reg freerun;
reg clk;
reg[5:0] divideby;
reg[23:0] halfmax;
wire[23:0] count;
wire[9:0] LEDR;


Counter2 Counter2_DUT(.reset(reset), .enable1(enable1), .enable2(enable2), .updown(updown), .freerun(freerun), .clk(clk), .divideby(divideby), .halfmax(halfmax), .count(count), .LEDR(LEDR));

initial begin
	clk = 1'b0;
	
	reset = 1'b1;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0111;
	#10;
	// Begins with a reset and tests normal operation with freerun high and updown high
	$display("Case: free up");
	@(posedge clk)
	#10;
	$display("count: %d, LEDR: %d", count, LEDR);
	#10
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0001;
	halfmax = 24'd6;
	repeat(20) begin
		@(posedge clk)
		#10;
		$display("count: %d, LEDR: %d", count, LEDR);
	end
	

	#10
	reset = 1'b1;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0111;
	#10
	// Begins with a reset and tests normal operation with freerun low and updown high
	$display("Case: run up, halfmax = 6");
	@(posedge clk)
	#10;
	$display("count: %d, LEDR: %d", count, LEDR);
	#10;
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b0;
	divideby = 6'b00_0001;
	// Halfmax defined as arbitrary value to view behavior in a reasonable amount of cycles
	halfmax = 24'd6;
	repeat(20) begin
		@(posedge clk)
		#10;
		$display("count: %d, LEDR: %d", count, LEDR);
	end

	
	#10;
	reset = 1'b1;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0111;
	#10;
	// Begins with a reset and tests normal operation with freerun high and updown low
	$display("Case: free down");
	@(posedge clk)
	#10;
	$display("count: %d, LEDR: %d", count, LEDR);
	#10;
	
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0001;
	repeat(20) begin
		@(posedge clk)
		#10;
	end
	#10;
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b0;
	freerun = 1'b1;
	divideby = 6'b00_0001;
	halfmax = 24'd6;
	repeat(20) begin
		@(posedge clk)
		#10;
		$display("count: %d, LEDR: %d", count, LEDR);
	end
	
	
	#10;
	reset = 1'b1;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0111;
	#10;
	// Begins with a reset and tests normal operation with freerun low and updown low
	$display("Case: run down, halfmax = 6");
	@(posedge clk)
	#10;
	$display("count: %d, LEDR: %d", count, LEDR);
	#10;
	
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0001;
	// Halfmax defined as arbitrary value to view behavior in a reasonable amount of cycles
	halfmax = 24'd6;
	repeat(20) begin
		@(posedge clk)
		#10;
	end
	#10;
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b0;
	freerun = 1'b0;
	divideby = 6'b00_0001;
	halfmax = 24'd6;
	repeat(20) begin
		@(posedge clk)
		#10;
		$display("count: %d, LEDR: %d", count, LEDR);
	end
	
	reset = 1'b1;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0111;
	#10;

	// Begins with a reset and tests normal operation when interupted with a reset
	$display("Case: Reset Hold");
	@(posedge clk)
	#10;
	$display("count: %d, LEDR: %d", count, LEDR);
	#10
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0001;
	repeat(10) begin
		@(posedge clk)
		#10;
		$display("count: %d, LEDR: %d", count, LEDR);
	end
	reset = 1'b1;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0111;
	@(posedge clk)
	#10;
	$display("count: %d, LEDR: %d", count, LEDR);
	#10;
	reset = 1'b0;
	enable1 = 1'b1;
	enable2 = 1'b1;
	updown = 1'b1;
	freerun = 1'b1;
	divideby = 6'b00_0001;
	halfmax = 24'd6;
	repeat(10) begin
		@(posedge clk)
		#10;
		$display("count: %d, LEDR: %d", count, LEDR);
	end
end

// This always block creates an inverting clock pulse of #20 time delay
always 
begin
	clk = #20 ~clk;
end

endmodule 