// Bradley Manzo
// 916953788
// June 6, 2022
// Prof Hussain Al-Asaad

module MM8M(

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
reg [5:0] inA3 = 6'd0;
reg [5:0] inA4 = 6'd0;
reg [5:0] inA5 = 6'd0;
reg [5:0] inA6 = 6'd0;
reg [5:0] inA7 = 6'd0;
reg [5:0] inA8 = 6'd0;
reg [5:0] inB = 6'd0;

// Counters to increment row and column addresses
reg [10:0] row_count = 11'd0;
reg [10:0] col_count = 11'd0;


// Addresses to write to MatrixC
reg [5:0] mem_addr1 = 6'd0;
reg [5:0] mem_addr2 = 6'd1;
reg [5:0] mem_addr3 = 6'd2;
reg [5:0] mem_addr4 = 6'd3;
reg [5:0] mem_addr5 = 6'd4;
reg [5:0] mem_addr6 = 6'd5;
reg [5:0] mem_addr7 = 6'd6;
reg [5:0] mem_addr8 = 6'd7;

// Counter to increment row addresses quarterly
// reg [1:0] up_addr = 2'd0;


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
reg signed [18:0] outMAC3;
reg signed [18:0] outMAC4;
reg signed [18:0] outMAC5;
reg signed [18:0] outMAC6;
reg signed [18:0] outMAC7;
reg signed [18:0] outMAC8;

// Addresses to be sent to RAMOUTPUT
reg [5:0] RAMADDR1 = 6'd0;
reg [5:0] RAMADDR2 = 6'd0;
reg [5:0] temp_ramaddr1 = 6'd0;
reg [5:0] temp_ramaddr2 = 6'd0;
reg [5:0] temp_ramaddr3 = 6'd0;
reg [5:0] temp_ramaddr4 = 6'd0;
reg [5:0] temp_ramaddr5 = 6'd0;
reg [5:0] temp_ramaddr6 = 6'd0;


// Data to be sent to RAMOUTPUT
reg signed [18:0] RAMINPUT1 = 19'd0;
reg signed [18:0] RAMINPUT2 = 19'd0;
reg signed [18:0] temp_raminput1 = 19'd0;
reg signed [18:0] temp_raminput2 = 19'd0;
reg signed [18:0] temp_raminput3 = 19'd0;
reg signed [18:0] temp_raminput4 = 19'd0;
reg signed [18:0] temp_raminput5 = 19'd0;
reg signed [18:0] temp_raminput6 = 19'd0;

// Wires recording secondary MAC values
wire signed [18:0] outMAC1w;
wire signed [18:0] outMAC2w;
wire signed [18:0] outMAC3w;
wire signed [18:0] outMAC4w;
wire signed [18:0] outMAC5w;
wire signed [18:0] outMAC6w;
wire signed [18:0] outMAC7w;
wire signed [18:0] outMAC8w;

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
									if (clock_count == 10'd69) begin
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
				inA1 = row_count;
				// Row2 is always 4 above Row1
				inA2 = inA1 + 3'b001;
				inA3 = inA1 + 3'b010;
				inA4 = inA1 + 3'b011;
				inA5 = inA1 + 3'b100;
				inA6 = inA1 + 3'b101;
				inA7 = inA1 + 3'b110;
				inA8 = inA1 + 3'b111;
				
				// Column value + column bias
				inB = col_count;
end										
				

// State signal assertions				
always @(posedge clk) begin
// Remembers wire outputs in local registers
// to send to RAMOUTPUT
outMAC1 <= outMAC1w;
outMAC2 <= outMAC2w;
outMAC3 <= outMAC3w;
outMAC4 <= outMAC4w;
outMAC5 <= outMAC5w;
outMAC6 <= outMAC6w;
outMAC7 <= outMAC7w;
outMAC8 <= outMAC8w;

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
													3'b010: begin
																if (clock_count > 4'd7) begin
																// Inputs MAC2 result and address
																// to RAM after first cycle
																			RAMINPUT1 <= outMAC1;
																			RAMADDR1 <= mem_addr1;
																			RAMINPUT2 <= outMAC2;
																			RAMADDR2 <= mem_addr2;
																			temp_raminput1 <= outMAC3;
																			temp_ramaddr1 <= mem_addr3;
																			temp_raminput2 <= outMAC4;
																			temp_ramaddr2 <= mem_addr4;
																			temp_raminput3 <= outMAC5;
																			temp_ramaddr3 <= mem_addr5;
																			temp_raminput4 <= outMAC6;
																			temp_ramaddr4 <= mem_addr6;
																			temp_raminput5 <= outMAC7;
																			temp_ramaddr5 <= mem_addr7;
																			temp_raminput6 <= outMAC8;
																			temp_ramaddr6 <= mem_addr8;
																			write_en <= 1'd1;																		
																end
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end
													end
													3'b011: begin
																if ((clock_count < 11'd7)) begin
																		// keep addresses at 0 for first cycle
																		mem_addr1 <= 6'd0;
																		mem_addr2 <= 6'd1;
																		mem_addr3 <= 6'd2;
																		mem_addr4 <= 6'd3;
																		mem_addr5 <= 6'd4;
																		mem_addr6 <= 6'd5;
																		mem_addr7 <= 6'd6;
																		mem_addr8 <= 6'd7;

																end
																else if (clock_count > 11'd7) begin
																		// Increment addresses every three times
																		mem_addr1 <= mem_addr1 + 4'b1000;
																		mem_addr2 <= mem_addr2 + 4'b1000;
																		mem_addr3 <= mem_addr3 + 4'b1000;
																		mem_addr4 <= mem_addr4 + 4'b1000;
																		mem_addr5 <= mem_addr5 + 4'b1000;
																		mem_addr6 <= mem_addr6 + 4'b1000;
																		mem_addr7 <= mem_addr7 + 4'b1000;
																		mem_addr8 <= mem_addr8 + 4'b1000;
																end
																if (clock_count > 4'd7) begin
																			// Input result and address from
																			//	MAC1 to RAM on first cycle
																			RAMINPUT1 <= temp_raminput1;
																			RAMADDR1 <= temp_ramaddr1;
																			RAMINPUT2 <= temp_raminput2;
																			RAMADDR2 <= temp_ramaddr2;
																			write_en <= 1'd1;		
																end
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end	
													end
													3'b100: begin
																if (clock_count > 4'd7) begin
																			RAMINPUT1 <= temp_raminput3;
																			RAMADDR1 <= temp_ramaddr3;
																			RAMINPUT2 <= temp_raminput4;
																			RAMADDR2 <= temp_ramaddr4;
																			write_en <= 1'd1;																			
																end
																else begin
																			write_en <= 1'd0;
																			macc_clear <= 1'd0;
																end
													end												
													3'b101: begin
																if (clock_count > 4'd7) begin
																			RAMINPUT1 <= temp_raminput5;
																			RAMADDR1 <= temp_ramaddr5;
																			RAMINPUT2 <= temp_raminput6;
																			RAMADDR2 <= temp_ramaddr6;
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
												row_count <= row_count + 11'd8;
												col_count <= col_count + 11'd1;
												clock_count <= clock_count + 11'd1;
												// If row count is 31, reset to zero and
												// set column count [5:0] to zero
												if (row_count[5:0] == 6'b11_1000) begin
														row_count <= 11'd0;
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
						 

wire signed [7:0] outA1, outA2, outA3, outA4, outA5, outA6, outA7, outA8, outB;

// Instantiate MACs, Single Port and Dual Port RAM inputs and Single port RAM output

OPRAM myRAMA(.in_addr1(inA1), .in_addr2(inA2), .in_addr3(inA3), .in_addr4(inA4), 
				 .in_addr5(inA5), .in_addr6(inA6), .in_addr7(inA7), .in_addr8(inA8), .clk(clk), 
				 .out_data1(outA1), .out_data2(outA2), .out_data3(outA3), .out_data4(outA4),
				 .out_data5(outA5), .out_data6(outA6), .out_data7(outA7), .out_data8(outA8));

SPRAM myRAMB(.in_addr(inB), .clk(clk), .out_data(outB));

MAC MAC_1( .inA(outA1), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC1w));

MAC MAC_2( .inA(outA2), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC2w));

MAC MAC_3( .inA(outA3), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC3w));

MAC MAC_4( .inA(outA4), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC4w));

MAC MAC_5( .inA(outA5), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC5w));

MAC MAC_6( .inA(outA6), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC6w));

MAC MAC_7( .inA(outA7), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC7w));

MAC MAC_8( .inA(outA8), .inB(outB), .clk(clk), .macc_clear(macc_clear), .out(outMAC8w));

DUALRAMOUTPUT RAMOUTPUT( .data1(RAMINPUT1), .data2(RAMINPUT2), .addr1(RAMADDR1), .addr2(RAMADDR2), .write_en(write_en), .clk(clk));

endmodule
