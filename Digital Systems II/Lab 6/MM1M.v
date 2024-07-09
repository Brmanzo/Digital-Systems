// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module MM1M(

	input	clk,
	input	start,
	input	reset,

	output reg done = 1'd0,
	output reg [10:0] clock_count = 11'd0

);

// * Memory

// Addresses for MatrixA and B Elements
reg [5:0] inA = 6'd0;
reg [5:0] inB = 6'd0;

// Address for writing to MatrixC
reg [5:0] mem_addr = 6'd0;


// * Internal Signals

reg macc_clear = 1'd0;
reg write_en = 1'd0;
reg first_cc = 1'd0;
reg first_addr = 1'd0;
reg first_clear = 1'd0;


// * State Logic

// State Identifiers
parameter Start = 2'd0;
parameter MAC_Op = 2'd1;
parameter Done = 2'd2;

// State Registers
reg [1:0] state_c = 2'd0;
reg [1:0] state = 2'd0;

// Initialize memory
initial begin
	$readmemb("ram_a_init.txt", myRAMA.mem);
	$readmemb("ram_b_init.txt", myRAMB.mem);
end

// Combinational Logic
always @(*) begin
		case (state)
				// Begins operation when start is asserted
				Start:	state_c <= start ? MAC_Op : Start;

				
				// Exits operation when writing to final address
				MAC_Op: begin
									if ((mem_addr == 6'd63) && (write_en == 1'b1)) begin
												state_c <= Done;
									end
									else begin
												state_c <= MAC_Op;
									end
							end
							
				// Stays in done until reset
				Done: 	state_c <= Done;

		endcase
end

// Resets if reset is asserted
// otherwise selects next state
always @(posedge clk) begin
	if (reset == 1'd1)
		state <= Start;
	else
		state <= state_c;
end


// Calculates Matrix A and B addresses from Clock_Count
always @(clock_count) begin
				// Row value + row bias
				inA = {clock_count[2:0], clock_count[5:3]};
				// Column value + column bias
				inB = {clock_count[10:6], clock_count[2:0]};
end										
										
// Combinational Logic


always @(posedge clk) begin
		case (state)
				Start: begin
								macc_clear <= 1'd1;
								write_en <= 1'd0;
						 end

				MAC_Op: begin
										case (clock_count[2:0])
													3'b001: begin
																macc_clear <= 1'd0;
																write_en <= 1'd0;
																if ((first_addr == 1'd1) && (clock_count > 1'd9)) begin
																			mem_addr <= mem_addr + 1;
																end
																// Keeps address at 0 until written to 0
																else if ((first_addr == 1'd0) && (clock_count ==  1'd9)) begin
																			mem_addr <= 6'd0;
																			first_addr <= 1'd1;
																end
													end
										
													3'b000: begin
																if (clock_count > 1'd8) begin
																			write_en <= 1'd1;
																			macc_clear <= 1'd1;
																end
																// Doesnt clear until after first write
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end				
													end
													default: begin
																macc_clear <= 1'd0;
																write_en <= 1'd0;
													end
										endcase
										// Increments clock for every successive operation
										if (first_cc == 1'd1) begin
												clock_count <= clock_count + 11'd1;
										end
										// Keeps MAC clear until beginning operation
										else if (first_cc == 1'd0) begin
												clock_count <= 11'd0;
												first_cc <= 1'd1;
												macc_clear <= 1'd1;
										end
										if ((first_cc == 1'd1) && (clock_count == 11'd0)) begin
												macc_clear <= 1'd1;
										end
							end
				Done: begin
								done <= 1'd1;
								write_en <= 1'd0;
								macc_clear <= 1'd0;
						 end
		endcase
end
						 


// Instantiate MAC Single Port RAM Inputs and Outputs

wire signed [18:0] MAC_to_RAM;

wire signed [7:0] outA;

wire signed [7:0] outB;

SPRAM myRAMA(.in_addr(inA), .clk(clk), .out_data(outA));

SPRAM myRAMB(.in_addr(inB), .clk(clk), .out_data(outB));

MAC MAC_1( .inA(outA), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(MAC_to_RAM));

RAMOUTPUT RAMOUTPUT( .data(MAC_to_RAM), .addr(mem_addr), .write_en(write_en), .clk(clk));

endmodule
