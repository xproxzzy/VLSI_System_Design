//MUX_tb
`timescale 1ns/10ps
`include "TLC.v"

module TLC_tb;
//define wires/ regs
reg  clk, reset;
wire  HG, HY, HL, HR, VG, VY, VL, VR;
integer i;
//verify automatically
reg [7:0] ans;

always
begin
	#50;
	clk = ~clk;
end

TLC TLC0(.clk(clk), 
	.reset(reset), 
	.HG(HG), 
	.HY(HY), 
	.HL(HL), 
	.HR(HR), 
	.VG(VG), 
	.VY(VY), 
	.VL(VL), 
	.VR(VR));
	 
  initial begin 
    // You must give every input an initial value.
    // Otherwise, the value of input will be unknown.
    /////////////
    //         //
	clk=	1;
	reset=	1;
	ans=	8'b10000001;
    //         //
    /////////////
    #150 reset=	0;
	ans=	8'b10000001;
    #100 reset=	1;
	ans=	8'b10000001;
    #100 reset=	0;
    #2100 ans=	8'b01000001;
    #2100 ans=	8'b00100001;
    #2100 ans=	8'b00011000;
    #2100 ans=	8'b00010100;
    #2100 ans=	8'b00010010;
    #2100 ans=	8'b10000001;
    #200 $finish;//important
  end

  initial begin
   //monitor these signals
   $monitor ("%d,reset=%d,ans=%b",$time,reset,ans);
  end
  
  initial begin #100
    for(i=0;i<130;i=i+1)
	begin #1;
		if((HG==ans[7])&&(HY==ans[6])&&(HL==ans[5])&&(HR==ans[4])&&(VG==ans[3])&&(VY==ans[2])&&(VL==ans[1])&&(VR==ans[0]))
			$display("                    Correct");
			else
			$display("                    Error!!!\nYou have to check your circuit.");
		#99;
	end
  end
  
  initial begin
    //generate waveform
	$dumpfile("TLC.fsdb");
	$dumpvars;
	//$fsdbDumpfile("TLC.fsdb");
	//$fsdbDumpvars;
  end
  
endmodule