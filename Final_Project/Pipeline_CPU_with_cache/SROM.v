
module SROM(clk,address,read_data);

  input clk;
  input [15:0] address;
  output [31:0] read_data;
  
  reg [31:0] read_data;
  reg [7:0] mem [0:65535];

    always @(*)
    begin
        read_data[31:24] = mem[address + 3][7:0];
        read_data[23:16] = mem[address + 2][7:0];
        read_data[15:8] = mem[address + 1][7:0];
        read_data[7:0] = mem[address][7:0];
    end
endmodule


