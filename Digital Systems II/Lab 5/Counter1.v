
// Bradley Manzo
// 916953788
// May 19th, 2022
// Prof Hussain Al-Asaad

module Counter1(reset, enable, divideby, clk, go, count);

input reset, enable;

input [5:0] divideby;

input clk;

output reg go;

output reg[5:0] count;

//=======================================================
//  Structural coding
//=======================================================

always @(posedge clk) begin
	// If enable is high, and reset is low, but divideby is 0, go is low
	if((enable == 1'b1) && (reset == 1'b0) && (divideby == 6'b00_0000)) begin		
		go = 1'b0;
	end
	// If enable is high, reset is low, count is less than nonzero divide by, increment
	else if((enable == 1'b1) && (reset == 1'b0) && (count < divideby - 1) && (divideby != 6'b00_0000))
	begin	
		count <= count + 1;
		go = 1'b0;
	end
	// If enable is high and reset is low, or 
	else if((enable == 1'b1) && (reset == 1'b0) && (count == divideby - 1) && (divideby != 6'b00_0000)|| (enable == 1'b1) && (reset == 1'b1) && (divideby != 6'b00_0000))
	begin
		count <= 6'b00_0000;
		go = 1'b1;
	end
end

endmodule
