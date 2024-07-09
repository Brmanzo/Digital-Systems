`timescale 1ns/10ps

// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

// This was the tester I made to test my indexing, but I thought it would be neat to submit
// since testing my index greatly helped me with this lab and is proof of my developments


module IndexTest_tb;

reg [5:0] indexA1 = 6'd0;
reg [5:0] indexA2 = 6'd0;
reg [5:0] indexB = 6'd0;
reg [7:0] outA1 = 8'd0;
reg [7:0] outA2 = 8'd0;
reg [7:0] outB = 8'd0;
reg [10:0] clock_count = 11'd0;
reg [10:0] row_count = 11'd0;
reg [10:0] col_count = 11'd0;
reg [10:0] Mac_count = 10'd0;

reg macc_clear = 1'd0;

// Initialized Memory
reg signed [7:0] MatrixA [63:0];
reg signed [7:0] MatrixB [63:0];

wire signed [18:0] data;

initial begin
	$readmemb("ram_a_init.txt", MatrixA);
	$readmemb("ram_b_init.txt", MatrixB);
end

integer i;
reg clk = 1'd0;

always @(posedge clk) begin
	if (clock_count < 512) begin
		if (row_count[5:0] == 6'b10_0000) begin
			row_count = 6'd0;
			col_count = col_count + 6'b10_0000;
		end
			
		indexA1 = {row_count[2:0], row_count[5:3]};
		indexA2 = indexA1 + 3'b100;
		indexB = {col_count[10:6], col_count[2:0]};
		$display("index A1: %d, index A2: %d, index B: %d, clock count: %d, row count: %d, col count: %d", indexA1, indexA2, indexB, clock_count, row_count, col_count);
		$display("Array A1: %d, Array A2: %d, Array B: %d, clock count: %d", MatrixA[indexA1], MatrixA[indexA2], MatrixB[indexB], clock_count);
		
		// outA1 = MatrixA[indexA1];
		// outA2 = MatrixA[indexA2];
		// outB = MatrixB[indexB];
		
		row_count <= row_count + 1;
		col_count <= col_count + 1;
		clock_count <= clock_count + 1;
		Mac_count <= Mac_count + 1;

	end
	else begin
		clock_count <= clock_count;
	end
end


// MAC MAC_1(.inA(outA), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(data));


always @(clock_count) begin
	if (clock_count < 512) begin
		if (Mac_count % 8 == 0) begin
			$display("Final Value");
		end
		if (Mac_count % 1 == 0) begin
			macc_clear <= 1'd1;
		end
		if (Mac_count % 2 == 0) begin
			macc_clear <= 1'd0;
		end
		$display("Data = %d", data);
	end
end

always begin
   #20;           // wait for initial block to initialize clock
   clk = ~clk;
end
endmodule
