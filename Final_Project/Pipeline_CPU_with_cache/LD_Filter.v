module LD_Filter (
    input [2:0] func3,
    input [31:0] ld_data,
    output reg [31:0] ld_data_f
);
    always @(*)
    begin
        case (func3)
            3'b000:     //lb
            begin
                ld_data_f[31:0] = {{24{ld_data[7]}},ld_data[7:0]};
            end
            3'b001:     //lh
            begin
                ld_data_f[31:0] = {{16{ld_data[15]}},ld_data[15:0]};
            end
            3'b010:     //lw
            begin
                ld_data_f[31:0] = ld_data[31:0];
            end
            3'b100:     //lbu
            begin
                ld_data_f[31:0] = {24'b0,ld_data[7:0]};
            end
            3'b101:     //lhu
            begin
                ld_data_f[31:0] = {16'b0,ld_data[15:0]};
            end
            default:ld_data_f[31:0] = ld_data[31:0];
        endcase
    end
endmodule
