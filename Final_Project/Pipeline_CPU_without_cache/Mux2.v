module Mux2 (
    input sel,
    input [31:0] operand1,
    input [31:0] operand0,
    output reg [31:0] mux_out
);
    always @(*)
    begin
        if (sel == 1'b1)
        begin
            mux_out = operand1;
        end
        else 
        begin
            mux_out = operand0;
        end
    end
endmodule