
module TagRam(Address,TagIn,TagOut,clk,Write);

input [5:0] TagIn;
input clk,Write;
input [9:0] Address;

output [5:0] TagOut;

reg [5:0] TagOut;
reg [5:0] TagMem [0:1023];

always @(posedge clk) begin
  TagOut<=TagMem[Address];
end

always @(negedge clk) begin
  if(Write)  
    TagMem[Address]<=TagIn;
end

endmodule
