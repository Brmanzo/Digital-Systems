`timescale 1ps/1ps 
module tb_lab1_part1; 
 //Stores count into a register
 reg [1:0] count; 
 //Assigns hardware to wires
 wire [7:0] HEX0; 
 wire [7:0] HEX1; 
 wire [7:0] HEX2; 
 wire [7:0] HEX3; 
 wire [7:0] HEX4; 
 wire [7:0] HEX5; 
 wire  [1:0] KEY; 
 wire [9:0] LEDR; 
 wire  [9:0] SW; 
 //Assigns count to the switches
 assign SW[1:0] = count; 
  
 // Instantiates Hardware
 lab1_part1 DUT (.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),  
   .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), 
   .KEY(KEY), .LEDR(LEDR), .SW(SW)); 
     
 // The part of the testbench that creates test input signals 
 initial begin  
//Declares count as zero 
    count = 2'b00; 
	 //Loops 4 times (for each input combination)
    repeat (4) begin 
  #100 
  //Prints all outputs after a time delay
  $display("in = %b, out = %b", count, HEX0[6]);
  $display("in = %b, out = %b", count, HEX0[5]);
  $display("in = %b, out = %b", count, HEX0[4]);
  $display("in = %b, out = %b", count, HEX0[3]);
  $display("in = %b, out = %b", count, HEX0[2]);
  $display("in = %b, out = %b", count, HEX0[1]);
  $display("in = %b, out = %b", count, HEX0[0]);
  //Increments count
  count = count + 2'b01; 
    end 
  end 
endmodule 