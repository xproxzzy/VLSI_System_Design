//MUX_tb
`timescale 1ns/10ps
`include "AS.v"

module AS_tb;
//define wires/ regs
reg  [29:0] In_1;
reg  [29:0] In_2;
reg  Sel;
wire  [30:0] Out;
integer i;
//verify automatically
reg [30:0] ans;

AS AS0(	.Out(Out), 
		.In_1(In_1), 
		.In_2(In_2), 
		.Sel(Sel));

	 
  initial begin 
    // You must give every input an initial value.
    // Otherwise, the value of input will be unknown.
    /////////////
    //         //
	In_1=	0;
	In_2=	0;
	Sel=	0;
	ans=	0;
    //         //
    /////////////
    #10 In_1  = 3;
	In_2  = 4;
	Sel  = 0;
	ans  = 7;
    #10 In_1  = 7;
	In_2  = -6;
	Sel  = 0;
	ans  = 1;
    #10 In_1  = -1;
	In_2  = -2;
	Sel  = 0;
	ans  = -3;
    #10 In_1  = -9;
	In_2  = 8;
	Sel  = 0;
	ans  = -1;
    #10 In_1  = 3;
	In_2  = 4;
	Sel  = 1;
	ans  = -1;
    #10 In_1  = 7;
	In_2  = -6;
	Sel  = 1;
	ans  = 13;
    #10 In_1  = -1;
	In_2  = -2;
	Sel  = 1;
	ans  = 1;
    #10 In_1  = -9;
	In_2  = 8;
	Sel  = 1;
	ans  = -17;
    #10 In_1  = 30'b011111111111111111111111111111;
	In_2  = 30'b011111111111111111111111111111;
	Sel  = 0;
	ans  = 31'b0111111111111111111111111111110;
    #10 In_1  = 30'b100000000000000000000000000000;
	In_2  = 30'b100000000000000000000000000000;
	Sel  = 0;
	ans  = 31'b1000000000000000000000000000000;
    #10 In_1  = 30'b011111111111111111111111111111;
	In_2  = 30'b100000000000000000000000000000;
	Sel  = 1;
	ans  = 31'b0111111111111111111111111111111;
    #10 In_1  = 30'b100000000000000000000000000000;
	In_2  = 30'b011111111111111111111111111111;
	Sel  = 1;
	ans  = 31'b1000000000000000000000000000001;
    #20 $finish;//important
  end

  initial begin
   //monitor these signals
   $monitor ("%d,In_1=%d,In_2=%d,Sel=%d,Out=%d,ans=%d",$time,$signed(In_1),$signed(In_2),Sel,$signed(Out),$signed(ans));
  end
  
  initial begin 
    for(i=0;i<13;i=i+1)
	begin #1;
		if((Out)==ans)
			$display("                    Correct");
			else
			$display("                    Error!!!\nYou have to check your circuit.");
		#9;
	end
  end
  
  initial begin
    //generate waveform
	$dumpfile("AS.fsdb");
	$dumpvars;
	//$fsdbDumpfile("AS.fsdb");
	//$fsdbDumpvars;
  end
  
endmodule