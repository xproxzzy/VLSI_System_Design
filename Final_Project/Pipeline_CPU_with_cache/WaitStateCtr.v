
module WaitStateCtr(Load,clk,Carry);

//`define WaitClock 2'b11

input clk,Load;

output Carry;

reg [1:0] counter;
assign Carry=(counter==2'b00);

always @(posedge clk ) begin
  if(Load)
    counter<=2'b11;
  else
    counter<=counter-2'b01;
end


endmodule
