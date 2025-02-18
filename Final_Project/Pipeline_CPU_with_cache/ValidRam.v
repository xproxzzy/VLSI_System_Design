
module ValidRam(Address,ValidOut,Write,reset,clk);


input [9:0] Address;
input clk,reset,Write;

output ValidOut;

reg ValidOut;
reg [1023:0] ValidBit; 
integer i;

always @(posedge clk) begin
  ValidOut=ValidBit[Address];
end

always @(negedge clk) begin
  if(reset) begin
    for(i=0;i<1024;i=i+1)
      ValidBit[i]<=1'b0;
  end
  else begin
    if(Write)
      ValidBit[Address]<=1'b1;
  end
end

endmodule
