module Reg_PC (
    input clk,
    input rst,
    input stall,
    input stop,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);
    always @(posedge clk or posedge rst)
    begin
        if(rst)
            current_pc <= 0;
        else if(stall || stop)
            current_pc <= current_pc;
        else
            current_pc <= next_pc;
    end
endmodule
