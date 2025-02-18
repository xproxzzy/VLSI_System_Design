module ALU (
    input [4:0] opcode,
    input [2:0] func3,
    input func7,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] alu_out
);
    always @(*)
    begin
        case (opcode)
            5'b01100:       //1
            begin
                case (func3)
                    3'b000:
                    begin
                        case (func7)
                        1'b0:alu_out = operand1 + operand2;
                        default:alu_out = operand1 - operand2;
                        endcase
                    end
                    3'b001:alu_out = operand1 << operand2[4:0];
                    3'b010:alu_out = ($signed(operand1) < $signed(operand2))?32'b1:32'b0;
                    3'b011:alu_out = (operand1 < operand2)?32'b1:32'b0;
                    3'b100:alu_out = operand1 ^ operand2;
                    3'b101:
                    begin
                        case (func7)
                        1'b0:alu_out = operand1 >> operand2[4:0];
                        default:alu_out = $signed(operand1) >>> operand2[4:0];
                        endcase
                    end
                    3'b110:alu_out = operand1 | operand2;
                    default:alu_out = operand1 & operand2; //3'b111
                endcase
            end
            5'b00100:       //2
            begin
                case (func3)
                    3'b000:alu_out = operand1 + operand2;
                    3'b010:alu_out = ($signed(operand1) < $signed(operand2))?32'b1:32'b0;
                    3'b011:alu_out = (operand1 < operand2)?32'b1:32'b0;
                    3'b100:alu_out = operand1 ^ operand2;
                    3'b110:alu_out = operand1 | operand2;
                    3'b111:alu_out = operand1 & operand2;
                    3'b001:alu_out = operand1 << operand2[4:0];
                    default: //3'b101
                    begin
                        case (func7)
                        1'b0:alu_out = operand1 >> operand2[4:0];
                        default:alu_out = $signed(operand1) >>> operand2[4:0];
                        endcase
                    end
                endcase
            end
            5'b01101:       //3
            begin
                alu_out = operand2;
            end
            5'b00101:       //4
            begin
                alu_out = operand1 + operand2;
            end
            5'b00000:       //5
            begin
                alu_out = operand1 + operand2;
            end
            5'b01000:       //6
            begin
                alu_out = operand1 + operand2;
            end
            5'b11011:       //7
            begin
                alu_out = operand1 + 4;
            end
            5'b11001:       //8
            begin
                alu_out = operand1 + 4;
            end
            5'b11000:       //9
            begin
                case (func3)
                    3'b000:alu_out = ($signed(operand1) == $signed(operand2))?32'b1:32'b0;
                    3'b001:alu_out = ($signed(operand1) != $signed(operand2))?32'b1:32'b0;
                    3'b100:alu_out = ($signed(operand1) < $signed(operand2))?32'b1:32'b0;
                    3'b101:alu_out = ($signed(operand1) >= $signed(operand2))?32'b1:32'b0;
                    3'b110:alu_out = (operand1 < operand2)?32'b1:32'b0;
                    3'b111:alu_out = (operand1 >= operand2)?32'b1:32'b0;
                    default:alu_out=32'b0;
                endcase
            end
            default:alu_out=32'b0;
        endcase
    end
endmodule
