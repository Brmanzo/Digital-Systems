
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module top(

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

wire [3:0] sum_0;
wire [3:0] sum_1;

wire co0;
wire co1;

//=======================================================
//  Structural coding
//=======================================================

// Instantiating both 4-bit adders
add4bit FourBitAdder0(.a(SW[3:0]), .b(4'b0000), .ci(0), .s(sum_0), .co(co0));
add4bit FourBitAdder1(.a(SW[3:0]), .b(4'b0001), .ci(0), .s(sum_1), .co(co1));

// Displaying outputs on the 7-segment display
seg7 Display0(.s(sum_0), .display(HEX0));
seg7 Display1(.s(sum_1), .display(HEX1));

endmodule