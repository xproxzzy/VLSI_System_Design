//MUX_tb
`timescale 1ns/10ps
`include "Counter.v"

module Counter_tb;
//define wires/ regs
reg  clk, reset, en, sel;
wire  [5:0] out;
integer i;
//verify automatically
reg [5:0] ans;

always
begin
	#50;
	clk = ~clk;
end

Counter Counter0(.out(out), 
		.clk(clk), 
		.reset(reset),
		.en(en),
		.sel(sel));
	 
  initial begin 
    // You must give every input an initial value.
    // Otherwise, the value of input will be unknown.
    /////////////
    //         //
	clk=	1;
	reset=	1;
	en=	0;
	sel=	0;
	ans=	0;
    //         //
    /////////////
    #150 reset=	0;
	en=	1;
	sel=	0;
	ans=	1;
    #100 reset=	0;
	en=	1;
	sel=	0;
	ans=	2;
    #100 reset=	0;
	en=	0;
	sel=	0;
	ans=	2;
    #100 reset=	1;
	en=	1;
	sel=	0;
	ans=	0;
    #100 reset= 0;
	ans=	1;
    #100 ans=	2;
    #100 ans=	3;
    #100 ans=	4;
    #100 ans=	5;
    #100 ans=	6;
    #100 ans=	7;
    #100 ans=	8;
    #100 ans=	9;
    #100 ans=	10;
    #100 ans=	11;
    #100 ans=	12;
    #100 ans=	13;
    #100 ans=	14;
    #100 ans=	15;
    #100 ans=	16;
    #100 ans=	17;
    #100 ans=	18;
    #100 ans=	19;
    #100 ans=	20;
    #100 ans=	21;
    #100 ans=	22;
    #100 ans=	23;
    #100 ans=	24;
    #100 ans=	25;
    #100 ans=	26;
    #100 ans=	27;
    #100 ans=	28;
    #100 ans=	29;
    #100 ans=	30;
    #100 ans=	31;
    #100 ans=	32;
    #100 ans=	32;
    #100 sel=	1;
	ans=	31;
    #100 ans=	30;
    #100 ans=	29;
    #100 ans=	28;
    #100 ans=	27;
    #100 ans=	26;
    #100 ans=	25;
    #100 ans=	24;
    #100 ans=	23;
    #100 ans=	22;
    #100 ans=	21;
    #100 ans=	20;
    #100 ans=	19;
    #100 ans=	18;
    #100 ans=	17;
    #100 ans=	16;
    #100 ans=	15;
    #100 ans=	14;
    #100 ans=	13;
    #100 ans=	12;
    #100 ans=	11;
    #100 ans=	10;
    #100 ans=	9;
    #100 ans=	8;
    #100 ans=	7;
    #100 ans=	6;
    #100 ans=	5;
    #100 ans=	4;
    #100 ans=	3;
    #100 ans=	2;
    #100 ans=	1;
    #100 ans=	0;
    #100 ans=	0;
    #100 $finish;//important
  end

  initial begin
   //monitor these signals
   $monitor ("%d,reset=%d,en=%d,sel=%d,out=%d,ans=%d",$time,reset,en,sel,out,ans);
  end
  
  initial begin #100
    for(i=0;i<71;i=i+1)
	begin #1;
		if((out)==ans)
			$display("                    Correct");
			else
			$display("                    Error!!!\nYou have to check your circuit.");
		#99;
	end
  end
  
  initial begin
    //generate waveform
	$dumpfile("Counter.fsdb");
	$dumpvars;
	//$fsdbDumpfile("Counter.fsdb");
	//$fsdbDumpvars;
  end
  
endmodule