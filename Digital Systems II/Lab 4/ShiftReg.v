
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module ShiftReg(

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

reg DFF0, DFF1, DFF2, DFF3, DFF4, DFF5, DFF6, DFF7, DFF8, DFF9;

assign LEDR[0] = DFF0;
assign LEDR[1] = DFF1;
assign LEDR[2] = DFF2;
assign LEDR[3] = DFF3;
assign LEDR[4] = DFF4;
assign LEDR[5] = DFF5;
assign LEDR[6] = DFF6;
assign LEDR[7] = DFF7;
assign LEDR[8] = DFF8;
assign LEDR[9] = DFF9;


//=======================================================
//  Structural coding
//=======================================================

// If KEY1 is high, and KEY0 is high and all Flip-Flops are 0, inject a 1 and take value from neighbor
always @(posedge KEY[0]) begin
	if((KEY[1] == 1) && (DFF0 == 1'b0) && (DFF1 == 1'b0) && (DFF2 == 1'b0) && (DFF3 == 1'b0) && (DFF4 == 1'b0) && (DFF5 == 1'b0) && (DFF6 == 1'b0) && (DFF7 == 1'b0) && (DFF8 == 1'b0) && (DFF9 == 1'b0))
	begin	
		DFF9 <= 1'b1;
		DFF8 <= DFF9;
		DFF7 <= DFF8;
		DFF6 <= DFF7;
		DFF5 <= DFF6;
		DFF4 <= DFF5;
		DFF3 <= DFF4;
		DFF2 <= DFF3;
		DFF1 <= DFF2;
		DFF0 <= DFF1;
	end
	// If KEY1 is high and KEY0 is high and at least one Flip-Flop is a 1, inject a 0 and take valye from neighbor
	else if((KEY[1] == 1) && ((DFF0 == 1'b1) || (DFF1 == 1'b1) || (DFF2 == 1'b1) || (DFF3 == 1'b1) || (DFF4 == 1'b1) || (DFF5 == 1'b1) || (DFF6 == 1'b1) || (DFF7 == 1'b1) || (DFF8 == 1'b1) || (DFF9 == 1'b1)))
		begin	
		DFF9 <= 1'b0;
		DFF8 <= DFF9;
		DFF7 <= DFF8;
		DFF6 <= DFF7;
		DFF5 <= DFF6;
		DFF4 <= DFF5;
		DFF3 <= DFF4;
		DFF2 <= DFF3;
		DFF1 <= DFF2;
		DFF0 <= DFF1;
	end
	// Otherwise, KEY1 is low, and KEY0 is high, set Flip-Flops to the state of the switches
	else
	begin
		DFF0 <= SW[0];
		DFF1 <= SW[1];
		DFF2 <= SW[2];
		DFF3 <= SW[3];
		DFF4 <= SW[4];
		DFF5 <= SW[5];
		DFF6 <= SW[6];
		DFF7 <= SW[7];
		DFF8 <= SW[8];
		DFF9 <= SW[9];
	end
end
endmodule