module Reg_W (
    input clk,
    input rst,
    input stop,
    input stall,
    input PReady,
    input [31:0] next_alu_out,
    input [31:0] next_ld_data,
    output reg [31:0] current_alu_out,
    output reg [31:0] current_ld_data
);
    always @(posedge clk or posedge rst)
    begin
        if(rst) begin
            current_alu_out <= 0;
            current_ld_data <= 0;
        end
        else if(~stop & stall & PReady) begin
            current_alu_out <= next_alu_out;
            current_ld_data <= next_ld_data;
        end
        else if(stop) begin
            current_alu_out <= current_alu_out;
            current_ld_data <= current_ld_data;
        end
        else begin
            current_alu_out <= next_alu_out;
            current_ld_data <= next_ld_data;
        end
    end
endmodule
