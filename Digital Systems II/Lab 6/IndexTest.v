// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

// This was the tester I made to test my indexing, but I thought it would be neat to submit
// since testing my index greatly helped me with this lab and is proof of my developments

module IndexTest_tb;

reg [5:0] indexA = 6'd0;
reg [5:0] indexB = 6'd0;
reg [10:0] clock_count = 10'd0;

initial begin
	for(i = 0; i < 512; i = i + 1) begin
		indexA = clock_count[2:0]*8 + clock_count[5:3];
		indexB = clock_count[2:0] + clock_count[10:6]*8;
		$display("index A: %d, index B: %d, clock count: %d", indexA, indexB, clock_count);
		clock_count = clock_count + 1;
	end
end
endmodule
