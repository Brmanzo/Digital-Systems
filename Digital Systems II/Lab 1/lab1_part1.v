
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================
module lab1_part1(
	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,
	//////////// KEY //////////
	input 		     [1:0]		KEY,
	//////////// LED //////////
	output		     [9:0]		LEDR,
	//////////// SW //////////
	input 		     [9:0]		SW,
	//////////// GPIO, GPIO connect to GPIO Default //////////
	inout 		    [35:0]		GPIO
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg[7:0] out;
//=======================================================
//  Structural coding
//=======================================================

always @* begin

//Playing around with a 2 bit always block
//Will display 0, 1, 2, or 3 depending on 
//Different combinations of SW[1:0]
if (~SW[0]&~SW[1]) begin
	out =  8'b01000000;
	end
else if (SW[0]&~SW[1]) begin
	out =  8'b01111001;
	end
else if (~SW[0]&SW[1]) begin
	out = 8'b00100100;
	end
else if (SW[0]&SW[1]) begin
	out = 8'b00110000;
	end
end

assign HEX0 = out;

endmodule
