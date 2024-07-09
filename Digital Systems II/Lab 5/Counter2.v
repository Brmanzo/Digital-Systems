
// Bradley Manzo
// 916953788
// May 19th, 2022
// Prof Hussain Al-Asaad

module Counter2(reset, enable1, enable2, updown, freerun, clk, divideby, halfmax, count, LEDR);

input reset, enable1, enable2, updown, freerun, clk;

input [5:0] divideby;

input [23:0] halfmax;

output reg[23:0] count;

output reg[9:0] LEDR;

//=======================================================
//  Structural coding
//=======================================================


// Ignore if enable1 is low = no operation
always @(posedge clk) begin
	// If enable1 is high but enable2 is low, 
	if((enable1 == 1) && (enable2 == 0) && (reset == 0))begin 
			// Check if switches are zero, if yes, light up LEDs
			if(divideby == 6'b00_0000) begin
					LEDR[9:0] = 10'b11_1111_1111;	
			end
	end
	// If enable1 and enable2 are high, and reset is high, set count to zero
	else if((enable1 == 1) && (enable2 == 1) && (reset == 1)) begin
		count = 24'd0;
		LEDR[9:0] = 10'b00_0000_0000;
	end
	// All other cases for when enable1 and enable2 are high and reset is low
	else if((enable1 == 1) && (enable2 == 1) && (reset == 0)) begin
		// If Down and Run, decrement down to half of max
		if((updown == 0) && (freerun == 0)) begin	
			if(count > halfmax) begin
				count = count - 1;
			end
		end
		// If Down and Free, decrement forever
		else if ((updown == 0) && (freerun == 1)) begin
			count = count - 1;
		end
		// If Up and Run, increment to half of max
		else if ((updown == 1) && (freerun == 0)) begin
				if(count < halfmax) begin
				count = count + 1;
				end
		end
		// If Up and Free, increment forever
		else if ((updown == 1) && (freerun == 1)) begin
			count = count + 1;
		end
	end
end


endmodule
