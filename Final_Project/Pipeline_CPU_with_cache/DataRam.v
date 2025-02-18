
module DataRam(Address,DataIn,DataOut,Write,clk);


input clk,Write;
input [31:0] DataIn;
input [9:0] Address;

output [31:0] DataOut;

reg [31:0] DataOut;
reg [31:0] Ram [0:1023];

always @(negedge clk) begin
  if(Write)
    Ram[Address]=DataIn;
end

always @(posedge clk) begin
  DataOut=Ram[Address];
end

endmodule
  
