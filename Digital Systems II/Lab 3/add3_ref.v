
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module add3_ref(

input [2:0] in1,
input [2:0] in2,
input        ci,

output [3:0] sum
//output       co

);


assign sum = in1 + in2 + ci;


endmodule