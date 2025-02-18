module Mux3 (
    input [1:0] sel,
    input [31:0] operand0,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] mux_out
);
    always @(*)
    begin
        if (sel == 2'b10)
        begin
            mux_out = operand2;
        end
        else if(sel == 2'b01)
        begin
            mux_out = operand1;
        end
        else 
        begin
            mux_out = operand0;
        end
    end
endmodule