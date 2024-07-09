// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module MM2M(

	input	clk,
	input	start,
	input	reset,

	output reg done = 1'd0,
	output reg [10:0] clock_count = 11'd0

);

// * Memory

// Addresses to read from MatrixA and B
reg [5:0] inA1 = 6'd0;
reg [5:0] inA2 = 6'd0;
reg [5:0] inB = 6'd0;

// Counters to increment row and column addresses
reg [10:0] row_count = 11'd0;
reg [10:0] col_count = 11'd0;


// Addresses to write to MatrixC
reg [5:0] mem_addr1 = 6'd0;
reg [5:0] mem_addr2 = 6'd4;

// Counter to increment row addresses quarterly
reg [1:0] up_addr = 2'd0;


// * Internal Signals

reg macc_clear = 1'd0;
reg write_en = 1'd0;


// * Internal Flags

reg first_addr = 1'd0;
reg first_cc = 1'd0;
reg first_clear = 1'd0;


// * State Logic

// State Identifiers
parameter Start = 2'd0;
parameter MAC_Op = 2'd1;
parameter Done = 2'd2;

// State Registers
reg [1:0] state_c = 2'd0;
reg [1:0] state = 2'd0;


// * Dual Port Registers 
reg signed [18:0] outMAC1;
reg signed [18:0] outMAC2;

// Addresses to be sent to RAMOUTPUT
reg [5:0] RAMADDR = 6'd0;
reg [5:0] temp_ramaddr = 6'd0;

// Data to be sent to RAMOUTPUT
reg signed [18:0] RAMINPUT = 19'd0;
reg signed [18:0] temp_raminput = 19'd0;

// Wires recording secondary MAC values
wire signed [18:0] outMAC1w;
wire signed [18:0] outMAC2w;

// Initialize memory
initial begin
	$readmemb("ram_a_init.txt", myRAMA.mem);
	$readmemb("ram_b_init.txt", myRAMB.mem);
end


// * Next State Logic

// Resets if reset is asserted
// otherwise selects next state
always @(posedge clk) begin
	if (reset == 1'd1)
		state <= Start;
	else
		state <= state_c;
end


// * Combinational Logic

// State pathways
always @(*) begin
		case (state)
			// Begins operation when start is asserted
				Start:	state_c <= start ? MAC_Op : Start;

				// Exits operation when clock count is at expected value
				MAC_Op: begin
									if (clock_count == 10'd260) begin
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

// Address calculation
always @(clock_count) begin
				// Row value + row bias
				inA1 = {row_count[2:0], row_count[5:3]};
				// Row2 is always 4 above Row1
				inA2 = inA1 + 3'b100;
				// Column value + column bias
				inB = {col_count[10:6], col_count[2:0]};
end										
				

// State signal assertions				
always @(posedge clk) begin
// Remembers wire outputs in local registers
// to send to RAMOUTPUT
outMAC1 <= outMAC1w;
outMAC2 <= outMAC2w;

		case (state)
				Start: begin
								macc_clear <= 1'd1;
								write_en <= 1'd0;
								mem_addr1 <= 1'd0;
								mem_addr2 <= 3'd4;
								
						 end

				MAC_Op: begin
										macc_clear <= 1'd0;
										case (clock_count[2:0])
													3'b000: begin
																if (clock_count > 4'd7) begin
																			macc_clear <= 1'd1;
																			
																end
																// Doesnt clear until after first write
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end	
													end
													3'b001: begin
																if (clock_count > 4'd7) begin
																// Inputs MAC2 result and address
																// to RAM after first cycle
																			RAMINPUT <= temp_raminput;
																			RAMADDR <= temp_ramaddr;
																			write_en <= 1'd1;																			
																end
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end
													end
													3'b010: begin
																if ((clock_count < 11'd8)) begin
																		// keep addresses at 0 for first cycle
																		mem_addr1 <= 1'd0;
																		mem_addr2 <= 3'd4;
																end
																else if ((clock_count > 4'd8) && (up_addr < 2'd3)) begin
																		// Increment addresses every three times
																		mem_addr1 <= mem_addr1 + 1'd1;
																		mem_addr2 <= mem_addr2 + 1'd1;
																		up_addr <= up_addr + 1'd1;
																end
																else if ((clock_count > 4'd8) && (up_addr == 2'd3)) begin
																		// Increment addresses by five every fourth time
																		mem_addr1 <= mem_addr1 + 3'd5;
																		mem_addr2 <= mem_addr2 + 3'd5;
																		up_addr <= 1'd0;
																end
																if (clock_count > 4'd7) begin
																			// Input result and address from
																			//	MAC1 to RAM on first cycle
																			RAMINPUT <= outMAC1;
																			RAMADDR <= mem_addr1;
																			temp_raminput <= outMAC2;
																			temp_ramaddr <= mem_addr2;
																			write_en <= 1'd1;		
																end
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end	
													end
													3'b011: begin
																if (clock_count > 4'd7) begin
																			RAMINPUT <= temp_raminput;
																			RAMADDR <= temp_ramaddr;
																			write_en <= 1'd1;																			
																end
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
										
										if (first_cc == 1'd1) begin
												// Increments row and column counters
												// as well as clock_count
												row_count <= row_count + 11'd1;
												col_count <= col_count + 11'd1;
												clock_count <= clock_count + 11'd1;
												// If row count is 31, reset to zero and
												// set column count [5:0] to zero
												if (row_count[5:0] == 6'b01_1111) begin
														row_count <= 11'd0;
														col_count <= col_count + 6'b10_0001;
												end		
										end
										// otherwise keep everything at zero and clear
										else if (first_cc == 1'd0) begin
												row_count <= 11'd0;
												col_count <= 11'd0;
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
						 

wire signed [7:0] outA1, outA2, outB;

// Instantiate MACs, Single Port and Dual Port RAM inputs and Single port RAM output

DPRAM myRAMA(.in_addr1(inA1), .in_addr2(inA2), .clk(clk), .out_data1(outA1), .out_data2(outA2));

SPRAM myRAMB(.in_addr(inB), .clk(clk), .out_data(outB));

MAC MAC_1( .inA(outA1), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC1w));

MAC MAC_2( .inA(outA2), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC2w));

RAMOUTPUT RAMOUTPUT( .data(RAMINPUT), .addr(RAMADDR), .write_en(write_en), .clk(clk));

endmodule
