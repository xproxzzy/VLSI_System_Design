module Reg_M (
    input clk,
    input rst,
    input [31:0] next_alu_out,
    input [31:0] next_rs2_data,
    output reg [31:0] current_alu_out,
    output reg [31:0] current_rs2_data
);
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            current_alu_out <= 0;
            current_rs2_data <= 0;
        end
        else
        begin
            current_alu_out <= next_alu_out;
            current_rs2_data <= next_rs2_data;
        end
    end
endmodule