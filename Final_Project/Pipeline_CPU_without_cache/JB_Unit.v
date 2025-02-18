module JB_Unit (
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] jb_out
);
    assign jb_out[31:0] = (operand1[31:0] + operand2[31:0]) & (~32'd1);
endmodule