module Reg_D (
    input clk,
    input rst,
    input stall,
    input jb,
    input stop,
    input [31:0] next_pc,
    input [31:0] next_inst,
    output reg [31:0] current_pc,
    output reg [31:0] current_inst
);
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            current_pc <= 0;
            current_inst <= 0;
        end
        else if(stop)
        begin
            current_pc <= current_pc;
            current_inst <= current_inst;
        end        
        else if(stall)
        begin
            current_pc <= current_pc;
            current_inst <= current_inst;
        end
        else if(jb)
        begin
            current_pc <= 0;
            current_inst <= 32'b00000000000000000000000000010011;
        end

        else
        begin
            current_pc <= next_pc;
            current_inst <= next_inst;
        end
    end
endmodule
