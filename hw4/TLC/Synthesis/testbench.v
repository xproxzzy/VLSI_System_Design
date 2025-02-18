`timescale 1ns/1ps
`include "tsmc18.v"
`include "TLC_syn.v"

module  testbench;

reg	 	clk,reset;
wire	Horizontal_Green, Horizontal_Yellow, Horizontal_Left, Horizontal_Red, Vertical_Green, Vertical_Yellow, Vertical_Left, Vertical_Red;


TLC DUT (.Horizontal_Green(Horizontal_Green), .Horizontal_Yellow(Horizontal_Yellow), .Horizontal_Left(Horizontal_Left), .Horizontal_Red(Horizontal_Red), 
.Vertical_Green(Vertical_Green), .Vertical_Yellow(Vertical_Yellow), .Vertical_Left(Vertical_Left), .Vertical_Red(Vertical_Red), .reset(reset), .clk(clk)); 

 initial $sdf_annotate ("TLC_syn.sdf", DUT);
 
initial
begin
	clk = 1'b0;
	reset = 1;
end

initial #100 reset = 0;

always #50 clk=clk+1;

always @(negedge clk) begin
	if(Horizontal_Green==1'b1)
		$display("horizontal light : horizontal green");
	else if(Horizontal_Yellow==1'b1)
		$display("horizontal light : horizontal yellow");
	else if(Horizontal_Left==1'b1)
		$display("horizontal light : horizontal left");
	else if(Horizontal_Red==1'b1)
		$display("horizontal light : horizontal red");
	else
		$display("Wait");	
end

always @(negedge clk) begin
	if(Vertical_Green==1'b1)
		$display("vertical light : vertical green");
	else if(Vertical_Yellow==1'b1)
		$display("vertical light : vertical yellow");
	else if(Vertical_Left==1'b1)
		$display("vertical light : vertical left");
	else if(Vertical_Red==1'b1)
		$display("vertical light : vertical red");
	else
		$display("Wait");	
end

initial #9800 $finish;

initial begin
	$dumpfile("TLC_syn.fsdb");
	$dumpvars;
end

//initial begin
//	$fsdbDumpfile("TLC_syn.fsdb");
//	$fsdbDumpvars;
//end

endmodule