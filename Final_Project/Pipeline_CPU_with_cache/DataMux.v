
module DataMux(Data0,Data1,sel,Out);


input [31:0] Data1,Data0;
input sel;

output [31:0] Out;

assign Out=sel?Data1:Data0;

endmodule
