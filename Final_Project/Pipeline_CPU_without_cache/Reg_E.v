module Reg_E (
    input clk,
    input rst,
    input stall,
    input jb,
    input [31:0] next_pc,
    input [31:0] next_rs1_data,
    input [31:0] next_rs2_data,
    input [31:0] next_sext_imm,
    output reg [31:0] current_pc,
    output reg [31:0] current_rs1_data,
    output reg [31:0] current_rs2_data,
    output reg [31:0] current_sext_imm
);
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            current_pc <= 0;
            current_rs1_data <= 0;
            current_rs2_data <= 0;
            current_sext_imm <= 0;
        end
        else if(stall)
        begin
            current_pc <= 0;
            current_rs1_data <= 0;
            current_rs2_data <= 0;
            current_sext_imm <= 0;
        end
        else if(jb)
        begin
            current_pc <= 0;
            current_rs1_data <= 0;
            current_rs2_data <= 0;
            current_sext_imm <= 0;
        end
        else
        begin
            current_pc <= next_pc;
            current_rs1_data <= next_rs1_data;
            current_rs2_data <= next_rs2_data;
            current_sext_imm <= next_sext_imm;
        end
    end
endmodule