
// Bradley Manzo
// 916953788
// May 19th, 2022
// Prof Hussain Al-Asaad

module seg7(

input [3:0] s,

output reg [7:0] display

);
//=======================================================
//  Structural coding
//=======================================================

always @* begin
// 0
case (s)
	4'b0000: begin
	display =  8'b11000000;
	end
// 1
	4'b0001: begin
	display =  8'b11111001;
	end
// 2
	4'b0010: begin
	display = 8'b10100100;
	end
// 3
	4'b0011: begin
	display = 8'b10110000;
	end
// 4
	4'b0100: begin
	display =  8'b10011001;
	end
// 5
	4'b0101: begin
	display =  8'b10010010;
	end
// 6
	4'b0110: begin
	display =  8'b10000010;
	end
// 7
	4'b0111: begin
	display =  8'b11111000;
	end
// 8
	4'b1000: begin
	display =  8'b10000000;
	end
// 9
	4'b1001: begin
	display =  8'b10010000;
	end
// A
	4'b1010: begin
	display =  8'b10001000;
	end
// B
	4'b1011: begin
	display =  8'b10000011;
	end
// C
	4'b1100: begin
	display =  8'b11000110;
	end
// D
	4'b1101: begin
	display =  8'b10100001;
	end
// E
	4'b1110: begin
	display =  8'b10000110;
	end
// F
	4'b1111: begin
	display =  8'b10001110;
	end
endcase
end
endmodule
