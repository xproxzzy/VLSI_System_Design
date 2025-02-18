module Adder(input [31:0] operand, output reg [31:0] adder_out);
    always @ (*)
	begin
		adder_out = operand + 4;
	end
endmodule
