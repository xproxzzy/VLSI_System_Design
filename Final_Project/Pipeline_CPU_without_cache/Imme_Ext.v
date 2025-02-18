module Imme_Ext (
    input [31:0] inst,
    output reg [31:0] imm_ext_out
);
    reg [4:0] opcode;
    always @(*)
    begin
	opcode[4:0] = inst[6:2];
    end
    always @(*)
    begin
        case (opcode)
            5'b01100:       //R
            begin
                
            end
            5'b01000:       //S
            begin
                imm_ext_out[31:0] = {{20{inst[31]}},inst[31:25],inst[11:7]};
            end
            5'b11000:       //B
            begin
                imm_ext_out[31:0] = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
            end
            5'b11011:       //J
            begin
                imm_ext_out[31:0] = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
            end
            5'b01101:       //U
            begin
                imm_ext_out[31:0] = {inst[31:12],12'b0};
            end
            5'b00101:       //U
            begin
                imm_ext_out[31:0] = {inst[31:12],12'b0};
            end
            default:        //I
            begin
                imm_ext_out[31:0] = {{20{inst[31]}},inst[31:20]};
            end
        endcase
    end
endmodule
